### R code from vignette source 'Introduction.Rnw'
### Encoding: UTF-8

###################################################
### code chunk number 1: Introduction.Rnw:85-89
###################################################

options(width=80,useFancyQuotes="UTF-8")
library(rstpm2)



###################################################
### code chunk number 2: Introduction.Rnw:224-235
###################################################

fit <- stpm2(Surv(rectime,censrec==1)~hormon,
             data=brcancer, df=4)
summary(fit)

## utility to exponentiate the ith components
expi <- function(x,i=1:length(x)) { x[i] <- exp(x[i]); x }
fit.cox <- coxph(Surv(rectime,censrec==1)~hormon, data=brcancer)
rbind(coxph=coef(summary(fit.cox)),
      stpm2=expi(coef(summary(fit))["hormon",c(1,1,2:4)],2))



###################################################
### code chunk number 3: Introduction.Rnw:242-249
###################################################

# tms=seq(0,10,length=301)[-1]
plot(fit,newdata=data.frame(hormon=1), 
     xlab="Time since diagnosis (days)")
lines(fit, newdata=data.frame(hormon=0), col=2, lty=2)
legend("topright", c("hormon=1","hormon=0"),lty=1:2,col=1:2,bty="n")



###################################################
### code chunk number 4: Introduction.Rnw:254-261
###################################################

# tms=seq(0,10,length=301)[-1]
plot(fit,newdata=data.frame(hormon=1), type="hazard",
     xlab="Time since diagnosis (days)", ylim=c(0,8e-4))
lines(fit, newdata=data.frame(hormon=0), col=2, lty=2, type="hazard")
legend("topright", c("hormon=1","hormon=0"),lty=1:2,col=1:2,bty="n")



###################################################
### code chunk number 5: Introduction.Rnw:270-276
###################################################

plot(fit,newdata=data.frame(hormon=0), type="hdiff",
     exposed=function(data) transform(data, hormon=1),
     main="hormon=1 compared with hormon=0",
     xlab="Time since diagnosis (days)")



###################################################
### code chunk number 6: Introduction.Rnw:279-285
###################################################

plot(fit,newdata=data.frame(hormon=0), type="sdiff",
     exposed=function(data) transform(data, hormon=1),
     main="hormon=1 compared with hormon=0",
     xlab="Time since diagnosis (days)")



###################################################
### code chunk number 7: Introduction.Rnw:308-312
###################################################

options(width=80,useFancyQuotes="UTF-8")
library(rstpm2)



###################################################
### code chunk number 8: Introduction.Rnw:314-327
###################################################

popmort2 <- transform(rstpm2::popmort,exitage=age,exityear=year,age=NULL,year=NULL)
colon2 <- within(rstpm2::colon, {
  status <- ifelse(surv_mm>120.5,1,status)
  tm <- pmin(surv_mm,120.5)/12
  exit <- dx+tm*365.25
  sex <- as.numeric(sex)
  exitage <- pmin(floor(age+tm),99)
  exityear <- floor(yydx+tm)
  ##year8594 <- (year8594=="Diagnosed 85-94")
})
colon2 <- merge(colon2,popmort2)



###################################################
### code chunk number 9: Introduction.Rnw:331-336
###################################################

fit0 <- stpm2(Surv(tm,status %in% 2:3)~I(year8594=="Diagnosed 85-94"),
              data=colon2,
              bhazard=colon2$rate, df=5)



###################################################
### code chunk number 10: Introduction.Rnw:338-345
###################################################

summary(fit <- stpm2(Surv(tm,status %in% 2:3)~I(year8594=="Diagnosed 85-94"),
                     data=colon2,
                     bhazard=colon2$rate,
                     df=5,cure=TRUE))
predict(fit,head(colon2),se.fit=TRUE)



###################################################
### code chunk number 11: Introduction.Rnw:363-370
###################################################

newdata.eof <- data.frame(year8594 = unique(colon2$year8594),
                          tm=10)
1-predict(fit0, newdata.eof, type="surv", se.fit=TRUE)
1-predict(fit, newdata.eof, type="surv", se.fit=TRUE)
predict(fit, newdata.eof, type="haz", se.fit=TRUE)



###################################################
### code chunk number 12: Introduction.Rnw:374-389
###################################################

tms=seq(0,10,length=301)[-1]
plot(fit0,newdata=data.frame(year8594 = "Diagnosed 85-94", tm=tms), ylim=0:1,
     xlab="Time since diagnosis (years)", ylab="Relative survival")
plot(fit0,newdata=data.frame(year8594 = "Diagnosed 75-84",tm=tms),
     add=TRUE,line.col="red",rug=FALSE)
## warnings: Predicted hazards less than zero for cure
plot(fit,newdata=data.frame(year8594 = "Diagnosed 85-94",tm=tms),
     add=TRUE,ci=FALSE,lty=2,rug=FALSE)
plot(fit,newdata=data.frame(year8594="Diagnosed 75-84",tm=tms),
     add=TRUE,rug=FALSE,line.col="red",ci=FALSE,lty=2)
legend("topright",c("85-94 without cure","75-84 without cure",
                    "85-94 with cure","75-84 with cure"),
       col=c(1,2,1,2), lty=c(1,1,2,2), bty="n")



###################################################
### code chunk number 13: Introduction.Rnw:396-413
###################################################

plot(fit0,newdata=data.frame(year8594 = "Diagnosed 85-94", tm=tms), 
     ylim=c(0,0.5), type="hazard",
     xlab="Time since diagnosis (years)",ylab="Excess hazard")
plot(fit0,newdata=data.frame(year8594 = "Diagnosed 75-84", tm=tms),
     type="hazard",
     add=TRUE,line.col="red",rug=FALSE)
plot(fit,newdata=data.frame(year8594 = "Diagnosed 85-94", tm=tms),
     type="hazard",
     add=TRUE,ci=FALSE,lty=2,rug=FALSE)
plot(fit,newdata=data.frame(year8594="Diagnosed 75-84", tm=tms),
     type="hazard",
     add=TRUE,rug=FALSE,line.col="red",ci=FALSE,lty=2)
legend("topright",c("85-94 without cure","75-84 without cure",
                    "85-94 with cure","75-84 with cure"),
       col=c(1,2,1,2), lty=c(1,1,2,2), bty="n")



