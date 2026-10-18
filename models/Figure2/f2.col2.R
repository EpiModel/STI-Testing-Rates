
library(rstan)

# load data
rm(list = ls())
d <- readRDS("data/STI-Test_analysis.rda")
nrow(d)

dt <- dplyr::select(d, "sti.trate.symp", "age", "cuml.pnum")
dt <- dt[complete.cases(dt), ]
dim(dt)

data <- list(y = dt$sti.trate.symp,
             age = dt$age,
             pnum = dt$cuml.pnum,
             N = nrow(dt))
str(data)

fit <- stan(file = "models/f2.stan",
            data = data,
            chains = 1,
            cores = 1,
            iter = 20000,
            warmup = 1000,
            control = list(adapt_delta = 0.8),
            refresh = 100)

saveRDS(fit, file = "data/f2.fit2.rda")
