\name{aft_mixture-class}
\Rdversion{1.1}
\docType{class}
\alias{aft_mixture-class}
\alias{plot,aft_mixture,missing-method}
\alias{predict,aft_mixture-method}
\alias{predictnl,aft_mixture-method}
%\alias{summary,aft_mixture-method}

\title{Class "stpm2" ~~~ }
\description{Regression object for \code{aft_mixture}.}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("aft_mixture", ...)} and
\code{aft_mixture( ...)}.
}
\section{Slots}{
	 \describe{
    \item{\code{args}:}{Object of class \code{"list"} ~~ }
  }
}
\section{Extends}{
Class \code{"\linkS4class{mle2}"}, directly.
}
\section{Methods}{
  \describe{
    \item{plot}{\code{signature(x = "aft_mixture", y = "missing")}: ... }
    \item{predict}{\code{signature(object = "aft_mixture")}: ... }
    \item{predictnl}{\code{signature(object = "aft_mixture", ...)}: ... }
    %\item{summary}{\code{signature(object = "aft_mixture", ...)}: ... }
	 }
}
%% \references{ ~put references to the literature/web site here ~ }
%% \author{ ~~who you are~~ }
%% \note{ ~~further notes~~ }

% ~Make other sections like Warning with \section{Warning }{....} ~

%% \seealso{
%% 	~~objects to See Also as \code{\link{~~fun~~}}, ~~~
%% 	or \code{\linkS4class{CLASSNAME}} for links to other classes
%% }
\examples{
showClass("aft_mixture")
}
\keyword{classes}
