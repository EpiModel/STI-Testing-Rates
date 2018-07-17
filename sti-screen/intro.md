
### About

This web application provides an interactive user interface for the study:

> Jenness SM, Weiss KM, Prasad P, Zlotorzynska M, Sanchez T. Bacterial STI Screening Rates by Symptomatic Status among Men Who Have Sex with Men in the United States: A Hierarchical Bayesian Analysis. _Sexually Transmitted Diseases._ In Press.

In this study, we used Bayesian modeling to provide estimated of rates and predictors of screening for gonorrhea, chlamydia, and syphilis among men who have sex with men (MSM) in the US. The study abstract is found below.

One goal of this study was to provide estimated rates of STI screening/testing in this target population that may be used for STI-focused public health policy and research activities. The primary paper tables show the predictors of screening/testing by demographic and behavioral covariates, but the underlying rates are not calculable without the full raw model coefficients. We provided the point estimates for those raw coefficients in the supplemental appendix, but this web tool makes calculating those rate, along with associated statistical uncertainty, even easier!


### Model Description

This app allows for exploration of two models featured in our study.

* **Table S2:** This is a varying intercept negative binomial regression model of per-year races of all bacterial STI testing/screening by symptomatic status. The outcomes here are the number of all tests/screens, symptomatic tests, and asymptomatic screens per year. The exponentiated coefficients from this model, interpreted as incidence rate ratios, are provided in Table 2 of the main paper.
* **Table S4:** This is a varying intercept logistic regression model of never testing in the past two years by symptomatic status. The outcomes here are never having  testing or screening, never having a symptomatic test, and never having an asymptomatic screen in the past 2 years. The exponentiated coefficients from this model, interpreted as odds ratios, are provided in Table 3 of the main paper.

Covariates were the same in both models. They included geography, race/ethnicity, age, reported HIV status, and number of past-year oral/anal sex partners. Geography was defined by zip code, which we classified into one of 15 key-priority cities, then for men living outside of those cities, census division. Census divisions are defined as: Division 1 (CT, ME, MA, NH, RI); Division 2 (NJ, NY, PA); Division 3 (IL, IN, MI, OH, WI); Division 4 (IA, KN, MN, MO, NE, ND, SD); Division 5 (DE, FL, GA, MD, NC, SC, VI, WV, DC); Division 6 (AL, KY, MS, TN); Division 7 (AK, LA, OK, TX); Division 8 (AZ, CO, MT, NV, NM, UT, WY); Division 9 (AK, CA, HI, OR, WA). There is also a geography-averaged covariate value available that averages over all these cities and Census Divisions.

We employed a hierarchical Bayesian modeling framework in which individuals were nested within their geographic units. Models specified hyper-parameters controlling the distribution of coefficient values across geography. Weakly informative prior distributions were placed on all model parameters. Models were fit with the STAN statistical software, which uses Hamiltonian Markov Chain Monte Carlo (MCMC) methods to estimate model coefficients.

### Instructions

1. Select the model of interest under either the **Screening Rates** or **Never Screening** tabs at the top.
2. Select the outcome of interest for the model.
3. Input the covariate combination of interest. Ages are restricted to between 15 and 65, and past-year partner number is restricted to between 0 and 200, as these were the empirical ranges in our dataset.
4. The outputs are the estimated posterior distribution of rates/probabilities from model, with statistical uncertainty  interpreted in a Bayesian statistical framework. Credible intervals other than 2.5% and 97.5% may be selected.


### Study Abstract

#### Background 	
Prevention of bacterial STIs among men who have sex with men (MSM) requires timely disease detection, but this is complicated by asymptomatic infection. We estimated screening/testing rates by symptomatic status to evaluate adherence to CDC STI screening guidelines.

#### Methods 	
In a cross-sectional study of 2572 US MSM aged 15–65 in 2017–2018, we measured the reported number of asymptomatic STI screens in the past 2 years versus tests prompted by disease symptoms. Using negative binominal regression within a hierarchical Bayesian framework, we estimated yearly rates of asymptomatic screening and symptomatic testing by geographic, demographic, and behavioral factors.

#### Results 	
HIV status was most strongly associated with all testing/screening frequency (Incidence Rate Ratio [IRR]=1.72; 95% credible interval [Crl] = 1.49, 1.97). HIV-uninfected MSM had 0.14 (95% CrI = 0.12, 0.17) symptomatic tests and 0.88 (95% CrI = 0.77, 1.01) asymptomatic screens per year. HIV-infected MSM had 0.25 (95% CrI = 0.18, 0.35) symptomatic tests and 1.53 (95% CrI = 1.24, 1.88) asymptomatic screens per year. Rates of asymptomatic screening were higher among black compared to white MSM (IRR = 1.41; 95% CrI = 1.15, 1.73), but weakly associated with number of past-year sexual partners (IRR = 1.01; 95% CrI = 1.00, 1.01). Overall, 85–90% of diagnostic events were asymptomatic screens.

#### Conclusions 	
Self-reported rates of STI screening were close to CDC’s recommended overall annual screening frequency, but with gaps defined by demographics and behavioral risk. Targeted screening efforts may be indicated specifically for younger MSM and those with multiple partners.

<br>
<br>
