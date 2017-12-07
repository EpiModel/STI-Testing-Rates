data {
  int<lower=1> N;    // rows of data
  vector[N] hiv;       // predictor
  int<lower=0> y[N]; // response
}
parameters {
  real<lower=0> phi; // neg. binomial dispersion parameter
  real alpha;  // intercept
  real beta;  // slope
}
model {
  // priors:
  // phi ~ cauchy(0, 3);
  // b0 ~ normal(0, 5);
  // b1 ~ normal(0, 5);
  // data model:
  y ~ neg_binomial_2_log(alpha + beta*hiv, phi);
}
