## ART-Net Study 2017
## Data Cleaning/Management Script - getting partials as well for STI analysis
## v1 | 2017-11-26
## 1.5/3

# 1. Setup ----------------------------------------------------------------

# Load packages
rm(list = ls())
library("haven")
library("dplyr")
library("readxl")
library("readr")

# set your working directory here
#setwd("/Users/Pragati/Dropbox/Projects/ETN-001/Data/Cleaned")
#setwd("C:/Users/kweiss2/Dropbox/ETN-001/Data/Cleaned")

# read 15-city zip codes
source("zips.R", echo = TRUE)


# 2. Complete ART-Net Data ------------------------------------------------

# Read ART-Net
artnet <- read_sav("input/ART-Net_Raw.sav")
artnetpartials <- artnet[artnet$Vstatus == "Partial", ]
partialsSTIComplete <- artnetpartials[which(!is.na(artnetpartials$M_MP12OANUM2)),]

# Assign blank cities as other
partialsSTIComplete$city[which(partialsSTIComplete$city == "")] <- "Other"

# Copy all of the duplicate subIDs separately
artnetcompletesdupes <- partialsSTIComplete[partialsSTIComplete$AMIS_ID %in%
                                              partialsSTIComplete[duplicated(partialsSTIComplete$AMIS_ID),]$AMIS_ID, ]
artnetcompletesdupes <- artnetcompletesdupes[which(artnetcompletesdupes$AMIS_ID != ""), ]
table(artnetcompletesdupes$AMIS_ID)

#getting the non duplicates and the blanks that we want to fill in
artnetcompletesdedupe <- partialsSTIComplete[!(duplicated(partialsSTIComplete$AMIS_ID)) |
                                               partialsSTIComplete$AMIS_ID == "", ]

# fill in missing submission IDs of completes to partials: subset these out,
# look for ip addresses in partials
completesblanks <- artnetcompletesdedupe[which(artnetcompletesdedupe$AMIS_ID == "" |
                                                 is.na(artnetcompletesdedupe$AMIS_ID)), ]
completesblanks$AMIS_ID <- NULL
completesblanks$Vstatus <- NULL

partials1 <- artnet[artnet$Vstatus == "Partial", ]
partials <- select(partials1, Vstatus, Vip, AMIS_ID)
possibleids <- left_join(completesblanks, partials, by = c("Vip" = "Vip"))
possibleidsshort <- select(possibleids, Vip, AMIS_ID, Vstatus)
possibleidsshort <- possibleidsshort[which(possibleidsshort$AMIS_ID != "" |
                                             !(is.na(possibleidsshort$AMIS_ID))), ]
possibleidsshort <- possibleidsshort[-c(34,35,40,41), ]
possibleidsshort <- possibleidsshort[!(duplicated(possibleidsshort$AMIS_ID)), ]

missingfilledcompletes1 <- left_join(artnetcompletesdedupe, possibleidsshort,
                                     by = c("Vip" = "Vip"))
missingfilledcompletes1$AMIS_ID <- NA
missingfilledcompletes1$AMIS_ID <- ifelse(missingfilledcompletes1$AMIS_ID.x != "",
                                          missingfilledcompletes1$AMIS_ID.x,
                                          missingfilledcompletes1$AMIS_ID.y)
table(is.na(missingfilledcompletes1$AMIS_ID))

missingfilledcompletes1$AMIS_ID.x <- NULL
missingfilledcompletes1$AMIS_ID.y <- NULL

missingfilledcompletes1 <- rename(missingfilledcompletes1, Vstatus = Vstatus.x)
missingfilledcompletes1$Vstatus.x <- NULL
missingfilledcompletes1$Vstatus.y <- NULL

#we lose 5 blanks - unable to match on ip address
artnetdedupes <- missingfilledcompletes1[which(!is.na(missingfilledcompletes1$AMIS_ID)),]
#we lose 1 duplicate here from blank matching
artnetdedupes <- artnetdedupes[!duplicated(artnetdedupes$AMIS_ID), ]


# 3. Merge AMIS Data ------------------------------------------------------

amis <- readRDS("input/AMIS_eligibles.rda")
amiscompletes <- amis[which(amis$Vstatus == "Complete"), ]
artnetcompletes <- artnetdedupes[artnetdedupes$Vstatus == "Partial" &
                                   !is.na(artnetdedupes$AMIS_ID),]

# Assign a city
amiscompletes$cityassign <- "Other"
amiscompletes$cityassign[which(amiscompletes$ZIPCODE %in% atlanta)] <- "Atlanta"
amiscompletes$cityassign[which(amiscompletes$ZIPCODE %in% boston)] <- "Boston"
amiscompletes$cityassign[which(amiscompletes$ZIPCODE %in% chicago)] <- "Chicago"
amiscompletes$cityassign[which(amiscompletes$ZIPCODE %in% dallas)] <- "Dallas"
amiscompletes$cityassign[which(amiscompletes$ZIPCODE %in% denver)] <- "Denver"
amiscompletes$cityassign[which(amiscompletes$ZIPCODE %in% detroit)] <- "Detroit"
amiscompletes$cityassign[which(amiscompletes$ZIPCODE %in% houston)] <- "Houston"
amiscompletes$cityassign[which(amiscompletes$ZIPCODE %in% losangeles)] <- "Los Angeles"
amiscompletes$cityassign[which(amiscompletes$ZIPCODE %in% miami)] <- "Miami"
amiscompletes$cityassign[which(amiscompletes$ZIPCODE %in% newyorkcity)] <- "New York City"
amiscompletes$cityassign[which(amiscompletes$ZIPCODE %in% philadelphia)] <- "Philadelphia"
amiscompletes$cityassign[which(amiscompletes$ZIPCODE %in% sandiego)] <- "San Diego"
amiscompletes$cityassign[which(amiscompletes$ZIPCODE %in% sanfrancisco)] <- "San Francisco"
amiscompletes$cityassign[which(amiscompletes$ZIPCODE %in% seattle)] <- "Seattle"
amiscompletes$cityassign[which(amiscompletes$ZIPCODE %in% washingtondc)] <- "Washington"

# Rename submission date
names(artnetcompletes)[names(artnetcompletes) == 'Vdatesub'] <- 'SUB_DATE'

# Remove unnecessary variables and rename variables
amiscompletesremove <- c("ip_address", "PERCENT", "Vlinkname", "Vrid", "Vdatesub", "Vstatus",
                         "Vreferer", "Vsessionid", "Vuseragent", "Vip", "Vlong", "Vlat", "VGeoCountry",
                         "VGeoCity", "VGeoRegion", "Vpostal", "lastid2016_char")
amiscompletes <- subset(amiscompletes, select = !(names(amiscompletes) %in% amiscompletesremove))
# colnames(artnetcompletes)
artnetcompletesremove <- c("Vrid", "Vstatus", "Vcid", "Vcomment", "Vlanguage", "Vreferer",
                           "Vsessionid", "Vuseragent", "Vip", "Vlong", "Vlat", "VGeoCountry", "VGeoCity",
                           "VGeoRegion", "Vpostal")
artnetcompletes <- subset(artnetcompletes, select = !(names(artnetcompletes) %in% artnetcompletesremove))

artnetcompletes <- rename(artnetcompletes, artnetCONSENT_TIME = consent_time)
artnetcompletes <- rename(artnetcompletes, artnetASSENT_TIME = assent_time)
artnetcompletes <- rename(artnetcompletes, artnetEVERTEST = EVERTEST)
artnetcompletes <- rename(artnetcompletes, artnetRCNTRSLT = RCNTRSLT)
artnetcompletes <- rename(artnetcompletes, artnetEVRPOS = EVRPOS)
artnetcompletes <- rename(artnetcompletes, artnetSTATUS = STATUS)
artnetcompletes <- rename(artnetcompletes, artnetPREP_CURRENT = PREP_CURRENT)
artnetcompletes <- rename(artnetcompletes, artnetEMAIL = EMAIL)

# Make AMIS join variable character to match ART-Net
amiscompletes$AMIS_ID <- as.character(amiscompletes$subID_CHAR)

#deleting blanks
amiscompletes <- amiscompletes[which(amiscompletes$AMIS_ID != ""),]
#reordering by AMIS_ID and completion percentage
amiscompletes <- amiscompletes[order(amiscompletes$AMIS_ID, amiscompletes$completionpercent), ]
#deduplicating based on highest completion percentage
amiscompletes <- amiscompletes[!duplicated(amiscompletes$AMIS_ID, fromLast = TRUE),]

# Left inner join - keep only rows from LHS that have matches
matched <- inner_join(artnetcompletes, amiscompletes, by = c("AMIS_ID" = "AMIS_ID"))


# Anti join (keep only rows from LHS that have no match on right-hand side
#   (addressed with full dataset))
#   4 observations
matched2 <- anti_join(artnetcompletes, amiscompletes, by = c("AMIS_ID" = "AMIS_ID"))
table(matched2$AMIS_ID)

print(matched2$AMIS_ID)
# Discordant IDs - in ART-Net but not in de-duplicated AMIS dataset,
# could be addressed by using earlier AMIS dataset (pre-de-duplication)
matched2$AMIS_ID[which(matched2$AMIS_ID != "")]

length(unique(matched$AMIS_ID))
#should be 0
matched[which(duplicated(matched$AMIS_ID)), ] # duplicated in matched dataset


# 4. ZIP to Geography -----------------------------------------------------

# Create State/County database
all_geoc <- read_xlsx("input/all-geocodes-v2016.xlsx")
state_geoc <- read_xlsx("input/state-geocodes-v2016.xlsx")
# Join State file (with region/division) with all geocodes
statecounty <- inner_join(all_geoc, state_geoc, by = c("STFIPS" = "STFIPS"))

# Subset out non-county values,subdivisions, places, and consolcityFIPS
statecounty <- statecounty[which(statecounty$COFIPS != "000" & statecounty$COSUBDIVFIPS == 0 &
                                   statecounty$PLACEFIPS == 0 & statecounty$CONSOLCITYFIPS == 0), ]
length(unique(statecounty$STCOFIPS)) # 3,142 unique FIPS

# Read ZIP data
ZIPCounty <- read_xlsx("input/HUD_ZIP_COUNTY_092017.xlsx")
length(unique(ZIPCounty$zip)) #52,894 rows, but 39,454 unique ZIPs, others are in multiple FIPS codes
length(unique(ZIPCounty$county)) # 3,225 unique counties
# Rename variable to be informative
ZIPCounty <- rename(ZIPCounty, STCOFIPS = county)

# Join by county FIPS code
city_county_merged <- inner_join(ZIPCounty, statecounty, by = c("STCOFIPS" = "STCOFIPS")) #52,564 rows
nocountymatch <- anti_join(ZIPCounty, statecounty, by = c("STCOFIPS" = "STCOFIPS")) #330 with no match to county FIPS
table(nocountymatch$statefips) # 4 geographies with no match,
#12 in Alaska, 4 in Guam, 309 in Puerto Rico, 5 in US Virgin Islands

# Remove unnecessary columns
georemove <- c("statefips", "SUMLevel", "COSUBDIVFIPS", "PLACEFIPS", "CONSOLCITYFIPS")
city_county_merged <- subset(city_county_merged, select = !(names(city_county_merged) %in% georemove))

# Merge AMIS/ARTNet with geographic info

left <- left_join(matched, city_county_merged,
                  by = c("ZIPCODE2" = "zip")) # 2,378 rows, up from 1950

inner <- inner_join(matched, city_county_merged,
                    by = c("ZIPCODE2" = "zip")) # 2,367 rows, up from 1950
length(unique(inner$AMIS_ID))

# look for unmatched ones (possibly junk ZIPS?)
anti <- anti_join(matched, city_county_merged,
                  by = c("ZIPCODE2" = "zip")) # 11 rows
table(anti$ZIPCODE2) #ZIPs are 01795, 13222, 29958, 30059, 31767, 64122, 69601, 86361, 92360, 94891, 98123
# All ZIPs are invalid (https://m.usps.com/m/ZipLookupAction?search=zip)

# correcting for the above issue - replcing invalid ZIPCODE2 with ZIPCODE (AMIS)
anti$ZIPCODE2 <- anti$ZIPCODE
anti_inner <- inner_join(anti, city_county_merged,
                         by = c("ZIPCODE2" = "zip")) # we are losing 2 Zipcodes here even after replacement

completematched <- rbind(inner, anti_inner)

# Investigating dataset - mismatches between statename and state_calc (Maria)
table(completematched$STATENAME)#, completematched$state_calc)

#these are the duplicates of AMIS ID due to join with ZIP Code
completematched1 <- completematched[completematched$AMIS_ID %in%
                                      completematched[duplicated(completematched$AMIS_ID),]$AMIS_ID, ]
length(unique(completematched1$AMIS_ID)) # 763 duplicates, 343 unique IDs

completematched1$diff <- NA

for (i in 1:nrow(completematched1)) {
  completematched1$diff[i] <- completematched1$ZIPCODE2[i] == completematched1$ZIPCODE[i]
}

#checking to see if duplicates have same city in ART-Net and AMIS
#city is ART-Net variable, cityassign is AMIS variable
cm1_cut <- select(completematched1, AMIS_ID, ZIPCODE2, ZIPCODE, city, COUNTY,
                  subID, zip_combined, cityassign, diff, STATENAME, STFIPS, STCOFIPS, state_calc)
aggregate(cm1_cut, list(AMIS_ID = cm1_cut$AMIS_ID), table)


# REMOVE DUPLICATES
b <- completematched[which(!(duplicated(completematched$AMIS_ID))), ] # remove duplicates

# 5. Write Cleaned Dataset ------------------------------------------------

d <- as.data.frame(b)
saveRDS(d, file = "output/ARTNet-cleanPartials.rda", compress = "xz")

# 6. Loading the

d1 <- readRDS("output/ARTNet-clean.rda")

ARTNet_STI <- rbind(d, d1)

saveRDS(ARTNet_STI, file = "output/ARTNet_STI-clean.rda", compress = "xz")





