\name{coef<-}
\alias{coef<-}
\alias{coef<-.default}
\title{Set Model Coefficients}
\description{
  \code{coef<-} is a generic function which sets the model coefficients
  for an object returned by modelling functions.
}
\usage{
coef(x) <- value
}
\arguments{
  \item{x}{an \R object.}
  \item{value}{values of the coefficients.}
}
\value{
  The updated object.
}
\details{
  \code{coef<-} is a generic replacement function.  The default method sets
  the \code{"coefficients"} components of a list.

}
%% \note{
%% }
\seealso{
  \code{\link{coef}}.
}
%% \references{
%% }
%% \examples{
%% }
% \keyword{attribute}
