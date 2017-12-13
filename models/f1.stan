data {
  int<lower=1> N;
  int<lower=1> J;
  int<lower=1,upper=J> city[N];
  int<lower=0,upper=1> hiv[N];
  int<lower=0> y[N];
}
parameters {
  vector[J] a;
  real mu_a;
  real beta;
  vector[J] theta;
  real mu_theta;
  real<lower=0> sigma_a;
  real<lower=0> sigma_theta;
  real<lower=0> phi_y;
}
model {
  vector[N] y_hat;
  for (i in 1:N) {
    y_hat[i] = a[city[i]] + beta*hiv[i] + theta[city[i]]*hiv[i];
  }

  mu_a ~ cauchy(0.75, 5);
  sigma_a ~ normal(0.18, 0.1);
  a ~ normal(1, 5);

  beta ~ normal(0, 2);

  mu_theta ~ normal(0, 1);
  sigma_theta ~ normal(0.18, 0.1);
  theta ~ normal(0, 5);

  phi_y ~ cauchy(1, 3);

  a ~ normal(mu_a, sigma_a);
  theta ~ normal(mu_theta, sigma_theta);
  y ~ neg_binomial_2_log(y_hat, phi_y);
}
