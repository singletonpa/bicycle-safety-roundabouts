########################################
# Project:  MPC-603 Bicycle safety roundabouts
# Authors:  Patrick Singleton (patrick.singleton@usu.edu)
#           Niranjan Poudel (niranjan.poudel@usu.edu)
# File:     describe_data.R
# Date:     2022 Summer
# About:    Script to get data descriptives
########################################

# Major edits
# 2022-07-16 created by PAS, from describe_data_weights.R in Stated preference

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
Complete <- readRDS(file.path("Analysis", "Comfort analysis", "Data cleaning", "Comfort.rds"))

# Choose dataset
dat <- Complete

# Inspect
names(dat)
str(dat)
summary(dat)

########################################
# Descriptives

# Age
colSums(dat[,grep("AGE", names(dat))])
round(colSums(dat[,grep("AGE", names(dat))])/nrow(dat)*100,2)

# Gender
colSums(dat[,grep("GEND", names(dat))])
round(colSums(dat[,grep("GEND", names(dat))])/nrow(dat)*100,2)

# Race
colSums(dat[,grep("Race", names(dat))])
round(colSums(dat[,grep("Race", names(dat))])/nrow(dat)*100,2)

# Education
colSums(dat[,grep("EDUC", names(dat))])
round(colSums(dat[,grep("EDUC", names(dat))])/nrow(dat)*100,2)

# Student status
colSums(dat[,grep("STUD", names(dat))])
round(colSums(dat[,grep("STUD", names(dat))])/nrow(dat)*100,2)

# Worker status
colSums(dat[,grep("WORK", names(dat))])
round(colSums(dat[,grep("WORK", names(dat))])/nrow(dat)*100,2)

# Income
colSums(dat[,grep("INC", names(dat))])
round(colSums(dat[,grep("INC", names(dat))])/nrow(dat)*100,2)

# Bikes
round(mean(dat$BIKES),2); round(sd(dat$BIKES), 2)
sum(dat$BIKES_Miss)
round(sum(dat$BIKES_Miss)/nrow(dat)*100,2)

# Cars
round(mean(dat$CARS),2); round(sd(dat$CARS), 2)
sum(dat$CARS_Miss)
round(sum(dat$CARS_Miss)/nrow(dat)*100,2)

# Adults
round(mean(dat$ADULT),2); round(sd(dat$ADULT), 2)
sum(dat$ADULT_Miss)
round(sum(dat$ADULT_Miss)/nrow(dat)*100,2)

# Children
round(mean(dat$CHILD),2); round(sd(dat$CHILD), 2)
sum(dat$CHILD_Miss)
round(sum(dat$CHILD_Miss)/nrow(dat)*100,2)

# Bike use frequency
colSums(dat[,grep("MODEUSE2_BIKE", names(dat))])
round(colSums(dat[,grep("MODEUSE2_BIKE", names(dat))])/nrow(dat)*100,2)

# Cyclist type
colSums(dat[,grep("btype", names(dat))])
round(colSums(dat[,grep("btype", names(dat))])/nrow(dat)*100,2)

# Crash experience
sum(dat$Crash)
round(sum(dat$Crash)/nrow(dat)*100,2)
nrow(dat) - sum(sum(dat$Crash))
round(100 - sum(sum(dat$Crash)/nrow(dat)*100),2)

# Frequency of roundabouts when bicycling
colSums(dat[,grep("MODEROUND_BIKE", names(dat))])
round(colSums(dat[,grep("MODEROUND_BIKE", names(dat))])/nrow(dat)*100,2)

# Roundabouts affect route choice
colSums(dat[,grep("MODEROUTE_BIKE", names(dat))])
round(colSums(dat[,grep("MODEROUTE_BIKE", names(dat))])/nrow(dat)*100,2)

# Roundabouts affect mode choice
colSums(dat[,grep("ROUNDMODE", names(dat))])
round(colSums(dat[,grep("ROUNDMODE", names(dat))])/nrow(dat)*100,2)

########################################
# Clean up

# Remove
rm(Complete)
rm(dat)
gc()

########################################
# END
########################################