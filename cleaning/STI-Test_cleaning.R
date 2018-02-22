
library(tidyverse)

## Read input data

d <- readRDS("../../../Data/Cleaned/ARTNet_STI-clean.rda")
names(d)
nrow(d)


# 1. Exposure Variables ---------------------------------------------------

##  HIV status
d$hiv <- 0
d$hiv[d$artnetRCNTRSLT %in% c(88, 99)] <- NA
d$hiv[d$artnetRCNTRSLT == 2 | d$artnetSTATUS == 2] <- 1
table(d$hiv)

## Race/Ethnicity
d$hispan <- ifelse(d$HISPANIC == 1, 1, 0)
table(d$hispan)

d$race.mult <- ifelse(d$RACEA + d$RACEB + d$RACEC + d$RACED + d$RACEE > 1, 1, 0)
table(d$race.mult)

d$race <- rep(NA, nrow(d))
d$race[d$race.mult == 1] <- "mult"
d$race[d$race.mult == 0 & d$RACEA == 1] <- "ai/an"
d$race[d$race.mult == 0 & d$RACEB == 1] <- "asian"
d$race[d$race.mult == 0 & d$RACEC == 1] <- "black"
d$race[d$race.mult == 0 & d$RACED == 1] <- "nh/pi"
d$race[d$race.mult == 0 & d$RACEE == 1] <- "white"
d$race[d$race.mult == 0 & (d$RACEF == 1 | d$RACEG == 1 | d$RACEH == 1)] <- "other"

table(d$race, d$hispan)

d$race.min <- ifelse(d$race == "white", 0, 1)

d$race.cat <- rep("other", nrow(d))
d$race.cat[d$hispan == 1] <- "hispanic"
d$race.cat[d$hispan == 0 & d$race == "black"] <- "black"
d$race.cat[d$hispan == 0 & d$race == "white"] <- "white"
table(d$race.cat)

## Age
d$AGE
d <- rename(d, age = AGE)
summary(d$age)
hist(d$age)

## Behavioral

# past year partners
d <- rename(d, cuml.pnum = M_MP12OANUM2)
table(d$cuml.pnum, useNA = "always")
sum(table(d$cuml.pnum))
hist(d$cuml.pnum, breaks = 30)
summary(d$cuml.pnum)

table(d$M_MP12ANUM2)
table(d$cuml.pnum, d$M_MP12ANUM2_ONEPART, useNA = "always")
table(d$cuml.pnum, d$M_MP12ANUM2, useNA = "always")

ai.part <- rep(NA, nrow(d))
ai.part[which(d$cuml.pnum == 0)] <- 0
ai.part[which(d$cuml.pnum == 1)] <- as.numeric(d$M_MP12ANUM2_ONEPART[which(d$cuml.pnum == 1)])
ai.part[which(d$cuml.pnum > 1)] <- d$M_MP12ANUM2[which(d$cuml.pnum > 1)]

table(ai.part, useNA = "always")

d$M_MP12ANUM2[which(is.na(ai.part))]

table(d$cuml.pnum, ai.part, useNA = "always")

d$ai.part <- ai.part

## city

table(d$city)
nrow(d)
sum(table(d$city))

which(d$city == "Other")
d$DIVCODE[which(d$city == "Other")]
d$ZIPCODE[which(is.na(d$DIVCODE))]
d$ZIPCODE2[which(is.na(d$DIVCODE))]

sum(table(d$DIVCODE, useNA = "always"))

d$city2 <- d$city
d$city2[which(d$city == "Other")] <- paste("zOther", d$DIVCODE[which(d$city == "Other")], sep = "")
table(d$city2)

d$city2 <- as.factor(d$city2)

d$div <- d$DIVCODE
table(d$div, useNA = "always")
sum(table(d$div))


# 2. Outcome Variables ----------------------------------------------------


# testing among non-PrEP users

# Remove outlier
d$STITEST_2YR <- ifelse(d$STITEST_2YR == 2015, NA, d$STITEST_2YR)

# mean testing rate
summarise(d, mean(STITEST_2YR, na.rm = TRUE))

group_by(d, hiv) %>%
  summarise(n.hiv = length(hiv), trate = mean(STITEST_2YR, na.rm = TRUE))


# add prep users

d$sti.trate.all <- NA
d$sti.trate.all[!is.na(d$STITEST_2YR)] <- d$STITEST_2YR[!is.na(d$STITEST_2YR)]
d$sti.trate.all[!is.na(d$STITEST_2YR_PREP)] <-
  d$STITEST_2YR_PREP[!is.na(d$STITEST_2YR_PREP)]

table(d$sti.trate.all)
round(prop.table(table(d$sti.trate.all)), 3)
hist(d$sti.trate.all, breaks = 30)
table(d$sti.trate.all, useNA = "always")

summarise(d, tratem = mean(sti.trate.all, na.rm = TRUE))
summarise(d, tratem = median(sti.trate.all, na.rm = TRUE))

group_by(d, hiv) %>%
  summarise(n.hiv = length(hiv), tratem = mean(sti.trate.all, na.rm = TRUE))

# filter out never testers
filter(d, sti.trate.all > 0) %>%
  summarise(tratem = mean(sti.trate.all, na.rm = TRUE))

filter(d, sti.trate.all > 0) %>%
  group_by(hiv) %>%
  summarise(tratem = mean(sti.trate.all, na.rm = TRUE))


## symptomatic testing

# create composite variable with prep users
d$sti.trate.symp <- NA
d$sti.trate.symp[!is.na(d$STITEST_2YR_SYMPT)] <-
                                d$STITEST_2YR_SYMPT[!is.na(d$STITEST_2YR_SYMPT)]
d$sti.trate.symp[which(d$STITEST_2YR == 0)] <- 0
d$sti.trate.symp[!is.na(d$STITEST_2YR_SYMPT_PREP)] <-
                      d$STITEST_2YR_SYMPT_PREP[!is.na(d$STITEST_2YR_SYMPT_PREP)]
d$sti.trate.symp[which(d$STITEST_2YR_PREP == 0)] <- 0

table(d$sti.trate.symp)
table(d$sti.trate.symp, useNA = "always")
sum(table(d$sti.trate.symp), na.rm = TRUE)

summarise(d, tratem = mean(sti.trate.symp, na.rm = TRUE))

group_by(d, hiv) %>%
  summarise(tratem = mean(sti.trate.symp, na.rm = TRUE))


## asymptomatic screening

d$sti.trate.asymp <- d$sti.trate.all - d$sti.trate.symp

table(d$sti.trate.asymp)
table(d$sti.trate.asymp, useNA = "always")
sum(table(d$sti.trate.asymp), na.rm = TRUE)

summarise(d, mean = mean(sti.trate.asymp, na.rm = TRUE))

group_by(d, hiv) %>%
  summarise(n.hiv = length(hiv),
            mean = mean(sti.trate.asymp, na.rm = TRUE))


# Never Testing -----------------------------------------------------------


# All testing

d$sti.never <- ifelse(d$sti.trate.all > 0, 0, 1)
table(d$sti.never, d$sti.trate.all)


# Symptomatic testing

d$sti.symp.never <- ifelse(d$sti.trate.symp > 0, 0, 1)
table(d$sti.symp.never, d$sti.trate.symp)

# Asymptomatic testing

d$sti.asymp.never <- ifelse(d$sti.trate.asymp > 0, 0, 1)
table(d$sti.asymp.never, d$sti.trate.asymp)


# Qualitiative Testing frequency ------------------------------------------

table(d$STIREG)
d <- rename(d, stireg = STIREG)
table(d$STITESTFREQ)
d <- rename(d, stitestfreq = STITESTFREQ)



# Output Dataset ----------------------------------------------------------

dt <- select(d, hiv, race.cat, age, cuml.pnum, ai.part, city2, city, div,
            sti.trate.all, sti.trate.symp, sti.trate.asymp,
            sti.never, sti.symp.never, sti.asymp.never,
            stireg, stitestfreq)

saveRDS(dt, file = "data/STI-Test_analysis.rda")

