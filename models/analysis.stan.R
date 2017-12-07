
library(rstan)
library(ggplot2)
library(tidyverse)

setwd("~/Dropbox/Projects/ETN-001/Products/STI-Test/STI-Testing-Rates")

# load data
rm(list = ls())
d <- readRDS("data/STI-Test_analysis.rda")



# City only model ---------------------------------------------------------

# non-Bayes approach

mod <- glm(sti.trate.all ~ city2 - 1, data = d, family = poisson)
summary(mod)
round(cbind(exp(coef(mod))/2, exp(confint(mod))/2), 3)


# bayes no pool model (each city treated independently)

dt <- dplyr::select(d, sti.trate.all, city2)
dt <- dt[complete.cases(dt), ]
dim(dt)

data <- list(y = dt$sti.trate.all,
             city = as.numeric(dt$city2),
             N = nrow(dt),
             J = length(unique(dt$city2)))
str(data)

fit.city <- stan(file = "models/negbin-glm.city.stan",
                data = data,
                chains = 4,
                cores = 4,
                iter = 6000,
                warmup = 1000,
                control = list(adapt_delta = 0.8))

print(fit.city)
traceplot(fit.city, par = "a[1]", alpha = 0.5)

plot(fit.city, par = "a")

# summarize yearly rates
df <- as.data.frame(fit.city, par = "a")
colnames(df) <- levels(dt$city2)
df <- exp(df)/2
df <- select(df, -starts_with("zOther"))
dfg <- gather(df)
head(dfg)
table(dfg$key)

ggplot(dfg, aes(key, value)) +
  geom_boxplot(fill = "steelblue2", outlier.alpha = 0, fatten = 0.75) +
  scale_y_continuous(limits = c(0.5, 2.0)) +
  theme_bw()

t(round(apply(df, 2, function(x) quantile(x, probs = c(0.5, 0.025, 0.975))), 2))

# estimates match empirical means
mean(dt$sti.trate.all[dt$city2 == "Atlanta"])/2
mean(dt$sti.trate.all[dt$city2 == "San Francisco"])/2
mean(dt$sti.trate.all[dt$city2 == "Philadelphia"])/2

# similar to non-bayes estimates
round(cbind(exp(coef(mod))/2, exp(confint(mod))/2), 3)


# city multi-level model

fit.city2 <- stan(file = "models/negbin-glm.city.mlm.stan",
                 data = data,
                 chains = 4,
                 cores = 4,
                 iter = 6000,
                 warmup = 1000,
                 control = list(adapt_delta = 0.8))

print(fit.city2)

df2 <- as.data.frame(fit.city2, par = "a")
colnames(df2) <- levels(dt$city2)
df2 <- exp(df2)/2
df2 <- select(df2, -starts_with("zOther"))
dfg2 <- gather(df2)
head(dfg2)
table(dfg2$key)

ggplot(dfg2, aes(key, value)) +
  geom_boxplot(fill = "steelblue2", outlier.alpha = 0, fatten = 0.75) +
  scale_y_continuous(limits = c(0.5, 2.0)) +
  theme_bw()

t(round(apply(df2, 2, function(x) quantile(x, probs = c(0.5, 0.025, 0.975))), 2))


# city and division mlm

dt <- dplyr::select(d, sti.trate.all, city, div)
dt <- dt[complete.cases(dt), ]
dim(dt)
str(dt)

data <- list(y = dt$sti.trate.all,
             city = as.numeric(as.factor(dt$city)),
             div = dt$div,
             N = nrow(dt),
             J = length(unique(dt$city)),
             D = length(unique(dt$div)))
str(data)

fit.city3 <- stan(file = "models/negbin-glm.city.div.mlm.stan",
                 data = data,
                 chains = 4,
                 cores = 4,
                 iter = 6000,
                 warmup = 1000,
                 control = list(adapt_delta = 0.8),
                 refresh = 100)

print(fit.city3)



# Table 2: main effects model ---------------------------------------------

## All testing

dt <- dplyr::select(d, sti.trate.all, race.cat, age, hiv, cuml.pnum, city2)
dt <- dt[complete.cases(dt), ]
dim(dt)

race.black <- ifelse(dt$race.cat == "black", 1, 0)
race.white <- ifelse(dt$race.cat == "white", 1, 0)
race.hisp <- ifelse(dt$race.cat == "hispanic", 1, 0)
race.oth <- ifelse(dt$race.cat == "other", 1, 0)

data <- list(y = dt$sti.trate.all,
             race_black = race.black,
             race_hisp = race.hisp,
             race_oth = race.oth,
             age = dt$age,
             hiv = dt$hiv,
             pnum = dt$cuml.pnum,
             city = as.numeric(dt$city2),
             N = nrow(dt),
             J = length(unique(dt$city2)))
str(data)

t2.fit <- stan(file = "models/negbin-glm.t2.stan",
               data = data,
               chains = 4,
               cores = 4,
               iter = 6000,
               warmup = 2000,
               control = list(adapt_delta = 0.9),
               refresh = 100)

print(t2.fit, digits = 3, probs = c(0.025, 0.5, 0.975))


## Symptomatic testing

dt <- dplyr::select(d, sti.trate.symp, race.cat, age, hiv, cuml.pnum, city2)
dt <- dt[complete.cases(dt), ]
dim(dt)

race.black <- ifelse(dt$race.cat == "black", 1, 0)
race.white <- ifelse(dt$race.cat == "white", 1, 0)
race.hisp <- ifelse(dt$race.cat == "hispanic", 1, 0)
race.oth <- ifelse(dt$race.cat == "other", 1, 0)

data <- list(y = dt$sti.trate.symp,
             race_black = race.black,
             race_hisp = race.hisp,
             race_oth = race.oth,
             age = dt$age,
             hiv = dt$hiv,
             pnum = dt$cuml.pnum,
             city = as.numeric(dt$city2),
             N = nrow(dt),
             J = length(unique(dt$city2)))
str(data)

t2.fit2 <- stan(file = "models/negbin-glm.t2.stan",
               data = data,
               chains = 4,
               cores = 4,
               iter = 10000,
               warmup = 2000,
               control = list(adapt_delta = 0.9),
               refresh = 100)

print(t2.fit2, digits = 3, probs = c(0.025, 0.5, 0.975))


## Asymptomatic testing

dt <- dplyr::select(d, sti.trate.asymp, race.cat, age, hiv, cuml.pnum, city2)
dt <- dt[complete.cases(dt), ]
dim(dt)

race.black <- ifelse(dt$race.cat == "black", 1, 0)
race.white <- ifelse(dt$race.cat == "white", 1, 0)
race.hisp <- ifelse(dt$race.cat == "hispanic", 1, 0)
race.oth <- ifelse(dt$race.cat == "other", 1, 0)

data <- list(y = dt$sti.trate.asymp,
             race_black = race.black,
             race_hisp = race.hisp,
             race_oth = race.oth,
             age = dt$age,
             hiv = dt$hiv,
             pnum = dt$cuml.pnum,
             city = as.numeric(dt$city2),
             N = nrow(dt),
             J = length(unique(dt$city2)))
str(data)

t2.fit3 <- stan(file = "models/negbin-glm.t2.stan",
                data = data,
                chains = 4,
                cores = 4,
                iter = 10000,
                warmup = 2000,
                control = list(adapt_delta = 0.9),
                refresh = 100)

print(t2.fit3, digits = 3, probs = c(0.025, 0.5, 0.975))





# Table 3: HIV*city interaction model -------------------------------------

## All testing

dt <- dplyr::select(d, sti.trate.all, city2, hiv)
dt <- dt[complete.cases(dt), ]
dim(dt)

data <- list(y = dt$sti.trate.all,
             city = as.numeric(dt$city2),
             hiv = dt$hiv,
             N = nrow(dt),
             J = length(unique(dt$city2)))

stanfit <- stan(file = "models/negbin-glm.mlm.stan",
                data = data,
                chains = 6,
                cores = 6,
                iter = 5000,
                warmup = 1000,
                control = list(adapt_delta = 0.8))

print(stanfit)

df <- as.data.frame(stanfit, par = c("a", "beta", "theta"))
head(df)

df.city <- select(df, starts_with("a"))
df.hiv <- select(df, "beta")
df.int <- select(df, starts_with("theta"))

df.hiv0 <- exp(df.city)/2
df.hiv1 <- df.hiv0
for (i in 1:ncol(df.hiv1)) {
  df.hiv1[, i] <- exp(df.city[, i] + df.hiv + df.int[, i])/2
}
names(df.hiv0) <- names(df.hiv1) <- levels(dt$city2)

t(round(apply(df.hiv0, 2, function(x) quantile(x, probs = c(0.5, 0.025, 0.975))), 2))
t(round(apply(df.hiv1, 2, function(x) quantile(x, probs = c(0.5, 0.025, 0.975))), 2))

mean(dt$sti.trate.all[dt$city2 == "Houston" & dt$hiv == 1])/2



## hold

ndf <- as.data.frame(stanfit)
a <- rnbinom(1e5, mu = exp(ndf[, 1]), size = exp(ndf$phi_y))
quantile(a, probs = c(0.5, 0.025, 0.975))
