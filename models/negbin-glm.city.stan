data {
  int<lower=1> N;                 // rows of data
  int<lower=1> J;                 // unique cities
  int<lower=1,upper=J> city[N];   // predictor
  int<lower=0> y[N];              // response
}
parameters {
  vector[J] a;              // county intercepts
  real mu_a;
  real<lower=0> sigma_a;    // dispersion parameters
  real<lower=0> phi_y;
}
model {
  vector[N] y_hat;
  for (i in 1:N) {
    y_hat[i] = a[city[i]];
  }

  mu_a ~ cauchy(1, 5);
  sigma_a ~ cauchy(0, 2);
  a ~ cauchy(1, 5);
  phi_y ~ cauchy(0, 3);

  a ~ normal(mu_a, sigma_a);
  y ~ neg_binomial_2_log(y_hat, phi_y);
}
