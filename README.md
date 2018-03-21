# STI-Testing-Rates

This repository contains the original data, analysis scripts, and stored MCMC model data for the following study:

> Jenness SM, Weiss KM, Prasad P, Zlotorzynska M, Sanchez T. Bacterial STI Screening Rates by Symptomatic Status among Men Who Have Sex with Men in the United States: A Hierarchical Bayesian Analysis. Under Review.

<img src="https://github.com/EpiModel/STI-Testing-Rates/raw/master/fig/Fig1.pdf">

## Abstract

### Background 
The incidence of bacterial sexually transmitted infections (STIs) like gonorrhea, chlamydia, and syphilis has rapidly increased among men who have sex with men (MSM) in the United States over the past decade despite widely available and highly effective antibiotics. Breaking ongoing transmission chains through treatment, however, requires timely disease detection; this is complicated by asymptomatic infection, common with rectal and pharyngeal exposures. To evaluate CDC recommendations of routine testing every 6–12 months, rate-based estimates of testing by symptomatic status are needed.

### Methods 	
We conducted a cross-sectional web-based survey of 2572 US MSM aged 15–65 in 2017 measuring the self-reported total number of STI testing events in the past year and events prompted only by disease symptoms. Using negative binomial regression with a hierarchical Bayesian framework, we estimated the yearly rates of asymptomatic and symptomatic testing by behavioral and biological predictors.

### Results 	
HIV status was most strongly associated with testing rates (Incidence Rate Ratio [IRR]=1.77 for symptomatic tests and 1.88 for asymptomatic tests). HIV- men had 0.14 (95% credible interval [CrI]=0.11, 0.17) symptomatic and 0.83 (95% CrI=0.76, 0.90) asymptomatic tests per year. HIV+ men had 0.24 symptomatic (95% CrI=1.48, 2.13) and 1.58 (95% CrI=1.27, 1.87) asymptomatic tests per year. Rates of asymptomatic testing were higher among black compared to white MSM (IRR=1.32; 95% CrI=1.04, 1.69), but more weakly associated with number of past-year sexual partners (IRR=1.01; 95% CrI=1.00, 1.02).

### Conclusions 	
Overall, 85–90% of STI tests were due to factors other than symptomatic infection. Because rates were only weakly associated with behavioral risk, this provides evidence of routine, interval-based testing. However, testing rates were sub-optimal compared to CDC recommendations for both HIV- and HIV+ MSM, suggesting additional interventions needed to increase coverage in this population.

<img src="https://github.com/EpiModel/STI-Testing-Rates/raw/master/fig/Fig2.pdf">

## Code Organization

Cleaned data is available in the `data` folder saved as `STI-Test_analysis.rda`. The R script for producing the cleaned data is in `cleaning` folder. The full dataset containing all variables from the ARTNet Study is not currently openly available, so running the cleaning script is not possible. 

R and Stan scripts used to run each of the models are provided in the `models` folder. Each R script is titled corresponding to a specific table or figure and column number as separate models were run for each outcome. For example, `t2.col1.R` runs the model for combined STI testing/screening in Table 2. Each R script has a corresponding Stan file defining the model parameters, priors, and likelihoods. The data from each model, which take some time to run the MCMC simulations, are also stored under the `data` folder.

Once all models have been estimated, the results may be analyzed with the `analysis.stan.R` script in the `models` folder. This is also organized by table and figure number. 

