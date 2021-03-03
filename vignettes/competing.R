
library(rstpm2)
library(biostat3)
library(splines)
library(ggplot2)

time.cut <- seq(0,10,by=1/12)
melanoma.spl <- survSplit(Surv(surv_mm/12,status=="Dead: cancer")~., data=biostat3::melanoma,
                          cut=time.cut,
                          subset=stage=="Localised")
melanoma.spl <- transform(melanoma.spl, mid=(tstop+tstart)/2, risk_time=tstop-tstart)
poisson7n <- glm(event ~ ns(mid,df=4) + agegrp + year8594 +
                     ifelse(year8594=="Diagnosed 85-94",1,0):ns(mid,df=3) +
                     offset(log(risk_time)),
                 family=poisson,
                 data=melanoma.spl)

twoState <- function(object, ...) {
    out <- as.data.frame(markov_msm(list(object),trans=matrix(c(NA,1,NA,NA),2,byrow=TRUE), ...))
    transform(subset(out, state==1),
              S=P,
              S.lower=P.lower,
              S.upper=P.upper)
}
df2 <- expand.grid(agegrp=levels(biostat3::melanoma$agegrp),
                   year8594=levels(biostat3::melanoma$year8594))
df2 <- transform(df2,risk_time=1)
df <- data.frame(agegrp="0-44", year8594="Diagnosed 75-84",
                 mid=time.cut[-1], risk_time=1)
pred <- twoState(poisson7n, t=c(0,df$mid), newdata = df2, tmvar = "mid")
ggplot(pred, aes(x=time,y=S,ymin=S.lower,ymax=S.upper,fill=year8594)) +
    ggplot2::geom_line() + ggplot2::geom_ribbon(alpha=0.6) +
    facet_grid(~agegrp) +
    xlab("Time since diagnosis (years)") +
    ylab("Survival")

competing <- function(objects, ...) {
    nCR <- length(objects)
    tmat <- matrix(c(NA,1:nCR,rep(NA,nCR*(nCR+1))),nCR+1,byrow=TRUE)
    as.data.frame(markov_msm(objects,trans=tmat, ...))
}
pred <- competing(list(poisson7n,poisson7n), t=c(0,df$mid), newdata = df2, tmvar = "mid")
## plot for state 1
ggplot(subset(pred,state==1), aes(x=time,y=P,ymin=P.lower,ymax=P.upper,fill=year8594)) +
    ggplot2::geom_line() + ggplot2::geom_ribbon(alpha=0.6) +
    facet_grid(~agegrp) +
    xlab("Time since diagnosis (years)") +
    ylab("Survival")
## plot for state 2 (this would be the same for state 3, because the transition rates are identical)
ggplot(subset(pred,state==2), aes(x=time,y=P,ymin=P.lower,ymax=P.upper,fill=year8594)) +
    ggplot2::geom_line() + ggplot2::geom_ribbon(alpha=0.6) +
    facet_grid(~agegrp) +
    xlab("Time since diagnosis (years)") +
    ylab("Survival")
