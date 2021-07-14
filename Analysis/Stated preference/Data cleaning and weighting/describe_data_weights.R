########################################
# Project:  MPC-603 Bicycle safety roundabouts
# Authors:  Patrick Singleton (patrick.singleton@usu.edu)
#           Niranjan Poudel (niranjan.poudel@usu.edu)
# File:     describe_data_weights.R
# Date:     2021 Summer
# About:    Script to get data descriptives
########################################

# Major edits
# 2021-06-12 created by NP
# 2021-06-18 updated by PAS, reformat script↕

########################################
# Notes

# Open R project first, then open this R script

# Install, load packages
# library("")
library(tidyr)
# library(dplyr)

########################################
# Load and prepare data

# Load data with weights
Complete <- readRDS(file.path("Analysis", "Stated preference", "Data cleaning and weighting", "dat_stated.rds"))
Hetero <- readRDS(file.path("Analysis", "Stated preference", "Data cleaning and weighting", "Hetero.rds"))
Final <- readRDS(file=file.path("Analysis", "Stated preference", "Data cleaning and weighting", "Stated_MNL_weight.rds"))
FinalData <- readRDS(file=file.path("Analysis", "Stated preference", "Data cleaning and weighting", "Stated_wide_weight.rds"))

# Load weights
expected <- read.csv(file=file.path("Data", "Census", "Expected.csv"), stringsAsFactors=F)

# Create wide
Complete$number <- rep(c(0,1,2,3,4,5), times=nrow(Complete)/6)
Complete %>% pivot_wider(id_cols=c("ID", "ResponseId", "av", QN:btype), names_from=number) -> CompleteWide
CompleteWide <- CompleteWide[!duplicated(CompleteWide$ID),]
Hetero$number <- rep(c(0,1,2,3,4,5), times=nrow(Hetero)/6)
Hetero %>% pivot_wider(id_cols=c("ResponseId","ID", "av", CRASH_HIT:btype_S), names_from=number) -> HeteroWide

# Get weights
Weights <- FinalData[,c("ID", "weight")]

# Choose dataset
dat1 <- CompleteWide
dat2 <- HeteroWide

# Add weights
dat1 <- merge(Weights, dat1, by="ID")
dat2 <- merge(Weights, dat2, by="ID")

# Inspect
names(dat1)
str(dat1)
summary(dat1)
names(dat2)
str(dat2)
summary(dat2)

########################################
# Descriptives

# Age
summary(dat1[,grep("AGE", names(dat1))])
colSums(dat2[,grep("AGE", names(dat2))])
round(colSums(dat2[,grep("AGE", names(dat2))])/nrow(dat2)*100,2)
nrow(dat2) - sum(colSums(dat2[,grep("AGE", names(dat2))]))
round(100 - sum(colSums(dat2[,grep("AGE", names(dat2))])/nrow(dat2)*100),2)

# Gender
summary(dat1[,grep("GEND", names(dat1))])
colSums(dat2[,grep("GEND", names(dat2))])
round(colSums(dat2[,grep("GEND", names(dat2))])/nrow(dat2)*100,2)
nrow(dat2) - sum(colSums(dat2[,grep("GEND", names(dat2))]))
round(100 - sum(colSums(dat2[,grep("GEND", names(dat2))])/nrow(dat2)*100),2)

# Race
summary(dat1[,grep("RACE", names(dat1))])
colSums(dat2[,grep("Race", names(dat2))])
round(colSums(dat2[,grep("Race", names(dat2))])/nrow(dat2)*100,2)
nrow(dat2) - sum(colSums(dat2[,grep("Race", names(dat2))]))
round(100 - sum(colSums(dat2[,grep("Race", names(dat2))])/nrow(dat2)*100),2)

# Education
summary(dat1[,grep("EDUC", names(dat1))])
colSums(dat2[,grep("EDUC", names(dat2))])
round(colSums(dat2[,grep("EDUC", names(dat2))])/nrow(dat2)*100,2)
nrow(dat2) - sum(colSums(dat2[,grep("EDUC", names(dat2))]))
round(100 - sum(colSums(dat2[,grep("EDUC", names(dat2))])/nrow(dat2)*100),2)

# Student status
summary(dat1[,grep("STUD", names(dat1))])
colSums(dat2[,grep("STUD", names(dat2))])
round(colSums(dat2[,grep("STUD", names(dat2))])/nrow(dat2)*100,2)
nrow(dat2) - sum(colSums(dat2[,grep("STUD", names(dat2))]))
round(100 - sum(colSums(dat2[,grep("STUD", names(dat2))])/nrow(dat2)*100),2)

# Worker status
summary(dat1[,grep("WORK", names(dat1))])
colSums(dat2[,grep("WORK", names(dat2))])
round(colSums(dat2[,grep("WORK", names(dat2))])/nrow(dat2)*100,2)
nrow(dat2) - sum(colSums(dat2[,grep("WORK", names(dat2))]))
round(100 - sum(colSums(dat2[,grep("WORK", names(dat2))])/nrow(dat2)*100),2)

# Income
summary(dat1[,grep("INC", names(dat1))])
colSums(dat2[,grep("INC", names(dat2))])
round(colSums(dat2[,grep("INC", names(dat2))])/nrow(dat2)*100,2)
nrow(dat2) - sum(colSums(dat2[,grep("INC", names(dat2))]))
round(100 - sum(colSums(dat2[,grep("INC", names(dat2))])/nrow(dat2)*100),2)

# Bikes
summary(dat1$BIKES)
round(mean(dat2$BIKES),2); round(sd(dat2$BIKES), 2)
sum(dat2$BIKES_Miss)
round(sum(dat2$BIKES_Miss)/nrow(dat2)*100,2)
nrow(dat2) - sum(sum(dat2$BIKES_Miss))
round(100 - sum(sum(dat2$BIKES_Miss)/nrow(dat2)*100),2)

# Cars
summary(dat1$CARS)
round(mean(dat2$CARS),2); round(sd(dat2$CARS), 2)
sum(dat2$CARS_Miss)
round(sum(dat2$CARS_Miss)/nrow(dat2)*100,2)
nrow(dat2) - sum(sum(dat2$CARS_Miss))
round(100 - sum(sum(dat2$CARS_Miss)/nrow(dat2)*100),2)

# Adults
summary(dat1$ADULT)
round(mean(dat2$ADULT),2); round(sd(dat2$ADULT), 2)
sum(dat2$ADULT_Miss)
round(sum(dat2$ADULT_Miss)/nrow(dat2)*100,2)
nrow(dat2) - sum(sum(dat2$ADULT_Miss))
round(100 - sum(sum(dat2$ADULT_Miss)/nrow(dat2)*100),2)

# Children
summary(dat1$CHILD)
round(mean(dat2$CHILD),2); round(sd(dat2$CHILD), 2)
sum(dat2$CHILD_Miss)
round(sum(dat2$CHILD_Miss)/nrow(dat2)*100,2)
nrow(dat2) - sum(sum(dat2$CHILD_Miss))
round(100 - sum(sum(dat2$CHILD_Miss)/nrow(dat2)*100),2)

# Bike use frequency
summary(dat1[,grep("MODEUSE2_BIKE", names(dat1))])
colSums(dat2[,grep("MODEUSE2_BIKE", names(dat2))])
round(colSums(dat2[,grep("MODEUSE2_BIKE", names(dat2))])/nrow(dat2)*100,2)
nrow(dat2) - sum(colSums(dat2[,grep("MODEUSE2_BIKE", names(dat2))]))
round(100 - sum(colSums(dat2[,grep("MODEUSE2_BIKE", names(dat2))])/nrow(dat2)*100),2)

# Cyclist type
summary(dat1[,grep("btype", names(dat1))])
colSums(dat2[,grep("btype", names(dat2))])
round(colSums(dat2[,grep("btype", names(dat2))])/nrow(dat2)*100,2)
nrow(dat2) - sum(colSums(dat2[,grep("btype", names(dat2))]))
round(100 - sum(colSums(dat2[,grep("btype", names(dat2))])/nrow(dat2)*100),2)

# Crash experience
summary(dat1[,grep("CRASH", names(dat1))])
sum(dat2$Crash)
round(sum(dat2$Crash)/nrow(dat2)*100,2)
nrow(dat2) - sum(sum(dat2$Crash))
round(100 - sum(sum(dat2$Crash)/nrow(dat2)*100),2)

# Frequency of roundabouts when bicycling
summary(dat1[,grep("MODEROUND_BIKE", names(dat1))])
colSums(dat2[,grep("MODEROUND_BIKE", names(dat2))])
round(colSums(dat2[,grep("MODEROUND_BIKE", names(dat2))])/nrow(dat2)*100,2)
nrow(dat2) - sum(colSums(dat2[,grep("MODEROUND_BIKE", names(dat2))]))
round(100 - sum(colSums(dat2[,grep("MODEROUND_BIKE", names(dat2))])/nrow(dat2)*100),2)

# Roundabouts affect route choice
summary(dat1[,grep("MODEROUTE_BIKE", names(dat1))])
colSums(dat2[,grep("MODEROUTE_BIKE", names(dat2))])
round(colSums(dat2[,grep("MODEROUTE_BIKE", names(dat2))])/nrow(dat2)*100,2)
nrow(dat2) - sum(colSums(dat2[,grep("MODEROUTE_BIKE", names(dat2))]))
round(100 - sum(colSums(dat2[,grep("MODEROUTE_BIKE", names(dat2))])/nrow(dat2)*100),2)

# Roundabouts affect mode choice
summary(dat1[,grep("ROUNDMODE", names(dat1))])
colSums(dat2[,grep("ROUNDMODE", names(dat2))])
round(colSums(dat2[,grep("ROUNDMODE", names(dat2))])/nrow(dat2)*100,2)
nrow(dat2) - sum(colSums(dat2[,grep("ROUNDMODE", names(dat2))]))
round(100 - sum(colSums(dat2[,grep("ROUNDMODE", names(dat2))])/nrow(dat2)*100),2)

########################################
# Descriptives for weights

# Age
summary(dat1[,grep("AGE", names(dat1))])
colSums(dat2[,grep("AGE", names(dat2))])
nrow(dat2) - sum(colSums(dat2[,grep("AGE", names(dat2))]))
sum(dat2$weight[dat2$AGE_25==1])
sum(dat2$weight[dat2$AGE_25_34==1])
sum(dat2$weight[dat2$AGE_35_44==1])
sum(dat2$weight[dat2$AGE_45_54==1])
sum(dat2$weight[rowSums(dat2[,grep("AGE", names(dat2))])==0])
sum(dat2$weight[dat2$AGE_65==1])
sum(dat2$weight[dat2$AGE_Missing==1])

# Gender
summary(dat1[,grep("GEND", names(dat1))])
colSums(dat2[,grep("GEND", names(dat2))])
nrow(dat2) - sum(colSums(dat2[,grep("GEND", names(dat2))]))
sum(dat2$weight[rowSums(dat2[,grep("GEND", names(dat2))])==0])
sum(dat2$weight[dat2$GEND_Female==1])
sum(dat2$weight[dat2$GEND_Missing==1])

# Race
summary(dat1[,grep("RACE", names(dat1))])
colSums(dat2[,grep("Race", names(dat2))])
nrow(dat2) - sum(colSums(dat2[,grep("Race", names(dat2))]))
sum(dat2$weight[dat2$RaceW==1])
sum(dat2$weight[dat2$RaceOther==1])

# Income
summary(dat1[,grep("INC", names(dat1))])
colSums(dat2[,grep("INC", names(dat2))])
nrow(dat2) - sum(colSums(dat2[,grep("INC", names(dat2))]))
sum(dat2$weight[dat2$HHINC_50==1])
sum(dat2$weight[dat2$HHINC_50_75==1])
sum(dat2$weight[dat2$HHINC_75_100==1])
sum(dat2$weight[dat2$HHINC_100_150==1])
sum(dat2$weight[rowSums(dat2[,grep("INC", names(dat2))])==0])
sum(dat2$weight[dat2$HHINC_Missing==1])

# Target weights
expected

########################################
# Clean up

# Remove
rm(Complete, CompleteWide)
rm(Hetero, HeteroWide)
rm(Final, FinalData)
rm(expected, Weights)
rm(dat1, dat2)
gc()

########################################
# END
########################################