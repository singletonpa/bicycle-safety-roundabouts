########################################
# Project:  MPC-603 Bicycle safety roundabouts
# Authors:  Patrick Singleton (patrick.singleton@usu.edu)
#           Niranjan Poudel (niranjan.poudel@usu.edu)
# File:     weight_data.R
# Date:     2021 Spring, Summer
# About:    Script to weight survey data
########################################

# Major edits
# 2021-02-07 created by NP
# 2021-05-13 updated by PAS, reformat script

########################################
# Notes

# Open R project first, then open this R script

# Install, load packages
# library("")
library(tidyr)
library(dplyr)
library(anesrake)

########################################
# Load data

# Load stated data
Complete <- readRDS(file.path("Analysis", "Stated preference", "Data cleaning and weighting", "dat_stated.rds"))

# Load weighting data
expected <- read.csv(file=file.path("Data", "Census", "Expected.csv"), stringsAsFactors=F)
str(expected)
expected

########################################
# Prepare weighting data

# Extract target proportions for weighting variables
# age
# agetarg <- c(0.11894448,0.17845861,0.1647720,0.15974204,0.16628905,0.21179373) 
agetarg <- expected$Rate[3:8]
names(agetarg) <- c("less than 25", "25 to 34", "35 to 44", "45 to 54", "55 to 64", "65 plus")
agetarg
# gender
# gendtarg <- c(0.51335871,0.48664129)
gendtarg <- expected$Rate[2:1]
names(gendtarg) <- c("female", "male")
gendtarg
# household income
# hhinctarg <- c(0.12222089, 0.17190822, 0.16842699, 0.13733280, 0.17894925,0.19023774)
hhinctarg <- expected$Rate[9:14]
hhinctarg <- hhinctarg* 1/sum(hhinctarg)
names(hhinctarg) <- c("25K","50K","75K","100K","150K","150plus")
hhinctarg
# race/ethnicity
# racetarg <- c(0.26396421, 0.73603579)
racetarg <- expected$Rate[20:19]
names(racetarg) <- c("Others", "White")
racetarg

# Create target shares
target1 <- list(hhinctarg, agetarg, gendtarg, racetarg)
names(target1) <- c("HHINC", "AGE", "GEND", "RaceW")
target2 <- list(agetarg, gendtarg, racetarg)
names(target2) <- c("AGE", "GEND", "RaceW")

# Cleanup
rm(agetarg, gendtarg, hhinctarg, racetarg)

########################################
# Prepare survey data

# Select the required columns for weighted analysis
Complete %>%
  select(ResponseId, ID, av, Choice,
         Island_small_A, Island_large_A, Lane_1_A, Lane_2_A, 
         Facility_No_A, Facility_Shared_A, Facility_Ramps_A, Facility_Seperated_A,
         Volume_Low_A, Volume_Medium_A, Volume_High_A, Speed_25_A, Speed_35_A,
         Island_small_B, Island_large_B, Lane_1_B, Lane_2_B, 
         Facility_No_B, Facility_Ramps_B, Facility_Shared_B, Facility_Seperated_B, 
         Volume_Low_B, Volume_Medium_B, Volume_High_B, Speed_25_B, Speed_35_B, 
         HHINC, AGE, GEND, RACE_WHIT:RACE_NA, EDUC) -> WeightData

# Process race/ethnicity data to create white-only vs. other
WeightData %>%
  mutate(RaceSum = RACE_WHIT + RACE_HISP + RACE_ASIA + RACE_BLAC + RACE_AIAN + RACE_NHPI + RACE_SD + RACE_NA) -> WeightData
WeightData %>%
  mutate(RaceW = ifelse((RACE_WHIT == TRUE & RaceSum == 1), 1, 0)) %>%
  select(-c(RACE_WHIT:RACE_NA, RaceSum))-> WeightData

# Converting some factor columns to characters to add missing in place of NA
WeightData %>% 
  mutate(AGE = as.character(AGE)) %>%
  mutate(GEND = as.character(GEND)) %>%
  mutate(HHINC = as.character(HHINC)) %>%
  mutate(EDUC = as.character(EDUC)) -> WeightData
WeightData[is.na(WeightData)] <- "Missing"

# Back to factor
WeightData %>% 
  mutate(AGE = as.factor(AGE)) %>%
  mutate(GEND = as.factor(GEND)) %>%
  mutate(HHINC = as.factor(HHINC)) %>%
  mutate(EDUC = as.factor(EDUC)) -> WeightData
levels(WeightData$AGE)
levels(WeightData$GEND)
levels(WeightData$HHINC)
levels(WeightData$EDUC)
WeightData %>%
  mutate(AGE = factor(AGE, labels = c ("less than 25","less than 25","25 to 34","35 to 44","45 to 54","55 to 64","65 plus","65 plus","Other","Other"))) %>%
  mutate(GEND = factor(GEND, labels = c("female", "male", "Other", "Other", "Other"))) %>%
  mutate(HHINC = factor (HHINC, labels = c("25K", "25K", "25K", "50K", "50K", "75K", "100K", "150K", "150plus", "Other","Other", "Other"))) %>%
  mutate(EDUC = factor(EDUC, labels = c("Bach", "HS", "HS", "Master", "Other", "Other"))) %>%
  mutate(RaceW = ifelse(RaceW ==1 , "White", "Others")) %>%
  mutate(RaceW = as.factor(RaceW))-> WeightData

# Removing all except Weight data
# rm(list=setdiff(ls(), "WeightData"))

# Next lets break down surveys
# remove education (not weighting on this variable)
WeightData %>% select(-c("EDUC")) -> WeightData
# backup
Data <- WeightData
# create wide
WeightData %>% pivot_wider(id_cols = c(ID, HHINC :RaceW) ) -> Survey
Survey <- as.data.frame(Survey)
nrow(Survey) # 613

# Split survey data by data availability
# complete on all three variables (gender, age, income)
Survey %>% 
  filter(GEND != "Other") %>%
  filter(AGE != "Other") %>%
  filter(HHINC != "Other") -> SurveyAll
nrow(SurveyAll) # 516
# Also segregated data for Survey having other for Income.
Survey %>% 
  filter(GEND != "Other") %>%
  filter(AGE != "Other") %>%
  filter(HHINC == "Other") %>%
  select(-HHINC)-> SurveyHHINCOther
nrow(SurveyHHINCOther) # 64
# Remaining data to see if anything can be done.
Survey %>% 
  filter((AGE == "Other") | (GEND == "Other")) -> SurveyRemaining
nrow(SurveyRemaining) # 33

# Next we need to manage the levels required
# All
SurveyAll %>%
  mutate(AGE = factor(AGE, labels = c("less than 25","25 to 34","35 to 44","45 to 54","55 to 64","65 plus"))) %>%
  mutate(GEND = factor(GEND, labels = c("female", "male"))) %>%
  mutate(HHINC = factor (HHINC, labels = c("25K", "50K", "75K", "100K", "150K", "150plus"))) -> SurveyAll
# HHINCOther
SurveyHHINCOther %>%
  mutate(AGE = factor(AGE, labels = c("less than 25","25 to 34","35 to 44","45 to 54","55 to 64","65 plus"))) %>%
  mutate(GEND = factor(GEND, labels = c("female", "male"))) -> SurveyHHINCOther

########################################
# Conduct weighting

# Weighting most (complete data on age, gender, race/ethnicity, and income)
raking1 <- anesrake(inputter = target1, dataframe = SurveyAll, caseid = SurveyAll$ID, 
                    choosemethod = 'total', type ='pctlim', pctlim = 0.05)

# Weighting other (complete data on age, gender, race/ethnciity, not on income)
raking2 <- anesrake(inputter = target2, dataframe = SurveyHHINCOther, caseid = SurveyHHINCOther$ID, 
                    choosemethod = 'total', type ='pctlim', pctlim = 0.05)

# Add weights to survey data
SurveyAll$weight <- raking1$weightvec
SurveyHHINCOther$weight <- raking2$weightvec
SurveyRemaining$weight <- 1

# Extract weights
SurveyAll %>% select(ID, weight) -> SurveyAll1
SurveyHHINCOther %>% select(ID, weight) -> SurveyHHINCOther1
SurveyRemaining %>% select(ID, weight) -> SurveyRemaining1
Weight <- rbind(SurveyAll1, SurveyHHINCOther1, SurveyRemaining1)

# Merge with WeightData
Final <- merge(WeightData, Weight, by = "ID")

# Create Stated with weights
Final %>% select(-c(HHINC:RaceW)) -> Final

# Add number
Final$number <- rep(c(0,1,2,3,4,5), times=nrow(Final)/6)

# Convert choice to character
Final$Choice <- as.character(Final$Choice)

# Make wide
Final %>% pivot_wider(id_cols = c("ID", "ResponseId", "av", "weight"), names_from = number, values_from = Choice : Speed_35_B) -> FinalData

########################################
# Save files

# Save weights
write.csv(SurveyAll, file=file.path("Analysis", "Stated preference", "Weights517_All.csv"), row.names=F)
write.csv(SurveyHHINCOther, file=file.path("Analysis", "Stated preference", "Weights064_HHINCOther.csv"), row.names=F)
write.csv(SurveyRemaining, file=file.path("Analysis", "Stated preference", "Weights033_Remaining.csv"), row.names=F)
write.csv(Weight, file=file.path("Analysis", "Stated preference", "WeightsAll.csv"), row.names=F)
#write.csv(FinalData, file ="Allweightsfinal.csv")

# Save Stated with weights
saveRDS(Final, file=file.path("Analysis", "Stated preference", "Stated_MNL_weight.rds"))
write.csv(Final, file=file.path("Analysis", "Stated preference", "Stated_MNL_weight.csv"), row.names=F)

# For MNL no need of wider format 
saveRDS(FinalData, file=file.path("Analysis", "Stated preference", "Stated_wide_weight.rds"))
write.csv(FinalData, file=file.path("Analysis", "Stated preference", "Stated_wide_weight.csv"), row.names=F)

########################################
# Clean up

# Remove
rm(raking1, raking2)
rm(Survey, SurveyAll, SurveyAll1, SurveyHHINCOther, SurveyHHINCOther1, SurveyRemaining, SurveyRemaining1)
rm(Weight, Final, FinalData)
rm(expected, target1, target2)
rm(Complete, Data, WeightData)
gc()

########################################
# END
########################################