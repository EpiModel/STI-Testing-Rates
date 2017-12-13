data {
  int<lower=1> N;
  int<lower=1> J;
  int<lower=1,upper=J> city[N];
  int<lower=0,upper=1> race_black[N];
  int<lower=0,upper=1> race_hisp[N];
  int<lower=0,upper=1> race_oth[N];
  int<lower=0> age[N];
  int<lower=0,upper=1> hiv[N];
  int<lower=0> pnum[N];
  int<lower=0> y[N];
}
parameters {
  vector[J] a;
  real mu_a;
  vector[7] beta;
  real<lower=0> sigma_a;
}
model {
  vector[N] y_hat;
  for (i in 1:N) {
    y_hat[i] = a[city[i]] + beta[1]*race_black[i] + beta[2]*race_hisp[i] + beta[3]*race_oth[i] +
               beta[4]*age[i] + beta[5]*pow(age[i], 2) + beta[6]*hiv[i] +  beta[7]*pnum[i];
  }

  mu_a ~ cauchy(0, 5);
  sigma_a ~ normal(0.4099506, 0.1);
  a ~ cauchy(0, 5);

  beta[1] ~ normal(0, 2);
  beta[2] ~ normal(0, 2);
  beta[3] ~ normal(0, 2);
  beta[4] ~ normal(0, 2);
  beta[5] ~ normal(0, 2);
  beta[6] ~ normal(0, 2);
  beta[7] ~ normal(0, 2);

  a ~ normal(mu_a, sigma_a);
  y ~ bernoulli_logit(y_hat);
}
