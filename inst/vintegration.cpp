// https://git.savannah.gnu.org/cgit/gsl.git/tree/integration/qk.c
// GPL >= 3

#include <float.h>
#include <math.h>
#include <stdio.h>
#include <iostream>
#include <armadillo>
#include <vector>

using std::vector;

#define GSL_FN_EVAL(F,x) (*((F)->function))(x,(F)->params)
#define GSL_DBL_EPSILON        2.2204460492503131e-16
#define GSL_DBL_MIN        2.2250738585072014e-308
#define GSL_ERROR(s) printf(s); return 1;
#define 	GSL_ERROR_VAL(reason, value)   return value ;
#define RETURN_IF_NULL(x) if (!x) { return ; }

using namespace arma;

vec pmax(vec V1, vec V2) {
  vec out = V1;
  out(V2 > V1) = V2(V2>V1);
  return out;
}
vec pmin(vec V1, vec V2) {
  vec out = V1;
  out(V2 < V1) = V2(V2<V1);
  return out;
}

struct vec_gsl_function 
{
  vec (* function) (double x, void * params);
  void * params;
};

class vec_gsl_integration {
public:
  size_t limit;
  size_t size;
  size_t nrmax;
  size_t i;
  size_t maximum_level;
  vector<double> alist;
  vector<double> blist;
  vector<vec> rlist;
  vector<vec> elist;
  vector<size_t> order;
  vector<size_t> level;
  vec_gsl_integration(size_t n, double a=0.0, double b=1.0) {
    alist.resize(n);
    blist.resize(n);
    rlist.resize(n);
    elist.resize(n);
    order.resize(n);
    level.resize(n);
    initialise(a,b);
    limit = n;
  }
  void initialise(double a, double b) {
    alist.clear();
    blist.clear();
    rlist.clear();
    elist.clear();
    order.clear();
    level.clear();
    size = 0;
    nrmax = 0;
    i = 0;
    alist[0] = a;
    blist[0] = b;
    order[0] = 0;
    level[0] = 0;
    maximum_level = 0;
  }
  void set_initial_result (vec result, vec error) {
    size = 1;
    rlist[0] = result;
    elist[0] = error;
  }
  
  void qpsrt () {
    const size_t last = size - 1;

    double errmax ;
    double errmin ;
    int i, k, top;

    size_t i_nrmax = nrmax;
    size_t i_maxerr = order[i_nrmax] ;
  
    /* Check whether the list contains more than two error estimates */

    if (last < 2) 
      {
	order[0] = 0 ;
	order[1] = 1 ;
	this->i = i_maxerr ;
	return ;
      }

    errmax = max(elist[i_maxerr]);

    /* This part of the routine is only executed if, due to a difficult
       integrand, subdivision increased the error estimate. In the normal
       case the insert procedure should start after the nrmax-th largest
       error estimate. */

    while (i_nrmax > 0 && errmax > max(elist[order[i_nrmax - 1]])) 
      {
	order[i_nrmax] = order[i_nrmax - 1] ;
	i_nrmax-- ;
      } 

    /* Compute the number of elements in the list to be maintained in
       descending order. This number depends on the number of
       subdivisions still allowed. */
  
    if(last < (limit/2 + 2)) 
      {
	top = last ;
      }
    else
      {
	top = limit - last + 1;
      }
  
    /* Insert errmax by traversing the list top-down, starting
       comparison from the element elist(order(i_nrmax+1)). */
  
    i = i_nrmax + 1 ;
  
    /* The order of the tests in the following line is important to
       prevent a segmentation fault */

    while (i < top && errmax < max(elist[order[i]]))
      {
	order[i-1] = order[i] ;
	i++ ;
      }
  
	order[i-1] = i_maxerr ;
  
    /* Insert errmin by traversing the list bottom-up */
  
    errmin = max(elist[last]);
  
    k = top - 1 ;
  
    while (k > i - 2 && errmin >= max(elist[order[k]]))
      {
	order[k+1] = order[k] ;
	k-- ;
      }
  
	order[k+1] = last ;

    /* Set i_max and e_max */

    i_maxerr = order[i_nrmax] ;
  
    this->i = i_maxerr ;
    this->nrmax = i_nrmax ;
  }

  void update (double a1, double b1, vec area1, vec error1,
	       double a2, double b2, vec area2, vec error2)
  {

    const size_t i_max = this->i ;
    const size_t i_new = this->size ;

    const size_t new_level = this->level[i_max] + 1;

    /* append the newly-created intervals to the list */
  
    if (max(error2) > max(error1))
      {
	alist[i_max] = a2;        /* blist[maxerr] is already == b2 */
	rlist[i_max] = area2;
	elist[i_max] = error2;
	level[i_max] = new_level;
      
	alist[i_new] = a1;
	blist[i_new] = b1;
	rlist[i_new] = area1;
	elist[i_new] = error1;
	level[i_new] = new_level;
      }
    else
      {
	blist[i_max] = b1;        /* alist[maxerr] is already == a1 */
	rlist[i_max] = area1;
	elist[i_max] = error1;
	level[i_max] = new_level;
      
	alist[i_new] = a2;
	blist[i_new] = b2;
	rlist[i_new] = area2;
	elist[i_new] = error2;
	level[i_new] = new_level;
      }
  
    this->size++;

    if (new_level > this->maximum_level)
      {
	this->maximum_level = new_level;
      }

    qpsrt () ;
  }

  vec sum_results ()
  {
    const size_t n = size;

    size_t k;
    vec result_sum(rlist[0].size());

    for (k = 0; k < n; k++)
      {
	result_sum += rlist[k];
      }
  
    return result_sum;
  }

  int
  subinterval_too_small (double a1, double a2, double b2)
  {
    const double e = GSL_DBL_EPSILON;
    const double u = GSL_DBL_MIN;

    double tmp = (1 + 100 * e) * (fabs (a2) + 1000 * u);

    int status = fabs (a1) <= tmp && fabs (b2) <= tmp;

    return status;
  }

  vec
  rescale_error (vec err, const vec result_abs, const vec result_asc)
  {
    err = abs(err) ;

    if (max(result_asc) != 0 && max(err) != 0)
      {
	vec scale = pow((200 * err / result_asc), 1.5) ;
	uvec index = scale < 1;
	if (max(index) < err.size())
	  err(index) = result_asc(index) % scale(index) ;
	index = scale >= 1;
	if (max(index) < err.size())
	  err(index) = result_asc(index) ;
      }
    uvec index = (result_abs > GSL_DBL_MIN / (50 * GSL_DBL_EPSILON));
    if (max(index) < err.size())
      err(index) = pmax(50 * GSL_DBL_EPSILON * result_abs(index),
			err(index));
    return err ;
  }

  void
  q21 (const vec_gsl_function * f, double a, double b,
       vec *result, vec *abserr,
       vec *resabs, vec *resasc)
  {

    static const int n = 11;
    static const double xgk[11] =   /* abscissae of the 21-point Kronrod rule */
      {
	0.995657163025808080735527280689003,
	0.973906528517171720077964012084452,
	0.930157491355708226001207180059508,
	0.865063366688984510732096688423493,
	0.780817726586416897063717578345042,
	0.679409568299024406234327365114874,
	0.562757134668604683339000099272694,
	0.433395394129247190799265943165784,
	0.294392862701460198131126603103866,
	0.148874338981631210884826001129720,
	0.000000000000000000000000000000000
      };

    /* xgk[1], xgk[3], ... abscissae of the 10-point Gauss rule. 
       xgk[0], xgk[2], ... abscissae to optimally extend the 10-point Gauss rule */

    static const double wg[5] =     /* weights of the 10-point Gauss rule */
      {
	0.066671344308688137593568809893332,
	0.149451349150580593145776339657697,
	0.219086362515982043995534934228163,
	0.269266719309996355091226921569469,
	0.295524224714752870173892994651338
      };

    static const double wgk[11] =   /* weights of the 21-point kronrod rule */
      {
	0.011694638867371874278064396062192,
	0.032558162307964727478818972459390,
	0.054755896574351996031381300244580,
	0.075039674810919952767043140916190,
	0.093125454583697605535065465083366,
	0.109387158802297641899210590325805,
	0.123491976262065851077958109831074,
	0.134709217311473325928054001771707,
	0.142775938577060080797094273138717,
	0.147739104901338491374841515972068,
	0.149445554002916905664936468389821
      };
    vec fv1[11], fv2[11];
    const double center = 0.5 * (a + b);
    const double half_length = 0.5 * (b - a);
    const double abs_half_length = fabs (half_length);
    const vec f_center = GSL_FN_EVAL (f, center);

    vec result_gauss = f_center*0.0;
    vec result_kronrod = f_center * wgk[n - 1];

    vec result_abs = abs (result_kronrod);
    vec result_asc;
    vec mean;
    vec err;

    int j;

    if (n % 2 == 0)
      {
	result_gauss = f_center * wg[n / 2 - 1];
      }

    for (j = 0; j < (n - 1) / 2; j++)
      {
	const int jtw = j * 2 + 1;  /* in original fortran j=1,2,3 jtw=2,4,6 */
	const double abscissa = half_length * xgk[jtw];
	const vec fval1 = GSL_FN_EVAL (f, center - abscissa);
	const vec fval2 = GSL_FN_EVAL (f, center + abscissa);
	const vec fsum = fval1 + fval2;
	fv1[jtw] = fval1;
	fv2[jtw] = fval2;
	result_gauss += wg[j] * fsum;
	result_kronrod += wgk[jtw] * fsum;
	result_abs += wgk[jtw] * (abs (fval1) + abs (fval2));
      }

    for (j = 0; j < n / 2; j++)
      {
	int jtwm1 = j * 2;
	const double abscissa = half_length * xgk[jtwm1];
	const vec fval1 = GSL_FN_EVAL (f, center - abscissa);
	const vec fval2 = GSL_FN_EVAL (f, center + abscissa);
	fv1[jtwm1] = fval1;
	fv2[jtwm1] = fval2;
	result_kronrod += wgk[jtwm1] * (fval1 + fval2);
	result_abs += wgk[jtwm1] * (abs (fval1) + abs (fval2));
      };

    mean = result_kronrod * 0.5;

    result_asc = wgk[n - 1] * abs (f_center - mean);

    for (j = 0; j < n - 1; j++)
      {
	result_asc += wgk[j] * (abs (fv1[j] - mean) + abs (fv2[j] - mean));
      }

    /* scale by the width of the integration region */

    err = (result_kronrod - result_gauss) * half_length;

    result_kronrod *= half_length;
    result_abs *= abs_half_length;
    result_asc *= abs_half_length;

    *result = result_kronrod;
    *resabs = result_abs;
    *resasc = result_asc;
    *abserr = rescale_error (err, result_abs, result_asc); // Probably wrong:(

  }

  int
  qag (const vec_gsl_function * f,
       const double a, const double b,
       const double epsabs, const double epsrel,
       const size_t limit,
       vec *result, vec *abserr)
  {
    vec area, errsum;
    vec result0, abserr0, resabs0, resasc0;
    vec tolerance;
    size_t iteration = 0;
    int roundoff_type1 = 0, roundoff_type2 = 0, error_type = 0;

    vec round_off;     

    /* Initialize results */

    initialise(a,b);

    if (limit > this->limit)
      {
	GSL_ERROR ("iteration limit exceeded") ;
      }

    if (epsabs <= 0 && (epsrel < 50 * GSL_DBL_EPSILON || epsrel < 0.5e-28))
      {
	GSL_ERROR ("tolerance cannot be achieved with given epsabs and epsrel");
      }

    /* perform the first integration */

    q21 (f, a, b, &result0, &abserr0, &resabs0, &resasc0);

    set_initial_result (result0, abserr0);

    /* Test on accuracy */

    tolerance = pmax (result0*0.0+epsabs, epsrel * abs (result0));

    /* need IEEE rounding here to match original quadpack behavior */

    round_off = 50.0 * GSL_DBL_EPSILON * resabs0;

    if (max(abserr0) <= max(round_off) && max(abserr0) > max(tolerance))
      {
	*result = result0;
	*abserr = abserr0;

	GSL_ERROR ("cannot reach tolerance because of roundoff error "
		   "on first attempt");
      }
    else if ((max(abserr0) <= max(tolerance) && max(abserr0) != max(resasc0)) || max(abserr0) == 0.0)
      {
	*result = result0;
	*abserr = abserr0;

	return 0;
      }
    else if (limit == 1)
      {
	*result = result0;
	*abserr = abserr0;

	GSL_ERROR ("a maximum of one iteration was insufficient");
      }

    area = result0;
    errsum = abserr0;

    iteration = 1;

    do
      {
	double a1, b1, a2, b2;
	double a_i, b_i;
	vec r_i, e_i;
	vec area1, area2, area12;
	vec error1, error2, error12;
	vec resasc1, resasc2;
	vec resabs1, resabs2;

	/* Bisect the subinterval with the largest error estimate */

	a_i = alist[i];
	b_i = blist[i];
	r_i = rlist[i];
	e_i = elist[i];

	a1 = a_i; 
	b1 = 0.5 * (a_i + b_i);
	a2 = b1;
	b2 = b_i;

	q21 (f, a1, b1, &area1, &error1, &resabs1, &resasc1);
	q21 (f, a2, b2, &area2, &error2, &resabs2, &resasc2);

	area12 = area1 + area2;
	error12 = error1 + error2;

	errsum += (error12 - e_i);
	area += area12 - r_i;

	if (max(resasc1) != max(error1) && max(resasc2) != max(error2))
	  {
	    vec delta = r_i - area12;

	    if (max(abs (delta)) <= 1.0e-5 * max(abs (area12)) && max(error12) >= 0.99 * max(e_i))
	      {
		roundoff_type1++;
	      }
	    if (iteration >= 10 && max(error12) > max(e_i))
	      {
		roundoff_type2++;
	      }
	  }

	// tolerance = pmax (epsabs, epsrel * abs (area));
	tolerance = epsrel * abs (area);
	tolerance(tolerance>epsabs) = tolerance(tolerance>epsabs)*0.0+epsabs;

	if (max(errsum) > max(tolerance))
	  {
	    if (roundoff_type1 >= 6 || roundoff_type2 >= 20)
	      {
		error_type = 2;   /* round off error */
	      }

	    /* set error flag in the case of bad integrand behaviour at
	       a point of the integration range */

	    if (subinterval_too_small (a1, a2, b2))
	      {
		error_type = 3;
	      }
	  }

	update (a1, b1, area1, error1, a2, b2, area2, error2);

	a_i = alist[i];
	b_i = blist[i];
	r_i = rlist[i];
	e_i = elist[i];

	iteration++;
	// std::cout << iteration << std::endl;

      }
    while (iteration < limit && !error_type && max(errsum) > max(tolerance));

    *result = sum_results();
    *abserr = errsum;

    if (max(errsum) <= max(tolerance))
      {
	return 0;
      }
    else if (error_type == 2)
      {
	GSL_ERROR ("roundoff error prevents tolerance from being achieved");
      }
    else if (error_type == 3)
      {
	GSL_ERROR ("bad integrand behavior found in the integration interval");
      }
    else if (iteration == limit)
      {
	GSL_ERROR ("maximum number of subdivisions reached");
      }
    else
      {
	GSL_ERROR ("could not integrate function");
      }
    return 0;
  }
  
};

vec use_log(double x, void *) {
  vec y{std::log(x), std::exp(x)};
  // std::cout << x << " " << y[0] << " " << y[1] << std::endl;
  return y;
}

int main() {
  vec result(2);
  vec abserr(2);
  vec_gsl_function f;
  f.function = &use_log;
  vec_gsl_integration ws(1000);
  ws.qag (&f, 0.0, 1.0, 1.0e-6, 1.0e-6, 1000,
	  &result, &abserr);
  vec expected{-1.0,std::exp(1.0)-1};
  std::cout << result-expected << " " << abserr << std::endl;
  return 0;

}
