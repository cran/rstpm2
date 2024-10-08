library(rstpm2)

## for coping with weird test behaviour from CRAN and R-devel
.CRAN <- TRUE
slow <- FALSE

expect_eps <- function(expr, value, eps=1e-7)
    expect_lt(max(abs(expr-value)),eps)

context("Missing data - stpm2")
## fit0 <- stpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2[-1,])
## dput("names<-"(coef(fit0),NULL))
beta1 <- c(-7.24331354281574, -0.359486483311025, 4.75355863915738, 11.5332451005529, 
           4.56596451196539)
##
test_that("Missing event time - stpm2", {
    brcancer2 <- rstpm2::brcancer
    brcancer2$rectime[1] <- NA
    expect_warning(fit1 <<- stpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2),
                   "Some event times are NA")
    expect_eps(coef(fit1),beta1, 1e-5)
    expect_length(predict(fit1), 685)
    })

test_that("Invalid event time - stpm2", {
    brcancer2 <- rstpm2::brcancer
    brcancer2$rectime[1] <- -1
    expect_warning(fit1 <<- stpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2),
                   "Some event times <= 0")
    expect_eps(coef(fit1),beta1, 1e-5)
    expect_length(predict(fit1), 685)
})

test_that("Missing covariate - stpm2", {
    brcancer2 <- rstpm2::brcancer
    brcancer2$hormon[1] <- NA
    fit1 <- stpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2)
    expect_eps(coef(fit1),beta1, 1e-5)
    expect_length(predict(fit1), 685)
})

test_that("Missing weight - stpm2", {
    brcancer2 <- transform(rstpm2::brcancer, w=1)
    brcancer2$w[1] <- NA
    fit1 <- stpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2,weights=w)
    expect_eps(coef(fit1),beta1, 1e-5)
    expect_length(predict(fit1), 685)
})

test_that("Predictions with missing values - stpm2", {
    brcancer2 <- transform(rstpm2::brcancer, w=1)
    brcancer2$w[1] <- NA
    fit1 <- stpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2,weights=w)
    test <- c(surv=0.7230207, fail=1-0.7230207, haz=0.000335262)
    for(name in names(test))
        expect_eps(predict(fit1,newdata=data.frame(hormon=1,rectime=1000),type=name),
                   test[name], 1e-6)
    expect_eps(predict(fit1,newdata=data.frame(hormon=1,rectime=1000),type="hr",var="hormon"),
               0.6980347, 1e-6)
    expect_eps(predict(fit1,newdata=data.frame(hormon=1,rectime=1000),type="hdiff",var="hormon"),
               -0.0001012377, 1e-6)
})

test_that("Missing bhazard - stpm2", {
    set.seed(12345)
    x <- rnorm(1e3,0,0.2)
    cause1 <- rexp(1e3,1e-3*exp(x))
    other <- rexp(1e3,1e-4)
    e <- cause1<other
    y <- pmin(cause1,other)
    d <- data.frame(e,y,bg=1e-6,x)
    d$bg[1] <- NA
    fit <- stpm2(Surv(y,e)~x+bhazard(bg),data=d)
    expect_eps(coef(fit)[2], 0.9687793, 1e-5)
    fit2 <- stpm2(Surv(y,e)~x,data=d,bhazard=bg)
    expect_eps(coef(fit), coef(fit2), 1e-5)
    fit2 <- stpm2(Surv(y,e)~x,data=d,bhazard="bg")
    expect_eps(coef(fit), coef(fit2), 1e-5)
    fit2 <- stpm2(Surv(y,e)~x,data=d,bhazard=d$bg)
    expect_eps(coef(fit), coef(fit2), 1e-5)
})

## clustered data
context("Missing data - stpm2+frailty")
## brcancer2 <- rstpm2::brcancer
## brcancer2$id <- rep(1:20,length=nrow(brcancer2))
## fit2 <- stpm2(Surv(rectime,censrec==1)~hormon+cluster(id),data=brcancer2[-1,])
## dput(as.vector(coef(fit2)))
beta2 <- c(-7.24331490806604, -0.359487425124576, 4.75356131114178, 11.5332438162618, 
           4.56596139868099, -19.1138279837829)

test_that("Missing event time - stpm2+frailty(vector)", {
    brcancer2 <- rstpm2::brcancer
    brcancer2$id <- rep(1:20,length=nrow(brcancer2))
    ##
    brcancer2$rectime[1] <- NA
    expect_warning(fit2 <- stpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2,
                                 cluster=brcancer2$id),
                   "Some event times are NA")
    expect_eps(coef(fit2),beta2, 5e-6)
    expect_length(predict(fit2), 685)
})

test_that("Missing event time - stpm2+frailty(character)", {
    brcancer2 <- rstpm2::brcancer
    brcancer2$id <- rep(1:20,length=nrow(brcancer2))
    ##
    brcancer2$rectime[1] <- NA
    expect_warning(fit2 <- stpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2,
                                 cluster="id"),
                   "Some event times are NA")
    expect_eps(coef(fit2),beta2, 5e-6)
    expect_length(predict(fit2), 685)
})

test_that("Missing event time - stpm2+frailty(special)", {
    brcancer2 <- rstpm2::brcancer
    brcancer2$id <- rep(1:20,length=nrow(brcancer2))
    ##
    brcancer2$rectime[1] <- NA
    expect_warning(fit2 <- stpm2(Surv(rectime,censrec==1)~hormon+cluster(id),
                                 data=brcancer2),
                   "Some event times are NA")
    expect_eps(coef(fit2),beta2, 5e-6)
    expect_length(predict(fit2), 685)
})

test_that("Invalid event time - stpm2+frailty", {
    brcancer2 <- rstpm2::brcancer
    brcancer2$rectime[1] <- -1
    brcancer2$id <- rep(1:20,length=nrow(brcancer2))
    expect_warning(fit2 <- stpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2,
                                 cluster=brcancer2$id),
                   "Some event times <= 0")
    expect_eps(coef(fit2),beta2, 5e-6)
    expect_length(predict(fit2), 685)
})

test_that("Missing covariate - stpm2+frailty", {
    brcancer2 <- rstpm2::brcancer
    brcancer2$id <- rep(1:20,length=nrow(brcancer2))
    brcancer2$hormon[1] <- NA
    fit2 <- stpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2,
                  cluster=brcancer2$id)
    expect_eps(coef(fit2),beta2, 5e-6)
    expect_length(predict(fit2), 685)
})

test_that("Missing weight - stpm2+frailty", {
    brcancer2 <- transform(rstpm2::brcancer, w=1)
    brcancer2$id <- rep(1:20,length=nrow(brcancer2))
    brcancer2$w[1] <- NA
    fit2 <- stpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2,weights=w,
                  cluster=brcancer2$id)
    expect_eps(coef(fit2),beta2, 5e-6)
    expect_length(predict(fit2), 685)
})

test_that("Missing cluster - stpm2+frailty", {
    brcancer2 <- rstpm2::brcancer
    brcancer2$id[1] <- NA
    fit <- stpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2,
                  cluster=brcancer2$id)
    expect_eps(coef(fit)[2],-0.3594864, 1e-5)
    expect_length(predict(fit), 685)
    fit2 <- stpm2(Surv(rectime,censrec==1)~hormon+cluster(id),data=brcancer2)
    expect_eps(coef(fit),coef(fit2), 1e-10)
    fit2 <- stpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2,cluster=id)
    expect_eps(coef(fit),coef(fit2), 1e-10)
    fit2 <- stpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2,cluster="id")
    expect_eps(coef(fit),coef(fit2), 1e-10)
})


test_that("Predictions with missing values - stpm2+frailty", {
    brcancer2 <- transform(rstpm2::brcancer, w=1)
    brcancer2$id <- rep(1:20,length=nrow(brcancer2))
    brcancer2$w[1] <- NA
    fit2 <- stpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2,weights=w,
                  cluster=brcancer2$id)
    expect_eps(predict(fit2,newdata=data.frame(hormon=1,rectime=1000),type="surv"),0.7230205,1e-6)
    expect_eps(predict(fit2,newdata=data.frame(hormon=1,rectime=1000),type="fail"),0.2769795,1e-6)
    expect_eps(predict(fit2,newdata=data.frame(hormon=1,rectime=1000),type="haz"),0.0003352615,1e-6)
    test <- c(hr=0.698037012518642, hdiff=-0.000101237238923479)
    for(name in names(test))
        expect_eps(predict(fit2,newdata=data.frame(hormon=1,rectime=1000),type=name,var="hormon"),
                   test[name], 5e-6)
})

## pstpm2
context("Missing data - pstpm2")
beta3 <- c(-1.47525883324765, -0.363074906965698, -0.0297899626776523, 
           -0.00101016513169846, 0.0685630331474268, -0.0798313222245555, 
           -0.027390133765054, 0.0823829591366898, -0.060469244786851, 0.73673273581378, 
           1.17246776262782)
test_that("Missing event time - pstpm2", {
    brcancer2 <- rstpm2::brcancer
    ##
    brcancer2$rectime[1] <- NA
    expect_warning(fit3 <<- pstpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2))
    expect_length(predict(fit3), 685)
    skip_on_cran()
    expect_eps(coef(fit3),beta3, 1e-5)
})

test_that("Invalid event time - pstpm2", {
    brcancer2 <- rstpm2::brcancer
    brcancer2$rectime[1] <- -1
    expect_warning(fit3 <- pstpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2))
    expect_length(predict(fit3), 685)
    skip_on_cran()
    expect_eps(coef(fit3),beta3, 1e-5)
})

test_that("Missing covariate - pstpm2", {
    brcancer2 <- rstpm2::brcancer
    brcancer2$hormon[1] <- NA
    fit3 <- pstpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2)
    expect_length(predict(fit3), 685)
    skip_on_cran()
    expect_eps(coef(fit3),beta3, 1e-5)
})

brcancer2 <- transform(rstpm2::brcancer, w=1)
brcancer2$w[1] <- NA
fit3 <- pstpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2,weights=w)

if (!.CRAN)
    test_that("Missing weight", {
        expect_eps(coef(fit3),beta3, 1e-2)
        expect_length(predict(fit3), 685)
    })

test_that("Predictions with missing values - pstpm2", {
    test <- c(surv=0.722879512976245, fail=0.277120487023755, haz=0.000318485183272821)
    if (!.CRAN)
        for(name in names(test))
            expect_eps(predict(fit3,newdata=data.frame(hormon=1,rectime=1000),type=name),
                       test[name], 1e-6)
    test <- c(hr=0.695534588854092, hdiff=-9.69677222690393e-05)
    for(name in names(test))
        expect_eps(predict(fit3,newdata=data.frame(hormon=1,rectime=1000),type=name,var="hormon"),
                   test[name], 1e-6)
})

context("Missing data - pstpm2+frailty")
beta4 <- c(-1.48891150098253, -0.362620195776869, 0.142791036125775, -0.0566490432506788, 
           -0.116200630559352, -0.129247312130387, -0.0379901012222885, 
           0.117733248953996, -0.100057901452175, 1.09553974618122, 1.36750546720977, 
           -19.1138388712341)

if (!.CRAN && slow) {
    
    test_that("Missing event time - pstpm2+frailty", {
        brcancer2 <- rstpm2::brcancer
        brcancer2$id <- rep(1:20,length=nrow(brcancer2))
        ##
        brcancer2$rectime[1] <- NA
        expect_warning(fit4 <- pstpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2,
                                      cluster=brcancer2$id),
                       "Some event times are NA")
        expect_eps(coef(fit4),beta4, 1e-8)
        expect_length(predict(fit4), 685)
    })

    test_that("Invalid event time - pstpm2+frailty", {
        brcancer2 <- rstpm2::brcancer
        brcancer2$rectime[1] <- -1
        brcancer2$id <- rep(1:20,length=nrow(brcancer2))
        expect_warning(fit4 <- pstpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2,
                                      cluster=brcancer2$id),
                       "Some event times <= 0")
        expect_eps(coef(fit4),beta4, 1e-8)
        expect_length(predict(fit4), 685)
    })

    test_that("Missing covariate - pstpm2+frailty", {
        brcancer2 <- rstpm2::brcancer
        brcancer2$id <- rep(1:20,length=nrow(brcancer2))
        brcancer2$hormon[1] <- NA
        fit4 <<- pstpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2,
                        cluster=brcancer2$id)
        expect_eps(coef(fit4),beta4, 1e-8)
        expect_length(predict(fit4), 685)
    })

    brcancer2 <- transform(rstpm2::brcancer, w=1)
    brcancer2$id <- rep(1:20,length=nrow(brcancer2))
    brcancer2$w[1] <- NA
    fit4 <- pstpm2(Surv(rectime,censrec==1)~hormon,data=brcancer2,weights=w,
                   cluster=brcancer2$id)

    test_that("Missing weight - pstpm2+frailty", {
        expect_eps(coef(fit4),beta4, 1e-8)
        expect_length(predict(fit4), 685)
    })

    test_that("Predictions with missing values - pstpm2+frailty", {
        test <- c(surv=0.721670308241423, fail=0.278329691758577, haz=0.000312325072496861)
        for(name in names(test))
            expect_eps(predict(fit4,newdata=data.frame(hormon=1,rectime=1000),type=name),
                       test[name], 1e-3)
        test <- c(hr=0.695850670340048, hdiff=-9.4993461435916e-05)
        for(name in names(test))
            expect_eps(predict(fit4,newdata=data.frame(hormon=1,rectime=1000),type=name,var="hormon"),
                       test[name], 1e-3)
    })
}

context("Missing data - aft")
test_that("Missing event time - aft", {
    brcancer2 <- rstpm2::brcancer
    brcancer2$rectime[1] <- NA
    expect_warning(fit1 <<- aft(Surv(rectime,censrec==1)~hormon,data=brcancer2),
                   "Some event times are NA")
    expect_eps(coef(fit1)[1],0.267945, 1e-5)
    expect_length(predict(fit1), 685)
    })

test_that("Invalid event time - aft", {
    brcancer2 <- rstpm2::brcancer
    brcancer2$rectime[1] <- -1
    expect_warning(fit2 <- aft(Surv(rectime,censrec==1)~hormon,data=brcancer2),
                   "Some event times <= 0")
    expect_equal(coef(fit1), coef(fit2))
    expect_length(predict(fit2), 685)
})

test_that("Missing covariate - aft", {
    brcancer2 <- rstpm2::brcancer
    brcancer2$hormon[1] <- NA
    fit2 <- aft(Surv(rectime,censrec==1)~hormon,data=brcancer2)
    expect_equal(coef(fit1), coef(fit2))
    expect_length(predict(fit2), 685)
})

test_that("Missing weight - aft", {
    brcancer2 <- transform(rstpm2::brcancer, w=1)
    brcancer2$w[1] <- NA
    fit2 <- aft(Surv(rectime,censrec==1)~hormon,data=brcancer2,weights=w)
    expect_equal(coef(fit1),coef(fit2))
    expect_length(predict(fit2), 685)
})

test_that("Predictions with missing values - aft", {
    brcancer2 <- transform(rstpm2::brcancer, w=1)
    brcancer2$w[1] <- NA
    fit2 <- aft(Surv(rectime,censrec==1)~hormon,data=brcancer2,weights=w)
    ## test <- c(surv=0.7230207, fail=1-0.7230207, haz=0.000335262)
    expect_eps(predict(fit2, newdata=data.frame(hormon=1, rectime=1000), type="surv"),
               0.71176,
               1e-4)
    expect_eps(predict(fit2, newdata=data.frame(hormon=1, rectime=1000), type="hazard"),
               0.0004301273,
               1e-6)
})

test_that("Missing bhazard - aft", {
    set.seed(12345)
    x <- rnorm(1e3,0,0.2)
    cause1 <- rexp(1e3,1e-3*exp(x))
    other <- rexp(1e3,1e-4)
    e <- cause1<other
    y <- pmin(cause1,other)
    d <- data.frame(e,y,bg=1e-6,x)
    d$bg[1] <- NA
    fit0 <- aft(Surv(y,e)~x,data=d)
    fit1 <- aft(Surv(y,e)~x+bhazard(bg),data=d)
    expect_true(all(coef(fit0) != coef(fit1)))
    expect_eps(coef(fit1)[1], -0.9631885, 1e-5)
})
