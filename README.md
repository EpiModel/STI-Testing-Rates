# STI-Testing-Rates

This repository contains the original data, analysis scripts, and stored MCMC model data for the following study:

> Jenness SM, Weiss KM, Prasad P, Zlotorzynska M, Sanchez T. Bacterial STI Screening Rates by Symptomatic Status among Men Who Have Sex with Men in the United States: A Hierarchical Bayesian Analysis. _Sexually Transmitted Diseases_. 2019; 46(1): 25-30. [[LINK]](https://www.ncbi.nlm.nih.gov/pubmed/30044334) 

<img src="https://github.com/EpiModel/STI-Testing-Rates/raw/master/fig/Fig1.png">

## Abstract

### Background 	
Prevention of bacterial STIs among men who have sex with men (MSM) requires timely disease detection, but this is complicated by asymptomatic infection. We estimated screening/testing rates by symptomatic status to evaluate adherence to CDC STI screening guidelines.

### Methods 	
In a cross-sectional study of 2572 US MSM aged 15–65 in 2017–2018, we measured the reported number of asymptomatic STI screens in the past 2 years versus tests prompted by disease symptoms. Using negative binominal regression within a hierarchical Bayesian framework, we estimated yearly rates of asymptomatic screening and symptomatic testing by geographic, demographic, and behavioral factors.

### Results 	
HIV status was most strongly associated with all testing/screening frequency (Incidence Rate Ratio [IRR]=1.72; 95% credible interval [Crl] = 1.49, 1.97). HIV-uninfected MSM had 0.14 (95% CrI = 0.12, 0.17) symptomatic tests and 0.88 (95% CrI = 0.77, 1.01) asymptomatic screens per year. HIV-infected MSM had 0.25 (95% CrI = 0.18, 0.35) symptomatic tests and 1.53 (95% CrI = 1.24, 1.88) asymptomatic screens per year. Rates of asymptomatic screening were higher among black compared to white MSM (IRR = 1.41; 95% CrI = 1.15, 1.73), but weakly associated with number of past-year sexual partners (IRR = 1.01; 95% CrI = 1.00, 1.01). Overall, 85–90% of diagnostic events were asymptomatic screens.

### Conclusions 	
Self-reported rates of STI screening were close to CDC’s recommended overall annual screening frequency, but with gaps defined by demographics and behavioral risk. Targeted screening efforts may be indicated specifically for younger MSM and those with multiple partners.

<img src="https://github.com/EpiModel/STI-Testing-Rates/raw/master/fig/Fig2.png">

## Code Organization

Cleaned data is available in the `data` folder saved as `STI-Test_analysis.rda`. The R script for producing the cleaned data is in `cleaning` folder. The full dataset containing all variables from the ARTNet Study is not currently openly available, so running the cleaning script is not possible. 

R and Stan scripts used to run each of the models are provided in the `models` folder. Each R script is titled corresponding to a specific table or figure and column number as separate models were run for each outcome. For example, `t2.col1.R` runs the model for combined STI testing/screening in Table 2. Each R script has a corresponding Stan file defining the model parameters, priors, and likelihoods. The data from each model, which take some time to run the MCMC simulations, are also stored under the `data` folder.

Once all models have been estimated, the results may be analyzed with the `analysis.stan.R` script in the `models` folder. This is also organized by table and figure number. 

## Shiny App

An interactive web-based application for model exploration and visualization is available at: 

https://epimodel.shinyapps.io/sti-screen/

<img src="https://github.com/EpiModel/STI-Testing-Rates/raw/master/fig/shiny.png">
