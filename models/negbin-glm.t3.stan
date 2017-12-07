data {
  int<lower=1> N;                 // rows of data
  int<lower=1> J;                 // unique cities
  int<lower=1,upper=J> city[N];   // predictor
  int<lower=0,upper=1> hiv[N];
  int<lower=0> y[N];              // response
}
parameters {
  vector[J] a;                    // city intercepts
  real mu_a;
  real beta;
  vector[J] theta;
  real mu_theta;
  real<lower=0> sigma_a;          // dispersion parameters
  real<lower=0> sigma_theta;
  real<lower=0> phi_y;
}
model {
  vector[N] y_hat;
  for (i in 1:N) {
    y_hat[i] = a[city[i]] + beta*hiv[i] + theta[city[i]]*hiv[i];
  }

  mu_a ~ cauchy(1, 5);
  sigma_a ~ cauchy(0, 2.5);
  a ~ cauchy(1, 5);

  beta ~ normal(0, 5);

  mu_theta ~ cauchy(0, 5);
  sigma_theta ~ cauchy(0, 5);
  theta ~ normal(0, 5);

  phi_y ~ cauchy(0, 3);

  a ~ normal(mu_a, sigma_a);
  theta ~ normal(mu_theta, sigma_theta);
  y ~ neg_binomial_2_log(y_hat, phi_y);
}
