########################################
# Project:  MPC-603 Bicycle safety roundabouts
# Authors:  Patrick Singleton (patrick.singleton@usu.edu)
#           Niranjan Poudel (niranjan.poudel@usu.edu)
# File:     create_hetero.R
# Date:     2021 Spring, Summer
# About:    Script to prepare survey data for heterogeneity analysis
########################################

# Major edits
# 2021-XX-XX created by NP
# 2021-05-10 updated by NP
# 2021-05-13 updated by PAS, reformat script

########################################
# Notes

# Open R project first, then open this R script

# Install, load packages
# library("")
library(tidyr)
library(dplyr)

########################################
# Load data

# Load stated data
Complete <- readRDS(file.path("Analysis", "Stated preference", "Data cleaning and weighting", "dat_stated.rds"))

########################################
# Prepare data

# Select required columns for heterogeneity analysis
Complete %>%
  select(ResponseId, ID, av, Choice,
         Island_small_A, Island_large_A, Lane_1_A, Lane_2_A, 
         Facility_No_A, Facility_Shared_A, Facility_Ramps_A, Facility_Seperated_A,
         Volume_Low_A, Volume_Medium_A, Volume_High_A, Speed_25_A, Speed_35_A,
         Island_small_B, Island_large_B, Lane_1_B, Lane_2_B, 
         Facility_No_B, Facility_Ramps_B, Facility_Shared_B, Facility_Seperated_B, 
         Volume_Low_B, Volume_Medium_B, Volume_High_B, Speed_25_B, Speed_35_B, 
         MODEUSE2_BIKE, MODEROUND_BIKE, MODEROUTE_BIKE, ROUNDMODE, CRASH_HIT, CRASH_NHIT,
         # HHINC, AGE, GEND, RACE_WHIT, EDUC, 
         HHINC, AGE, GEND, RACE_WHIT:RACE_NA, EDUC, 
         STUD, WORK, btype, BIKES, CARS, ADULT, CHILD) -> HeteroData

# Process race/ethnicity data to create white-only vs. other
HeteroData %>%
  mutate(RaceSum = RACE_WHIT + RACE_HISP + RACE_ASIA + RACE_BLAC + RACE_AIAN + RACE_NHPI + RACE_SD + RACE_NA) -> HeteroData
HeteroData %>%
  mutate(RaceW = ifelse((RACE_WHIT == TRUE & RaceSum == 1), 1, 0)) %>%
  select(-c(RACE_WHIT:RACE_NA, RaceSum))-> HeteroData
# create race other variable
HeteroData$RaceOther <- 1 - HeteroData$RaceW

# Converting some ordered factor columns to characters
HeteroData %>%
  mutate(BIKES = as.character(BIKES),
         CARS = as.character(CARS),
         ADULT = as.character(ADULT),
         CHILD = as.character(CHILD)) -> HeteroData

# Change values in some columns
# inspect
table(HeteroData$BIKES)/6; table(is.na(HeteroData$BIKES))/6
table(HeteroData$CARS)/6; table(is.na(HeteroData$CARS))/6
table(HeteroData$ADULT)/6; table(is.na(HeteroData$ADULT))/6
table(HeteroData$CHILD)/6; table(is.na(HeteroData$CHILD))/6
# columns with 5+ we will change to 5
# HeteroData[HeteroData == "5+"] <- 5
HeteroData$BIKES[HeteroData$BIKES=="5+"] <- 5
HeteroData$CARS[HeteroData$CARS=="5+"] <- 5
HeteroData$ADULT[HeteroData$ADULT=="5+"] <- 5
HeteroData$CHILD[HeteroData$CHILD=="5+"] <- 5
# create dummy missing
HeteroData$BIKES_Miss <- ifelse(is.na(HeteroData$BIKES), 1, 0)
HeteroData$CARS_Miss <- ifelse(is.na(HeteroData$CARS), 1, 0)
HeteroData$ADULT_Miss <- ifelse(is.na(HeteroData$ADULT), 1, 0)
HeteroData$CHILD_Miss <- ifelse(is.na(HeteroData$CHILD), 1, 0)
# columns with NA we will change to 0
HeteroData$BIKES[is.na(HeteroData$BIKES)] <- 0
HeteroData$CARS[is.na(HeteroData$CARS)] <- 0
HeteroData$ADULT[is.na(HeteroData$ADULT)] <- 0
HeteroData$CHILD[is.na(HeteroData$CHILD)] <- 0
# create as integer
HeteroData$BIKES <- as.integer(HeteroData$BIKES)
HeteroData$CARS <- as.integer(HeteroData$CARS)
HeteroData$ADULT <- as.integer(HeteroData$ADULT)
HeteroData$CHILD <- as.integer(HeteroData$CHILD)
# add 1 to ADULT (b/c measured other adults)
HeteroData$ADULT <- HeteroData$ADULT + 1
# --> in the model, use just ADULT_miss

# Lets work with categorical variables and missing values
# Convert some factors to characters
myfac <- c("MODEUSE2_BIKE", "MODEROUND_BIKE", "MODEROUTE_BIKE", "ROUNDMODE", 
         "HHINC", "AGE", "GEND", "EDUC", "STUD", "WORK", "btype")
HeteroData[myfac] <- lapply(HeteroData[myfac], as.character)
# note NAs
HeteroData[HeteroData == "NA"] <- "PNA"
HeteroData[is.na(HeteroData)] <- "Missing"
summary(HeteroData)
# Visualize NAs
# library(naniar)
# vis_miss(Hetro1) 
# library(tidyverse)
# Convert back to factors
HeteroData[myfac] <- lapply(HeteroData[myfac], factor)
summary(HeteroData)
# Change levels of factors
table(HeteroData$MODEUSE2_BIKE)
levels(HeteroData$MODEUSE2_BIKE) <- c("Few","Week","Freq","Freq","Few","Never")
table(HeteroData$MODEROUND_BIKE)
levels(HeteroData$MODEROUND_BIKE) <- c("Always","Missing","Never","Often","Sometimes")
table(HeteroData$MODEROUTE_BIKE)
levels(HeteroData$MODEROUTE_BIKE) <- c("Missing","No","Yes_Avoid","Yes_AvoidAlt","Yes_Prefer")
table(HeteroData$ROUNDMODE)
# levels(HeteroData$ROUNDMODE) <- c("Missing","No","YesMuchLess","YesMuchMore","YesSomeLess","YesSomeMore")
levels(HeteroData$ROUNDMODE) <- c("Missing","No","YesLess","YesMore","YesLess","YesMore")
table(HeteroData$HHINC)
# levels(HeteroData$HHINC) <- c("50","50","50","50","50","50_75","75_150","75_150","150","DK","Missing","PNA")
levels(HeteroData$HHINC) <- c("50","50","50","50","50","50_75","75_100","100_150","150","Missing","Missing","Missing")
table(HeteroData$AGE)
# levels(HeteroData$AGE) <- c("25","25","25_34","35_44","45_54","55","55","55","Missing","PNA")
levels(HeteroData$AGE) <- c("25","25","25_34","35_44","45_54","55_64","65","65","Missing","Missing")
table(HeteroData$GEND)
# levels(HeteroData$GEND) <- c("Female","Male","Missing","PNA","SD")
levels(HeteroData$GEND) <- c("Female","Male","Missing","Missing","Missing")
table(HeteroData$EDUC)
# levels(HeteroData$EDUC) <- c("Bach","LessBAc","LessBAc","MastUp","Missing","PNA")
levels(HeteroData$EDUC) <- c("Bach","LessBAc","LessBAc","MastUp","Missing","Missing")
table(HeteroData$STUD)
levels(HeteroData$STUD) <- c("Missing","No","Yes")
table(HeteroData$WORK)
levels(HeteroData$WORK) <- c("Missing","No","Yes")
# -> in the models, change variables to match these new levels

# Changing logical columns to number 
HeteroData$RaceW <- as.numeric(HeteroData$RaceW)
HeteroData$CRASH_HIT <- as.numeric(HeteroData$CRASH_HIT)
HeteroData$CRASH_NHIT <- as.numeric(HeteroData$CRASH_NHIT)
HeteroData$Crash <- HeteroData$CRASH_HIT + HeteroData$CRASH_NHIT
summary(HeteroData$Crash)
HeteroData$Crash[HeteroData$Crash > 1] <- 1

# Create dummy variables
library(fastDummies)
Hetero <- dummy_cols(HeteroData, select_columns = myfac, remove_most_frequent_dummy = T, remove_selected_columns = T)
mycols <- colnames(Hetero)
mycols %>% gsub("(?<=btype_[[:alpha:]]).*","",., perl = T) -> mycols
colnames(Hetero) <- mycols

# Check correlation on missing
tnm <- names(Hetero)[grepl("Miss", names(Hetero))]; tnm
tcor <- cor(Hetero[,tnm]); tcor #; View(tcor)
rm(tnm, tcor)
table(Hetero$ADULT_Miss, Hetero$BIKES_Miss)/6; table(Hetero$ADULT_Miss, Hetero$CARS_Miss)/6; table(Hetero$ADULT_Miss, Hetero$CHILD_Miss)/6
# --> use ADULT_Miss, don't use BIKES_Miss CARS_Miss CHILD_Miss
table(Hetero$STUD_Missing, Hetero$WORK_Missing)/6
# --> use STUD_Missing, don't use WORK_Missing
table(Hetero$STUD_Missing, Hetero$WORK_Missing)/6; table(Hetero$STUD_Missing, Hetero$ADULT_Miss)/6; table(Hetero$STUD_Missing, Hetero$ADULT_Miss)/6
# --> use STUD_Missing, don't use ADULT_Miss

########################################
# Save files

# Save Hetero
saveRDS(Hetero, file=file.path("Analysis", "Stated preference", "Hetero.rds"))
write.csv(Hetero, file=file.path("Analysis", "Stated preference", "Hetero.csv"), row.names=F)

########################################
# Clean up

# Remove
rm(myfac, mycols)
rm(Complete, HeteroData, Hetero)
gc()

########################################
# END
########################################