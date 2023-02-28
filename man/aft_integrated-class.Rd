\name{aft_integrated-class}
\Rdversion{1.1}
\docType{class}
\alias{aft_integrated-class}
\alias{plot,aft_integrated,missing-method}
\alias{predict,aft_integrated-method}
\alias{predictnl,aft_integrated-method}
%\alias{summary,aft_integrated-method}

\title{Class "stpm2" ~~~ }
\description{Regression object for \code{aft_integrated}.}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("aft_integrated", ...)} and
\code{aft_integrated( ...)}.
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
    \item{plot}{\code{signature(x = "aft_integrated", y = "missing")}: ... }
    \item{predict}{\code{signature(object = "aft_integrated")}: ... }
    \item{predictnl}{\code{signature(object = "aft_integrated", ...)}: ... }
    %\item{summary}{\code{signature(object = "aft_integrated", ...)}: ... }
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
showClass("aft_integrated")
}
\keyword{classes}
