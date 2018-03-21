
##
## Bacterial STI Screening Rates by Symptomatic Status
##   among Men Who Have Sex with Men in the United States:
##       A Hierarchical Bayesian Analysis
## Primary Data Analysis Script
## Author: Samuel M. Jenness
## Date: March 21, 2018
##


# Setup -------------------------------------------------------------------

# packages
library(rstan)
library(ggplot2)
library(tidyverse)

# summary fx
qn <- function(x, d = 3) round(quantile(x, c(0.5, 0.025, 0.975)), d)

# read original data
d <- readRDS("data/STI-Test_analysis.rda")
nrow(d)

# define the main descriptive data set
dt <- dplyr::select(d, "sti.trate.all", "race.cat", "age",
                    "hiv", "cuml.pnum", "city2")
dt <- dt[complete.cases(dt), ]
dim(dt)

g <- group_by(dt, city2)
s <- summarise(g, m = mean(sti.trate.all))
as.data.frame(s)
sd(log(s$m)) # 0.1735808, 0.4099506, 0.1868862

## CSDE uploads/downloads

system("scp data/STI-Test_analysis.rda union:~/stan/data")
system("scp models/*.* union:~/stan/models")

# R CMD BATCH --vanilla models/t2.col1.R &
# R CMD BATCH --vanilla models/t2.col2.R &
# R CMD BATCH --vanilla models/t2.col3.R &
#
# R CMD BATCH --vanilla models/f1.col1.R &
# R CMD BATCH --vanilla models/f1.col2.R &
# R CMD BATCH --vanilla models/f1.col3.R &
#
# R CMD BATCH --vanilla models/f2.col1.R &
# R CMD BATCH --vanilla models/f2.col2.R &
# R CMD BATCH --vanilla models/f2.col3.R &
#
# R CMD BATCH --vanilla models/t3.col1.R &
# R CMD BATCH --vanilla models/t3.col2.R &
# R CMD BATCH --vanilla models/t3.col3.R &
#
# R CMD BATCH --vanilla models/ts2.col1.R &
# R CMD BATCH --vanilla models/ts2.col2.R &

system("scp union:~/stan/data/*.rda data/")

# Table 1: descriptive ----------------------------------------------------

# read original data
d <- readRDS("data/STI-Test_analysis.rda")
nrow(d)

# define the main descriptive data set
dt <- dplyr::select(d, "sti.trate.all", "race.cat", "age",
                    "hiv", "cuml.pnum", "city2")
dt <- dt[complete.cases(dt), ]
dim(dt)

cbind(table(dt$city2), round(prop.table(table(dt$city2)), 3))

cbind(table(dt$race.cat), round(prop.table(table(dt$race.cat)), 3))

mean(dt$age)
median(dt$age)
sd(dt$age)

cbind(table(dt$hiv), round(prop.table(table(dt$hiv)), 3))

mean(dt$cuml.pnum)
median(dt$cuml.pnum)
sd(dt$cuml.pnum)


# Table 2: main model -----------------------------------------------------

## All testing ##

fit <- readRDS("data/t2.fit1.rda")

print(fit, digits = 3, probs = c(0.025, 0.5, 0.975))

df <- as.data.frame(fit)
cbind(names(df))
names(df)[1:24] <- levels(as.factor(dt$city2))
names(df)[26:32] <- c("black", "hisp", "oth", "age", "agesq", "hiv", "pnum")
head(df)

qn(df$mu_a - log(2))
qn(df$Atlanta - log(2))
qn(df$Boston - log(2))
qn(df$Chicago - log(2))
qn(df$Dallas - log(2))
qn(df$Denver - log(2))
qn(df$Detroit - log(2))
qn(df$Houston - log(2))
qn(df$`Los Angeles` - log(2))
qn(df$Miami - log(2))
qn(df$`New York City` - log(2))
qn(df$Philadelphia - log(2))
qn(df$`San Diego` - log(2))
qn(df$`San Francisco` - log(2))
qn(df$Seattle - log(2))
qn(df$Washington - log(2))

qn(df$zOther1 - log(2))
qn(df$zOther2 - log(2))
qn(df$zOther3 - log(2))
qn(df$zOther4 - log(2))
qn(df$zOther5 - log(2))
qn(df$zOther6 - log(2))
qn(df$zOther7 - log(2))
qn(df$zOther8 - log(2))
qn(df$zOther9 - log(2))

qn(df$black)
qn(df$hisp)
qn(df$oth)

qn(df$age)
qn(df$agesq, d = 4)

qn(df$hiv)

qn(df$pnum)

qn(df$phi_y)


## Symptomatic testing ##

fit <- readRDS("data/t2.fit2.rda")

print(fit, digits = 3, probs = c(0.025, 0.5, 0.975))

df <- as.data.frame(fit)
cbind(names(df))
names(df)[1:24] <- levels(as.factor(dt$city2))
names(df)[26:32] <- c("black", "hisp", "oth", "age", "agesq", "hiv", "pnum")
head(df)

qn(df$mu_a - log(2))
qn(df$Atlanta - log(2))
qn(df$Boston - log(2))
qn(df$Chicago - log(2))
qn(df$Dallas - log(2))
qn(df$Denver - log(2))
qn(df$Detroit - log(2))
qn(df$Houston - log(2))
qn(df$`Los Angeles` - log(2))
qn(df$Miami - log(2))
qn(df$`New York City` - log(2))
qn(df$Philadelphia - log(2))
qn(df$`San Diego` - log(2))
qn(df$`San Francisco` - log(2))
qn(df$Seattle - log(2))
qn(df$Washington - log(2))

qn(df$zOther1 - log(2))
qn(df$zOther2 - log(2))
qn(df$zOther3 - log(2))
qn(df$zOther4 - log(2))
qn(df$zOther5 - log(2))
qn(df$zOther6 - log(2))
qn(df$zOther7 - log(2))
qn(df$zOther8 - log(2))
qn(df$zOther9 - log(2))

qn(df$black)
qn(df$hisp)
qn(df$oth)

qn(df$age)
qn(df$agesq, d = 4)

qn(df$hiv)

qn(df$pnum)

qn(df$phi_y)

## Asymptomatic testing ##

fit <- readRDS("data/t2.fit3.rda")

print(fit, digits = 3, probs = c(0.025, 0.5, 0.975))

df <- as.data.frame(fit)
cbind(names(df))
names(df)[1:24] <- levels(as.factor(dt$city2))
names(df)[26:32] <- c("black", "hisp", "oth", "age", "agesq", "hiv", "pnum")
head(df)

qn(df$mu_a - log(2))
qn(df$Atlanta - log(2))
qn(df$Boston - log(2))
qn(df$Chicago - log(2))
qn(df$Dallas - log(2))
qn(df$Denver - log(2))
qn(df$Detroit - log(2))
qn(df$Houston - log(2))
qn(df$`Los Angeles` - log(2))
qn(df$Miami - log(2))
qn(df$`New York City` - log(2))
qn(df$Philadelphia - log(2))
qn(df$`San Diego` - log(2))
qn(df$`San Francisco` - log(2))
qn(df$Seattle - log(2))
qn(df$Washington - log(2))

qn(df$zOther1 - log(2))
qn(df$zOther2 - log(2))
qn(df$zOther3 - log(2))
qn(df$zOther4 - log(2))
qn(df$zOther5 - log(2))
qn(df$zOther6 - log(2))
qn(df$zOther7 - log(2))
qn(df$zOther8 - log(2))
qn(df$zOther9 - log(2))

qn(df$black)
qn(df$hisp)
qn(df$oth)

qn(df$age)
qn(df$agesq, d = 4)

qn(df$hiv)

qn(df$pnum)

qn(df$phi_y)



# Table 3: logit never testing model --------------------------------------

## All testing ##

fit <- readRDS("data/t3.fit1.rda")

print(fit, digits = 3, probs = c(0.025, 0.5, 0.975))

df <- as.data.frame(fit)
cbind(names(df))
names(df)[1:24] <- levels(as.factor(dt$city2))
names(df)[26:32] <- c("black", "hisp", "oth", "age", "agesq", "hiv", "pnum")
head(df)

qn(df$mu_a)
qn(df$Atlanta)
qn(df$Boston)
qn(df$Chicago)
qn(df$Dallas)
qn(df$Denver)
qn(df$Detroit)
qn(df$Houston)
qn(df$`Los Angeles`)
qn(df$Miami)
qn(df$`New York City`)
qn(df$Philadelphia)
qn(df$`San Diego`)
qn(df$`San Francisco`)
qn(df$Seattle)
qn(df$Washington)

qn(df$zOther1)
qn(df$zOther2)
qn(df$zOther3)
qn(df$zOther4)
qn(df$zOther5)
qn(df$zOther6)
qn(df$zOther7)
qn(df$zOther8)
qn(df$zOther9)

qn(df$black)
qn(df$hisp)
qn(df$oth)

qn(df$age)
qn(df$agesq, d = 4)

qn(df$hiv)

qn(df$pnum)


## Symptomatic testing ##

fit <- readRDS("data/t3.fit2.rda")

print(fit, digits = 3, probs = c(0.025, 0.5, 0.975))

df <- as.data.frame(fit)
cbind(names(df))
names(df)[1:24] <- levels(as.factor(dt$city2))
names(df)[26:32] <- c("black", "hisp", "oth", "age", "agesq", "hiv", "pnum")
head(df)

qn(df$mu_a)
qn(df$Atlanta)
qn(df$Boston)
qn(df$Chicago)
qn(df$Dallas)
qn(df$Denver)
qn(df$Detroit)
qn(df$Houston)
qn(df$`Los Angeles`)
qn(df$Miami)
qn(df$`New York City`)
qn(df$Philadelphia)
qn(df$`San Diego`)
qn(df$`San Francisco`)
qn(df$Seattle)
qn(df$Washington)

qn(df$zOther1)
qn(df$zOther2)
qn(df$zOther3)
qn(df$zOther4)
qn(df$zOther5)
qn(df$zOther6)
qn(df$zOther7)
qn(df$zOther8)
qn(df$zOther9)

qn(df$black)
qn(df$hisp)
qn(df$oth)

qn(df$age)
qn(df$agesq, d = 4)

qn(df$hiv)

qn(df$pnum)


## Asymptomatic Screening ##

fit <- readRDS("data/t3.fit3.rda")

print(fit, digits = 3, probs = c(0.025, 0.5, 0.975))

df <- as.data.frame(fit)
cbind(names(df))
names(df)[1:24] <- levels(as.factor(dt$city2))
names(df)[26:32] <- c("black", "hisp", "oth", "age", "agesq", "hiv", "pnum")
head(df)

qn(df$mu_a)
qn(df$Atlanta)
qn(df$Boston)
qn(df$Chicago)
qn(df$Dallas)
qn(df$Denver)
qn(df$Detroit)
qn(df$Houston)
qn(df$`Los Angeles`)
qn(df$Miami)
qn(df$`New York City`)
qn(df$Philadelphia)
qn(df$`San Diego`)
qn(df$`San Francisco`)
qn(df$Seattle)
qn(df$Washington)

qn(df$zOther1)
qn(df$zOther2)
qn(df$zOther3)
qn(df$zOther4)
qn(df$zOther5)
qn(df$zOther6)
qn(df$zOther7)
qn(df$zOther8)
qn(df$zOther9)

qn(df$black)
qn(df$hisp)
qn(df$oth)

qn(df$age)
qn(df$agesq, d = 4)

qn(df$hiv)

qn(df$pnum)



# Figure 1: HIV*city predictions (Table S1) -------------------------------

## All testing ##

fit <- readRDS("data/f1.fit1.rda")

# city specific
df.city <- as.data.frame(fit, par = "a")
df.hiv <- as.data.frame(fit, par = "beta")
df.int <- as.data.frame(fit, par = "theta")

# HIV-
df0 <- exp(df.city - log(2))
names(df0) <- levels(as.factor(dt$city2))

# HIV+
df1 <- df0
for (i in 1:ncol(df1)) {
  df1[, i] <- exp(df.city[, i] - log(2) + df.hiv + df.int[, i])
}
names(df1) <- levels(dt$city2)

df0 <- select(df0, -starts_with("z"))
df1 <- select(df1, -starts_with("z"))

df0$HIV <- "neg"
df1$HIV <- "pos"

head(df0)
head(df1)

df <- rbind(df0, df1)
table(df$HIV)

dfg <- gather(df, key = "city", value = "coef", -HIV)
head(dfg)
dfg$city[which(dfg$city == "New York City")] <- "NYC"
dfg$city[which(dfg$city == "Philadelphia")] <- "Philly"
dfg$city[which(dfg$city == "San Diego")] <- "SD"
dfg$city[which(dfg$city == "San Francisco")] <- "SF"
dfg$city[which(dfg$city == "Los Angeles")] <- "LA"

table(dfg$HIV, dfg$city)

pdf(file = "../paper/Fig1.pdf", h = 5, w = 9)
ggplot(dfg, aes(x = city, y = coef, fill = HIV), alpha = 0.5) +
  geom_boxplot(outlier.alpha = 0, fatten = 0.7, lwd = 0.4, col = "grey10") +
  scale_y_continuous(limits = c(0, 3.0)) +
  scale_fill_brewer(palette = "Set1") +
  labs(x = "City", y = "Rate") +
  theme_bw()
dev.off()



# Figure 2: age * testing type --------------------------------------------

## All testing ##

fit <- readRDS("data/f2.fit1.rda")

print(fit, digits = 3, probs = c(0.025, 0.5, 0.975))

df <- as.data.frame(fit)
names(df)[1:4] <- c("alpha", "age", "agesq", "pnum")
head(df)

ages <- 15:65

pred <- matrix(NA, ncol = length(ages), nrow = nrow(df))
for (ii in 1:ncol(pred)) {
  pred[, ii] <- exp(df$alpha - log(2) + df$age*ages[ii] + df$agesq*(ages[ii]^2) + df$pnum*5)
}
pred <- as.data.frame(pred)
names(pred) <- paste0("age", ages)
head(pred)

est <- apply(pred, 2, median)
lwr <- apply(pred, 2, quantile, 0.025)
upr <- apply(pred, 2, quantile, 0.975)

pred.all <- as.data.frame(cbind(est, lwr, upr))
pred.all$age <- ages


## Symptomatic testing ##

fit <- readRDS("data/f2.fit2.rda")

print(fit, digits = 3, probs = c(0.025, 0.5, 0.975))

df <- as.data.frame(fit)
names(df)[1:4] <- c("alpha", "age", "agesq", "pnum")
head(df)

ages <- 15:65

pred <- matrix(NA, ncol = length(ages), nrow = nrow(df))
for (ii in 1:ncol(pred)) {
  pred[, ii] <- exp(df$alpha - log(2) + df$age*ages[ii] + df$agesq*(ages[ii]^2) + df$pnum*5)
}
pred <- as.data.frame(pred)
names(pred) <- paste0("age", ages)
head(pred)

est <- apply(pred, 2, median)
lwr <- apply(pred, 2, quantile, 0.025)
upr <- apply(pred, 2, quantile, 0.975)

pred.symp <- as.data.frame(cbind(est, lwr, upr))
pred.symp$age <- ages
pred.symp


## Asymptomatic screening ##

fit <- readRDS("data/f2.fit3.rda")

print(fit, digits = 3, probs = c(0.025, 0.5, 0.975))

df <- as.data.frame(fit)
names(df)[1:4] <- c("alpha", "age", "agesq", "pnum")
head(df)

ages <- 15:65

pred <- matrix(NA, ncol = length(ages), nrow = nrow(df))
for (ii in 1:ncol(pred)) {
  pred[, ii] <- exp(df$alpha - log(2) + df$age*ages[ii] + df$agesq*(ages[ii]^2) + df$pnum*5)
}
pred <- as.data.frame(pred)
names(pred) <- paste0("age", ages)
head(pred)

est <- apply(pred, 2, median)
lwr <- apply(pred, 2, quantile, 0.025)
upr <- apply(pred, 2, quantile, 0.975)

pred.asymp <- as.data.frame(cbind(est, lwr, upr))
pred.asymp$age <- ages
pred.asymp

# plot
pdf(file = "../paper/Fig2.pdf", h = 5, w = 9)
pal <- RColorBrewer::brewer.pal(3, "Set1")
pal.a <- adjustcolor(pal, alpha.f = 0.3)
par(mar = c(3,3,1,1), mgp = c(2,1,0))
plot(ages, pred.all$est, type = "n", ylim = c(0, 1.3), ylab = "Rate", xlab = "Ages")
grid()
lines(ages, pred.all$est, col = pal[1], lwd = 1.3)
polygon(x = c(ages, rev(ages)), y = c(pred.all$lwr, rev(pred.all$upr)), col = pal.a[1], border = NA)
lines(ages, pred.symp$est, col = pal[2], lwd = 1.3)
polygon(x = c(ages, rev(ages)), y = c(pred.symp$lwr, rev(pred.symp$upr)), col = pal.a[2], border = NA)
lines(ages, pred.asymp$est, col = pal[3], lwd = 1.3)
polygon(x = c(ages, rev(ages)), y = c(pred.asymp$lwr, rev(pred.asymp$upr)), col = pal.a[3], border = NA)
legend("topright", legend = c("All", "Sympt", "Asympt"), col = pal, lwd = 2, cex = 0.9, bty = "n")
dev.off()



# Table S1: HIV*city interaction (Figure 1) -------------------------------

## All testing ##

fit <- readRDS("data/f1.fit1.rda")

print(fit, digits = 3, probs = c(0.025, 0.5, 0.975))

# city-averaged
df <- as.data.frame(fit, par = c("mu_a", "beta", "mu_theta"))

qn(exp(df$mu_a - log(2)), 2)
qn(exp(df$mu_a - log(2) + df$beta + df$mu_theta), 2)

# city specific
df.city <- as.data.frame(fit, par = "a")
df.hiv <- as.data.frame(fit, par = "beta")
df.int <- as.data.frame(fit, par = "theta")
head(df.city)
head(df.hiv)
head(df.int)

# HIV-
df <- exp(df.city - log(2))
names(df) <- levels(as.factor(dt$city2))

qn(df$Atlanta, 2)
qn(df$Boston, 2)
qn(df$Chicago, 2)
qn(df$Dallas, 2)
qn(df$Denver, 2)
qn(df$Detroit, 2)
qn(df$Houston, 2)
qn(df$`Los Angeles`, 2)
qn(df$Miami, 2)
qn(df$`New York City`, 2)
qn(df$Philadelphia, 2)
qn(df$`San Diego`, 2)
qn(df$`San Francisco`, 2)
qn(df$Seattle, 2)
qn(df$Washington, 2)

# HIV+

for (i in 1:ncol(df)) {
  df[, i] <- exp(df.city[, i] - log(2) + df.hiv + df.int[, i])
}
names(df) <- levels(dt$city2)

qn(df$Atlanta, 2)
qn(df$Boston, 2)
qn(df$Chicago, 2)
qn(df$Dallas, 2)
qn(df$Denver, 2)
qn(df$Detroit, 2)
qn(df$Houston, 2)
qn(df$`Los Angeles`, 2)
qn(df$Miami, 2)
qn(df$`New York City`, 2)
qn(df$Philadelphia, 2)
qn(df$`San Diego`, 2)
qn(df$`San Francisco`, 2)
qn(df$Seattle, 2)
qn(df$Washington, 2)


## Symptomatic testing ##

fit <- readRDS("data/f1.fit2.rda")
print(fit, digits = 3, probs = c(0.025, 0.5, 0.975))
#shinystan::launch_shinystan(fit)

# city-averaged
df <- as.data.frame(fit, par = c("mu_a", "beta", "mu_theta"))

qn(exp(df$mu_a - log(2)), 2)
qn(exp(df$mu_a - log(2) + df$beta + df$mu_theta), 2)

# city specific
df.city <- as.data.frame(fit, par = "a")
df.hiv <- as.data.frame(fit, par = "beta")
df.int <- as.data.frame(fit, par = "theta")
head(df.city)
head(df.hiv)
head(df.int)

# HIV-
df <- exp(df.city - log(2))
names(df) <- levels(as.factor(dt$city2))

qn(df$Atlanta, 2)
qn(df$Boston, 2)
qn(df$Chicago, 2)
qn(df$Dallas, 2)
qn(df$Denver, 2)
qn(df$Detroit, 2)
qn(df$Houston, 2)
qn(df$`Los Angeles`, 2)
qn(df$Miami, 2)
qn(df$`New York City`, 2)
qn(df$Philadelphia, 2)
qn(df$`San Diego`, 2)
qn(df$`San Francisco`, 2)
qn(df$Seattle, 2)
qn(df$Washington, 2)

# HIV+
for (i in 1:ncol(df)) {
  df[, i] <- exp(df.city[, i] - log(2) + df.hiv + df.int[, i])
}
names(df) <- levels(dt$city2)

qn(df$Atlanta, 2)
qn(df$Boston, 2)
qn(df$Chicago, 2)
qn(df$Dallas, 2)
qn(df$Denver, 2)
qn(df$Detroit, 2)
qn(df$Houston, 2)
qn(df$`Los Angeles`, 2)
qn(df$Miami, 2)
qn(df$`New York City`, 2)
qn(df$Philadelphia, 2)
qn(df$`San Diego`, 2)
qn(df$`San Francisco`, 2)
qn(df$Seattle, 2)
qn(df$Washington, 2)


## Asymptomatic screening ##

fit <- readRDS("data/f1.fit3.rda")
print(fit, digits = 3, probs = c(0.025, 0.5, 0.975))
#shinystan::launch_shinystan(fit)

# city-averaged
df <- as.data.frame(fit, par = c("mu_a", "beta", "mu_theta"))

qn(exp(df$mu_a - log(2)), 2)
qn(exp(df$mu_a - log(2) + df$beta + df$mu_theta), 2)

# city specific
df.city <- as.data.frame(fit, par = "a")
df.hiv <- as.data.frame(fit, par = "beta")
df.int <- as.data.frame(fit, par = "theta")
head(df.city)
head(df.hiv)
head(df.int)
df <- exp(df.city - log(2))
names(df) <- levels(as.factor(dt$city2))

qn(df$Atlanta, 2)
qn(df$Boston, 2)
qn(df$Chicago, 2)
qn(df$Dallas, 2)
qn(df$Denver, 2)
qn(df$Detroit, 2)
qn(df$Houston, 2)
qn(df$`Los Angeles`, 2)
qn(df$Miami, 2)
qn(df$`New York City`, 2)
qn(df$Philadelphia, 2)
qn(df$`San Diego`, 2)
qn(df$`San Francisco`, 2)
qn(df$Seattle, 2)
qn(df$Washington, 2)


# HIV+
for (i in 1:ncol(df)) {
  df[, i] <- exp(df.city[, i] - log(2) + df.hiv + df.int[, i])
}
names(df) <- levels(dt$city2)

qn(df$Atlanta, 2)
qn(df$Boston, 2)
qn(df$Chicago, 2)
qn(df$Dallas, 2)
qn(df$Denver, 2)
qn(df$Detroit, 2)
qn(df$Houston, 2)
qn(df$`Los Angeles`, 2)
qn(df$Miami, 2)
qn(df$`New York City`, 2)
qn(df$Philadelphia, 2)
qn(df$`San Diego`, 2)
qn(df$`San Francisco`, 2)
qn(df$Seattle, 2)
qn(df$Washington, 2)



# Table S2: Testing Rates, Removing Never Testers --------------------------

## All testing ##

fit <- readRDS("data/ts2.fit1.rda")

print(fit, digits = 3, probs = c(0.025, 0.5, 0.975))

df <- as.data.frame(fit)
names(df)[1:24] <- levels(as.factor(dt$city2))
names(df)[26:32] <- c("black", "hisp", "oth", "age", "agesq", "hiv", "pnum")
head(df)

qn(df$mu_a - log(2))
qn(df$Atlanta - log(2))
qn(df$Boston - log(2))
qn(df$Chicago - log(2))
qn(df$Dallas - log(2))
qn(df$Denver - log(2))
qn(df$Detroit - log(2))
qn(df$Houston - log(2))
qn(df$`Los Angeles` - log(2))
qn(df$Miami - log(2))
qn(df$`New York City` - log(2))
qn(df$Philadelphia - log(2))
qn(df$`San Diego` - log(2))
qn(df$`San Francisco` - log(2))
qn(df$Seattle - log(2))
qn(df$Washington - log(2))

qn(df$zOther1 - log(2))
qn(df$zOther2 - log(2))
qn(df$zOther3 - log(2))
qn(df$zOther4 - log(2))
qn(df$zOther5 - log(2))
qn(df$zOther6 - log(2))
qn(df$zOther7 - log(2))
qn(df$zOther8 - log(2))
qn(df$zOther9 - log(2))

qn(df$black)
qn(df$hisp)
qn(df$oth)

qn(df$age)
qn(df$agesq, d = 5)

qn(df$hiv)

qn(df$pnum)

qn(df$phi_y)


## Asymptomatic testing ##

fit <- readRDS("data/ts2.fit2.rda")

print(fit, digits = 3, probs = c(0.025, 0.5, 0.975))

df <- as.data.frame(fit)
names(df)[1:24] <- levels(as.factor(dt$city2))
names(df)[26:32] <- c("black", "hisp", "oth", "age", "agesq", "hiv", "pnum")
head(df)

qn(df$mu_a - log(2))
qn(df$Atlanta - log(2))
qn(df$Boston - log(2))
qn(df$Chicago - log(2))
qn(df$Dallas - log(2))
qn(df$Denver - log(2))
qn(df$Detroit - log(2))
qn(df$Houston - log(2))
qn(df$`Los Angeles` - log(2))
qn(df$Miami - log(2))
qn(df$`New York City` - log(2))
qn(df$Philadelphia - log(2))
qn(df$`San Diego` - log(2))
qn(df$`San Francisco` - log(2))
qn(df$Seattle - log(2))
qn(df$Washington - log(2))

qn(df$zOther1 - log(2))
qn(df$zOther2 - log(2))
qn(df$zOther3 - log(2))
qn(df$zOther4 - log(2))
qn(df$zOther5 - log(2))
qn(df$zOther6 - log(2))
qn(df$zOther7 - log(2))
qn(df$zOther8 - log(2))
qn(df$zOther9 - log(2))

qn(df$black)
qn(df$hisp)
qn(df$oth)

qn(df$age)
qn(df$agesq, d = 5)

qn(df$hiv)

qn(df$pnum)

qn(df$phi_y)


# Hold --------------------------------------------------------------------

# ndf <- as.data.frame(stanfit)
# a <- rnbinom(1e5, mu = exp(ndf[, 1]), size = exp(ndf$phi_y))
# quantile(a, probs = c(0.5, 0.025, 0.975))
