
library(rstan)

# load data
rm(list = ls())
d <- readRDS("data/STI-Test_analysis.rda")
nrow(d)

dt <- dplyr::select(d, "sti.trate.asymp", "race.cat", "age", "hiv", "cuml.pnum", "city2")
dt <- dt[complete.cases(dt), ]
dim(dt)

race.black <- ifelse(dt$race.cat == "black", 1, 0)
race.white <- ifelse(dt$race.cat == "white", 1, 0)
race.hisp <- ifelse(dt$race.cat == "hispanic", 1, 0)
race.oth <- ifelse(dt$race.cat == "other", 1, 0)

y <- ifelse(dt$sti.trate.asymp == 0, 1, 0)
table(y)

data <- list(y = y,
             race_black = race.black,
             race_hisp = race.hisp,
             race_oth = race.oth,
             age = dt$age,
             hiv = dt$hiv,
             pnum = dt$cuml.pnum,
             city = as.numeric(as.factor(dt$city2)),
             N = nrow(dt),
             J = length(unique(dt$city2)))
str(data)

fit <- stan(file = "models/t3.stan",
            data = data,
            chains = 1,
            cores = 1,
            iter = 20000,
            warmup = 2000,
            control = list(adapt_delta = 0.9),
            refresh = 100)

saveRDS(fit, file = "data/t3.fit3.rda")
