data {
  int<lower=1> N;
  int<lower=0> age[N];
  int<lower=0> pnum[N];
  int<lower=0> y[N];
}
parameters {
  vector[4] beta;
  real<lower=0> phi_y;
}
model {
  vector[N] y_hat;
  for (i in 1:N) {
    y_hat[i] = beta[1] + beta[2]*age[i] + beta[3]*pow(age[i], 2) + beta[4]*pnum[i];
  }

  phi_y ~ cauchy(1, 3);

  beta[1] ~ normal(0, 5);
  beta[2] ~ normal(0, 5);
  beta[3] ~ normal(0, 5);
  beta[4] ~ normal(0, 5);

  y ~ neg_binomial_2_log(y_hat, phi_y);
}
