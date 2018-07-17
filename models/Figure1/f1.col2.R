
library(rstan)

# load data
rm(list = ls())
d <- readRDS("data/STI-Test_analysis.rda")
nrow(d)

dt <- dplyr::select(d, "sti.trate.symp", "city2", "hiv")
dt <- dt[complete.cases(dt), ]
dim(dt)

data <- list(y = dt$sti.trate.symp,
             city = as.numeric(as.factor(dt$city2)),
             hiv = dt$hiv,
             N = nrow(dt),
             J = length(unique(dt$city2)))
str(data)

fit <- stan(file = "models/f1.stan",
            data = data,
            chains = 1,
            cores = 1,
            iter = 20000,
            warmup = 2000,
            control = list(adapt_delta = 0.95),
            refresh = 100)

saveRDS(fit, file = "data/f1.fit2.rda")
