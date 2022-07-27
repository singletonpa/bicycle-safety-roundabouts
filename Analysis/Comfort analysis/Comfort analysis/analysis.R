########################################
# Project:  MPC-603 Bicycle safety roundabouts
# Authors:  Patrick Singleton (patrick.singleton@usu.edu)
#           Niranjan Poudel (niranjan.poudel@usu.edu)
# File:     test.R
# Date:     2022 Summer
# About:    Script to test various analyses
########################################

# Major edits
# 2022-07-16 created by PAS

########################################
# Notes

# Open R project first, then open this R script

# Install, load packages
library("MASS")
library("lmtest")
library("lavaan")

########################################
# Load and prepare data

# Load data
Complete <- readRDS(file.path("Analysis", "Comfort analysis", "Data cleaning", "Comfort.rds"))

# Choose dataset
dat <- Complete

# Inspect
names(dat)
str(dat)
summary(dat)

# Created ordered DVs
dat$OSUPCOMFALL <- ordered(dat$SUPCOMFALL)
dat$OSUPCOMF_ENTR <- ordered(dat$SUPCOMF_ENTR)
dat$OSUPCOMF_CIRC <- ordered(dat$SUPCOMF_CIRC)
dat$OSUPCOMF_EXIT <- ordered(dat$SUPCOMF_EXIT)
dat$OSUPCOMF_SIDE <- ordered(dat$SUPCOMF_SIDE)
dat$OSUPCOMF_CROS <- ordered(dat$SUPCOMF_CROS)

# Create some IVs for lavaan
dat$MODEUSE2_BIKE_NeverFew <- dat$MODEUSE2_BIKE_Never + dat$MODEUSE2_BIKE_Few
dat$MODEUSE2_BIKE_FewWeek <- dat$MODEUSE2_BIKE_Few + dat$MODEUSE2_BIKE_Week
dat$MODEUSE2_BIKE_NeverFewWeek <- dat$MODEUSE2_BIKE_Never + dat$MODEUSE2_BIKE_Few + dat$MODEUSE2_BIKE_Week
dat$MODEROUTE_BIKE_Yes_AvoidAvoidAlt <- dat$MODEROUTE_BIKE_Yes_Avoid + dat$MODEROUTE_BIKE_Yes_AvoidAlt

########################################
# Descriptive analysis

# Frequency of scenarios
table(dat$Scenario)

# Tables of comfort: overall, 5x situations
table(dat$OSUPCOMFALL)
table(dat$OSUPCOMF_ENTR)
table(dat$OSUPCOMF_CIRC)
table(dat$OSUPCOMF_EXIT)
table(dat$OSUPCOMF_SIDE)
table(dat$OSUPCOMF_CROS)

# Tables of overall comfort, by roundabout attributes
table(dat$Island_small, dat$OSUPCOMFALL)[2,]; table(dat$Island_large, dat$OSUPCOMFALL)[2,]
table(dat$Lane_1, dat$OSUPCOMFALL)[2,]; table(dat$Lane_2, dat$OSUPCOMFALL)[2,]
table(dat$Facility_No, dat$OSUPCOMFALL)[2,]; table(dat$Facility_Shared, dat$OSUPCOMFALL)[2,]; table(dat$Facility_Ramps, dat$OSUPCOMFALL)[2,]; table(dat$Facility_Seperated, dat$OSUPCOMFALL)[2,]
table(dat$Volume_Low, dat$OSUPCOMFALL)[2,]; table(dat$Volume_Medium, dat$OSUPCOMFALL)[2,]; table(dat$Volume_High, dat$OSUPCOMFALL)[2,]
table(dat$Speed_25, dat$OSUPCOMFALL)[2,]; table(dat$Speed_35, dat$OSUPCOMFALL)[2,]

# Tables of overall comfort, by personal characteristics
table(dat$btype_S, dat$OSUPCOMFALL)[2,]; table(dat$btype_E, dat$OSUPCOMFALL)[2,]; table(dat$btype_I, dat$OSUPCOMFALL)[2,]

########################################
# Model 1
# ordered probit
# DV: overall comfort
# IV: roundabout attributes, personal characteristics

# Inspect
table(dat$OSUPCOMFALL)

# 1.0 null model
mod1.0 <- polr(OSUPCOMFALL ~ 1, data=dat, method="probit")
summary(mod1.0); logLik(mod1.0); coeftest(mod1.0)

# 1.1 add roundabout attributes
mod1.1 <- update(mod1.0, formula= . ~ . + Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35)
summary(mod1.1); logLik(mod1.1); coeftest(mod1.1)

# 1.2 add personal characteristics (use p<0.15)
# age: AGE_Missing
coeftest(update(mod1.1, formula= . ~ . + AGE_25 + AGE_25_34 + AGE_35_44 + AGE_45_54 + AGE_65 + AGE_Missing))
# gender: GEND_Female + GEND_Missing
coeftest(update(mod1.1, formula= . ~ . + GEND_Female + GEND_Missing))
# race/ethnicity: (none)
coeftest(update(mod1.1, formula= . ~ . + RaceOther))
# education level: (none)
coeftest(update(mod1.1, formula= . ~ . + EDUC_LessBAc + EDUC_Bach + EDUC_Missing))
# student status: (none)
coeftest(update(mod1.1, formula= . ~ . + STUD_Yes + STUD_Missing))
# worker status: (none)
coeftest(update(mod1.1, formula= . ~ . + WORK_No + WORK_Missing))
# household income: HHINC_50 + HHINC_Missing
coeftest(update(mod1.1, formula= . ~ . + HHINC_50 + HHINC_50_75 + HHINC_75_100 + HHINC_150 + HHINC_Missing))
# bicycles: (none)
coeftest(update(mod1.1, formula= . ~ . + BIKES + BIKES_Miss))
# motor vehicles: CARS
coeftest(update(mod1.1, formula= . ~ . + CARS + CARS_Miss))
# adults: (none)
coeftest(update(mod1.1, formula= . ~ . + ADULT + ADULT_Miss))
# children: (none)
coeftest(update(mod1.1, formula= . ~ . + CHILD + CHILD_Miss))
# bicycle use frequency: MODEUSE2_BIKE_Never
coeftest(update(mod1.1, formula= . ~ . + MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week))
# type of cyclist: btype_S + btype_E
coeftest(update(mod1.1, formula= . ~ . + btype_S + btype_E + btype_M))
# crash experience: (none)
coeftest(update(mod1.1, formula= . ~ . + Crash))
# frequency roundabout: MODEROUND_BIKE_Always
coeftest(update(mod1.1, formula= . ~ . + MODEROUND_BIKE_Never + MODEROUND_BIKE_Often + MODEROUND_BIKE_Always + MODEROUND_BIKE_Missing))
# route choice: MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt
coeftest(update(mod1.1, formula= . ~ . + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + MODEROUTE_BIKE_Yes_Prefer + MODEROUTE_BIKE_Missing))
# mode choice: ROUNDMODE_YesLess + ROUNDMODE_YesMore
coeftest(update(mod1.1, formula= . ~ . + ROUNDMODE_YesLess + ROUNDMODE_YesMore + ROUNDMODE_Missing))
# test combined (use p<0.10)
coeftest(update(mod1.1, formula= . ~ . + GEND_Female + GEND_Missing + HHINC_50 + HHINC_Missing + CARS + MODEUSE2_BIKE_Never + btype_S + btype_E + MODEROUND_BIKE_Always + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesLess + ROUNDMODE_YesMore))
coeftest(update(mod1.1, formula= . ~ . + GEND_Female + GEND_Missing + HHINC_50 + HHINC_Missing + MODEUSE2_BIKE_Never + btype_S + btype_E + MODEROUND_BIKE_Always + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesLess + ROUNDMODE_YesMore))
coeftest(update(mod1.1, formula= . ~ . + GEND_Female + GEND_Missing + HHINC_50 + HHINC_Missing + MODEUSE2_BIKE_Never + btype_S + btype_E + MODEROUND_BIKE_Always + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesLess))
coeftest(update(mod1.1, formula= . ~ . + GEND_Female + GEND_Missing + HHINC_50 + HHINC_Missing + btype_S + btype_E + MODEROUND_BIKE_Always + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesLess))
coeftest(update(mod1.1, formula= . ~ . + GEND_Female + GEND_Missing + HHINC_50 + HHINC_Missing + btype_S + btype_E + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesLess))
# final combined
mod1.2 <- update(mod1.1, formula= . ~ . + GEND_Female + GEND_Missing + HHINC_50 + HHINC_Missing + btype_S + btype_E + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesLess)
summary(mod1.2); logLik(mod1.2); coeftest(mod1.2)

########################################
# Model 2
# ordered probit
# DV: overall comfort
# IV: 5x situation comfort, roundabout attributes, personal characteristics

# Inspect
table(dat$OSUPCOMFALL)

# 2.0 null model
mod2.0 <- polr(OSUPCOMFALL ~ 1, data=dat, method="probit")
summary(mod2.0); logLik(mod2.0); coeftest(mod2.0)

# 2.1 5x situation comfort
mod2.1 <- update(mod2.0, formula= . ~ . + OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS)
summary(mod2.1); logLik(mod2.1); coeftest(mod2.1)

# 2.2 add roundabout attributes
mod2.2 <- update(mod2.1, formula= . ~ . + Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35)
summary(mod2.2); logLik(mod2.2); coeftest(mod2.2)

# 2.3 add personal characteristics (use p<0.15)
# age: AGE_25_34 + AGE_Missing
coeftest(update(mod2.2, formula= . ~ . + AGE_25 + AGE_25_34 + AGE_35_44 + AGE_45_54 + AGE_65 + AGE_Missing))
# gender: (none)
coeftest(update(mod2.2, formula= . ~ . + GEND_Female + GEND_Missing))
# race/ethnicity: RaceOther
coeftest(update(mod2.2, formula= . ~ . + RaceOther))
# education level: (none)
coeftest(update(mod2.2, formula= . ~ . + EDUC_LessBAc + EDUC_Bach + EDUC_Missing))
# student status: (none)
coeftest(update(mod2.2, formula= . ~ . + STUD_Yes + STUD_Missing))
# worker status: (none)
coeftest(update(mod2.2, formula= . ~ . + WORK_No + WORK_Missing))
# household income: (none)
coeftest(update(mod2.2, formula= . ~ . + HHINC_50 + HHINC_50_75 + HHINC_75_100 + HHINC_150 + HHINC_Missing))
# bicycles: (none)
coeftest(update(mod2.2, formula= . ~ . + BIKES + BIKES_Miss))
# motor vehicles: CARS
coeftest(update(mod2.2, formula= . ~ . + CARS + CARS_Miss))
# adults: ADULT
coeftest(update(mod2.2, formula= . ~ . + ADULT + ADULT_Miss))
# children: (none)
coeftest(update(mod2.2, formula= . ~ . + CHILD + CHILD_Miss))
# bicycle use frequency: I(MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week)
coeftest(update(mod2.2, formula= . ~ . + MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week))
# type of cyclist: btype_S + btype_E + btype_M
coeftest(update(mod2.2, formula= . ~ . + btype_S + btype_E + btype_M))
# crash experience: Crash
coeftest(update(mod2.2, formula= . ~ . + Crash))
# frequency roundabout: (none)
coeftest(update(mod2.2, formula= . ~ . + MODEROUND_BIKE_Never + MODEROUND_BIKE_Often + MODEROUND_BIKE_Always + MODEROUND_BIKE_Missing))
# route choice: MODEROUTE_BIKE_Yes_AvoidAlt
coeftest(update(mod2.2, formula= . ~ . + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + MODEROUTE_BIKE_Yes_Prefer + MODEROUTE_BIKE_Missing))
# mode choice: (none)
coeftest(update(mod2.2, formula= . ~ . + ROUNDMODE_YesLess + ROUNDMODE_YesMore + ROUNDMODE_Missing))
# test combined (use p<0.10)
coeftest(update(mod2.2, formula= . ~ . + AGE_25_34 + RaceOther + CARS + ADULT + I(MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week) + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_AvoidAlt))
coeftest(update(mod2.2, formula= . ~ . + AGE_25_34 + RaceOther + CARS + I(MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week) + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_AvoidAlt))
coeftest(update(mod2.2, formula= . ~ . + AGE_25_34 + RaceOther + CARS + I(MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week) + I(btype_S + btype_E) + Crash + MODEROUTE_BIKE_Yes_AvoidAlt))
coeftest(update(mod2.2, formula= . ~ . + RaceOther + CARS + I(MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week) + I(btype_S + btype_E) + Crash + MODEROUTE_BIKE_Yes_AvoidAlt))
coeftest(update(mod2.2, formula= . ~ . + RaceOther + CARS + I(btype_S + btype_E) + Crash + MODEROUTE_BIKE_Yes_AvoidAlt))
# final combined
mod2.3 <- update(mod2.2, formula= . ~ . + RaceOther + CARS + I(btype_S + btype_E) + Crash + MODEROUTE_BIKE_Yes_AvoidAlt)
summary(mod2.3); logLik(mod2.3); coeftest(mod2.3)

########################################
# Model 3
# ordered probit
# DV: 5x situation comfort
# IV: roundabout attributes, personal characteristics

# Inspect
table(dat$OSUPCOMF_ENTR)
table(dat$OSUPCOMF_CIRC)
table(dat$OSUPCOMF_EXIT)
table(dat$OSUPCOMF_SIDE)
table(dat$OSUPCOMF_CROS)

# 3.0 null model
mod3.0.entr <- polr(OSUPCOMF_ENTR ~ 1, data=dat, method="probit")
mod3.0.circ <- polr(OSUPCOMF_CIRC ~ 1, data=dat, method="probit")
mod3.0.exit <- polr(OSUPCOMF_EXIT ~ 1, data=dat, method="probit")
mod3.0.side <- polr(OSUPCOMF_SIDE ~ 1, data=dat, method="probit")
mod3.0.cros <- polr(OSUPCOMF_CROS ~ 1, data=dat, method="probit")
summary(mod3.0.entr); logLik(mod3.0.entr); coeftest(mod3.0.entr)
summary(mod3.0.circ); logLik(mod3.0.circ); coeftest(mod3.0.circ)
summary(mod3.0.exit); logLik(mod3.0.exit); coeftest(mod3.0.exit)
summary(mod3.0.side); logLik(mod3.0.side); coeftest(mod3.0.side)
summary(mod3.0.cros); logLik(mod3.0.cros); coeftest(mod3.0.cros)

# 3.1 add roundabout attributes
mod3.1.entr <- update(mod3.0.entr, formula= . ~ . + Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35)
mod3.1.circ <- update(mod3.0.circ, formula= . ~ . + Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35)
mod3.1.exit <- update(mod3.0.exit, formula= . ~ . + Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35)
mod3.1.side <- update(mod3.0.side, formula= . ~ . + Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35)
mod3.1.cros <- update(mod3.0.cros, formula= . ~ . + Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35)
summary(mod3.1.entr); logLik(mod3.1.entr); coeftest(mod3.1.entr)
summary(mod3.1.circ); logLik(mod3.1.circ); coeftest(mod3.1.circ)
summary(mod3.1.exit); logLik(mod3.1.exit); coeftest(mod3.1.exit)
summary(mod3.1.side); logLik(mod3.1.side); coeftest(mod3.1.side)
summary(mod3.1.cros); logLik(mod3.1.cros); coeftest(mod3.1.cros)

# 3.2.entr add personal characteristics (use p<0.15)
# age: AGE_35_44 + AGE_Missing
coeftest(update(mod3.1.entr, formula= . ~ . + AGE_25 + AGE_25_34 + AGE_35_44 + AGE_45_54 + AGE_65 + AGE_Missing))
# gender: GEND_Female + GEND_Missing
coeftest(update(mod3.1.entr, formula= . ~ . + GEND_Female + GEND_Missing))
# race/ethnicity: (none)
coeftest(update(mod3.1.entr, formula= . ~ . + RaceOther))
# education level: (none)
coeftest(update(mod3.1.entr, formula= . ~ . + EDUC_LessBAc + EDUC_Bach + EDUC_Missing))
# student status: (none)
coeftest(update(mod3.1.entr, formula= . ~ . + STUD_Yes + STUD_Missing))
# worker status: WORK_No
coeftest(update(mod3.1.entr, formula= . ~ . + WORK_No + WORK_Missing))
# household income: HHINC_50
coeftest(update(mod3.1.entr, formula= . ~ . + HHINC_50 + HHINC_50_75 + HHINC_75_100 + HHINC_150 + HHINC_Missing))
# bicycles: BIKES
coeftest(update(mod3.1.entr, formula= . ~ . + BIKES + BIKES_Miss))
# motor vehicles: (none)
coeftest(update(mod3.1.entr, formula= . ~ . + CARS + CARS_Miss))
# adults: ADULT
coeftest(update(mod3.1.entr, formula= . ~ . + ADULT + ADULT_Miss))
# children: (none)
coeftest(update(mod3.1.entr, formula= . ~ . + CHILD + CHILD_Miss))
# bicycle use frequency: MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week
coeftest(update(mod3.1.entr, formula= . ~ . + MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week))
# type of cyclist: btype_S + btype_E + btype_M
coeftest(update(mod3.1.entr, formula= . ~ . + btype_S + btype_E + btype_M))
# crash experience: Crash
coeftest(update(mod3.1.entr, formula= . ~ . + Crash))
# frequency roundabout: MODEROUND_BIKE_Missing
coeftest(update(mod3.1.entr, formula= . ~ . + MODEROUND_BIKE_Never + MODEROUND_BIKE_Often + MODEROUND_BIKE_Always + MODEROUND_BIKE_Missing))
# route choice: MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + MODEROUTE_BIKE_Missing
coeftest(update(mod3.1.entr, formula= . ~ . + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + MODEROUTE_BIKE_Yes_Prefer + MODEROUTE_BIKE_Missing))
# mode choice: ROUNDMODE_YesLess + ROUNDMODE_YesMore + ROUNDMODE_Missing
coeftest(update(mod3.1.entr, formula= . ~ . + ROUNDMODE_YesLess + ROUNDMODE_YesMore + ROUNDMODE_Missing))
# test combined (use p<0.10)
coeftest(update(mod3.1.entr, formula= . ~ . + AGE_35_44 + GEND_Female + GEND_Missing + WORK_No + HHINC_50 + BIKES + ADULT + MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesLess + ROUNDMODE_YesMore))
coeftest(update(mod3.1.entr, formula= . ~ . + AGE_35_44 + GEND_Female + GEND_Missing + WORK_No + HHINC_50 + ADULT + MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesLess + ROUNDMODE_YesMore))
coeftest(update(mod3.1.entr, formula= . ~ . + AGE_35_44 + GEND_Female + GEND_Missing + WORK_No + HHINC_50 + ADULT + MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesMore))
coeftest(update(mod3.1.entr, formula= . ~ . + AGE_35_44 + GEND_Female + GEND_Missing + WORK_No + ADULT + MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesMore))
coeftest(update(mod3.1.entr, formula= . ~ . + AGE_35_44 + GEND_Female + GEND_Missing + WORK_No + ADULT + MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt))
coeftest(update(mod3.1.entr, formula= . ~ . + AGE_35_44 + GEND_Female + GEND_Missing + WORK_No + ADULT + MODEUSE2_BIKE_Never + I(MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week) + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt))
coeftest(update(mod3.1.entr, formula= . ~ . + AGE_35_44 + GEND_Female + GEND_Missing + ADULT + MODEUSE2_BIKE_Never + I(MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week) + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt))
coeftest(update(mod3.1.entr, formula= . ~ . + AGE_35_44 + GEND_Female + GEND_Missing + MODEUSE2_BIKE_Never + I(MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week) + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt))
coeftest(update(mod3.1.entr, formula= . ~ . + AGE_35_44 + GEND_Female + GEND_Missing + MODEUSE2_BIKE_Never + I(MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week) + btype_S + btype_E + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt))
coeftest(update(mod3.1.entr, formula= . ~ . + AGE_35_44 + GEND_Female + GEND_Missing + MODEUSE2_BIKE_Never + btype_S + btype_E + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt))
coeftest(update(mod3.1.entr, formula= . ~ . + AGE_35_44 + GEND_Female + GEND_Missing + btype_S + btype_E + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt))
# final combined
mod3.2.entr <- update(mod3.1.entr, formula= . ~ . + AGE_35_44 + GEND_Female + GEND_Missing + btype_S + btype_E + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt)
summary(mod3.2.entr); logLik(mod3.2.entr); coeftest(mod3.2.entr)

# 3.2.circ add personal characteristics (use p<0.15)
# age: AGE_Missing
coeftest(update(mod3.1.circ, formula= . ~ . + AGE_25 + AGE_25_34 + AGE_35_44 + AGE_45_54 + AGE_65 + AGE_Missing))
# gender: GEND_Female + GEND_Missing
coeftest(update(mod3.1.circ, formula= . ~ . + GEND_Female + GEND_Missing))
# race/ethnicity: (none)
coeftest(update(mod3.1.circ, formula= . ~ . + RaceOther))
# education level: (none)
coeftest(update(mod3.1.circ, formula= . ~ . + EDUC_LessBAc + EDUC_Bach + EDUC_Missing))
# student status: (none)
coeftest(update(mod3.1.circ, formula= . ~ . + STUD_Yes + STUD_Missing))
# worker status: (none)
coeftest(update(mod3.1.circ, formula= . ~ . + WORK_No + WORK_Missing))
# household income: HHINC_50
coeftest(update(mod3.1.circ, formula= . ~ . + HHINC_50 + HHINC_50_75 + HHINC_75_100 + HHINC_150 + HHINC_Missing))
# bicycles: (none)
coeftest(update(mod3.1.circ, formula= . ~ . + BIKES + BIKES_Miss))
# motor vehicles: (none)
coeftest(update(mod3.1.circ, formula= . ~ . + CARS + CARS_Miss))
# adults: ADULT
coeftest(update(mod3.1.circ, formula= . ~ . + ADULT + ADULT_Miss))
# children: CHILD
coeftest(update(mod3.1.circ, formula= . ~ . + CHILD + CHILD_Miss))
# bicycle use frequency: MODEUSE2_BIKE_Never + I(MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week)
coeftest(update(mod3.1.circ, formula= . ~ . + MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week))
# type of cyclist: btype_S + btype_E + btype_M
coeftest(update(mod3.1.circ, formula= . ~ . + btype_S + btype_E + btype_M))
# crash experience: Crash
coeftest(update(mod3.1.circ, formula= . ~ . + Crash))
# frequency roundabout: (none)
coeftest(update(mod3.1.circ, formula= . ~ . + MODEROUND_BIKE_Never + MODEROUND_BIKE_Often + MODEROUND_BIKE_Always + MODEROUND_BIKE_Missing))
# route choice: MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt
coeftest(update(mod3.1.circ, formula= . ~ . + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + MODEROUTE_BIKE_Yes_Prefer + MODEROUTE_BIKE_Missing))
# mode choice: ROUNDMODE_YesLess + ROUNDMODE_YesMore
coeftest(update(mod3.1.circ, formula= . ~ . + ROUNDMODE_YesLess + ROUNDMODE_YesMore + ROUNDMODE_Missing))
# test combined (use p<0.10)
coeftest(update(mod3.1.circ, formula= . ~ . + GEND_Female + GEND_Missing + HHINC_50 + ADULT + CHILD + MODEUSE2_BIKE_Never + I(MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week) + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesLess + ROUNDMODE_YesMore))
coeftest(update(mod3.1.circ, formula= . ~ . + GEND_Female + GEND_Missing + HHINC_50 + ADULT + CHILD + MODEUSE2_BIKE_Never + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesLess + ROUNDMODE_YesMore))
coeftest(update(mod3.1.circ, formula= . ~ . + GEND_Female + GEND_Missing + HHINC_50 + ADULT + CHILD + MODEUSE2_BIKE_Never + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesMore))
coeftest(update(mod3.1.circ, formula= . ~ . + GEND_Female + GEND_Missing + HHINC_50 + ADULT + CHILD + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesMore))
coeftest(update(mod3.1.circ, formula= . ~ . + HHINC_50 + ADULT + CHILD + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesMore))
coeftest(update(mod3.1.circ, formula= . ~ . + HHINC_50 + ADULT + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesMore))
# final combined
mod3.2.circ <- update(mod3.1.circ, formula= . ~ . + HHINC_50 + ADULT + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesMore)
summary(mod3.2.circ); logLik(mod3.2.circ); coeftest(mod3.2.circ)

# 3.2.exit add personal characteristics (use p<0.15)
# age: AGE_65 + AGE_Missing
coeftest(update(mod3.1.exit, formula= . ~ . + AGE_25 + AGE_25_34 + AGE_35_44 + AGE_45_54 + AGE_65 + AGE_Missing))
# gender: GEND_Female + GEND_Missing
coeftest(update(mod3.1.exit, formula= . ~ . + GEND_Female + GEND_Missing))
# race/ethnicity: RaceOther
coeftest(update(mod3.1.exit, formula= . ~ . + RaceOther))
# education level: EDUC_LessBAc + EDUC_Bach
coeftest(update(mod3.1.exit, formula= . ~ . + EDUC_LessBAc + EDUC_Bach + EDUC_Missing))
# student status: (none)
coeftest(update(mod3.1.exit, formula= . ~ . + STUD_Yes + STUD_Missing))
# worker status: WORK_Missing
coeftest(update(mod3.1.exit, formula= . ~ . + WORK_No + WORK_Missing))
# household income: HHINC_50
coeftest(update(mod3.1.exit, formula= . ~ . + HHINC_50 + HHINC_50_75 + HHINC_75_100 + HHINC_150 + HHINC_Missing))
# bicycles: (none)
coeftest(update(mod3.1.exit, formula= . ~ . + BIKES + BIKES_Miss))
# motor vehicles: (none)
coeftest(update(mod3.1.exit, formula= . ~ . + CARS + CARS_Miss))
# adults: ADULT + ADULT_Miss
coeftest(update(mod3.1.exit, formula= . ~ . + ADULT + ADULT_Miss))
# children: (none)
coeftest(update(mod3.1.exit, formula= . ~ . + CHILD + CHILD_Miss))
# bicycle use frequency: MODEUSE2_BIKE_Never
coeftest(update(mod3.1.exit, formula= . ~ . + MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week))
# type of cyclist: btype_S + btype_E + btype_M
coeftest(update(mod3.1.exit, formula= . ~ . + btype_S + btype_E + btype_M))
# crash experience: Crash
coeftest(update(mod3.1.exit, formula= . ~ . + Crash))
# frequency roundabout: MODEROUND_BIKE_Missing
coeftest(update(mod3.1.exit, formula= . ~ . + MODEROUND_BIKE_Never + MODEROUND_BIKE_Often + MODEROUND_BIKE_Always + MODEROUND_BIKE_Missing))
# route choice: MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + MODEROUTE_BIKE_Missing
coeftest(update(mod3.1.exit, formula= . ~ . + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + MODEROUTE_BIKE_Yes_Prefer + MODEROUTE_BIKE_Missing))
# mode choice: ROUNDMODE_YesLess + ROUNDMODE_YesMore + ROUNDMODE_Missing
coeftest(update(mod3.1.exit, formula= . ~ . + ROUNDMODE_YesLess + ROUNDMODE_YesMore + ROUNDMODE_Missing))
# test combined (use p<0.10)
coeftest(update(mod3.1.exit, formula= . ~ . + AGE_65 + GEND_Female + GEND_Missing + RaceOther + EDUC_LessBAc + EDUC_Bach + HHINC_50 + ADULT + MODEUSE2_BIKE_Never + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesLess + ROUNDMODE_YesMore))
coeftest(update(mod3.1.exit, formula= . ~ . + AGE_65 + GEND_Female + GEND_Missing + EDUC_LessBAc + EDUC_Bach + HHINC_50 + ADULT + MODEUSE2_BIKE_Never + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesLess + ROUNDMODE_YesMore))
coeftest(update(mod3.1.exit, formula= . ~ . + AGE_65 + GEND_Female + GEND_Missing + EDUC_LessBAc + EDUC_Bach + HHINC_50 + ADULT + MODEUSE2_BIKE_Never + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesLess))
coeftest(update(mod3.1.exit, formula= . ~ . + AGE_65 + EDUC_LessBAc + EDUC_Bach + HHINC_50 + ADULT + MODEUSE2_BIKE_Never + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesLess))
coeftest(update(mod3.1.exit, formula= . ~ . + AGE_65 + EDUC_LessBAc + EDUC_Bach + HHINC_50 + ADULT + MODEUSE2_BIKE_Never + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt))
coeftest(update(mod3.1.exit, formula= . ~ . + AGE_65 + EDUC_LessBAc + EDUC_Bach + HHINC_50 + ADULT + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt))
coeftest(update(mod3.1.exit, formula= . ~ . + AGE_65 + EDUC_LessBAc + EDUC_Bach + HHINC_50 + ADULT + btype_S + btype_E + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt))
coeftest(update(mod3.1.exit, formula= . ~ . + AGE_65 + EDUC_LessBAc + EDUC_Bach + HHINC_50 + ADULT + I(btype_S + btype_E) + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt))
# final combined
mod3.2.exit <- update(mod3.1.exit, formula= . ~ . + AGE_65 + EDUC_LessBAc + EDUC_Bach + HHINC_50 + ADULT + I(btype_S + btype_E) + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt)
summary(mod3.2.exit); logLik(mod3.2.exit); coeftest(mod3.2.exit)

# 3.2.side add personal characteristics (use p<0.15)
# age: AGE_65
coeftest(update(mod3.1.side, formula= . ~ . + AGE_25 + AGE_25_34 + AGE_35_44 + AGE_45_54 + AGE_65 + AGE_Missing))
# gender: GEND_Female + GEND_Missing
coeftest(update(mod3.1.side, formula= . ~ . + GEND_Female + GEND_Missing))
# race/ethnicity: (none)
coeftest(update(mod3.1.side, formula= . ~ . + RaceOther))
# education level: EDUC_LessBAc
coeftest(update(mod3.1.side, formula= . ~ . + EDUC_LessBAc + EDUC_Bach + EDUC_Missing))
# student status: STUD_Yes + STUD_Missing
coeftest(update(mod3.1.side, formula= . ~ . + STUD_Yes + STUD_Missing))
# worker status: WORK_No + WORK_Missing
coeftest(update(mod3.1.side, formula= . ~ . + WORK_No + WORK_Missing))
# household income: HHINC_Missing
coeftest(update(mod3.1.side, formula= . ~ . + HHINC_50 + HHINC_50_75 + HHINC_75_100 + HHINC_150 + HHINC_Missing))
# bicycles: BIKES + BIKES_Miss
coeftest(update(mod3.1.side, formula= . ~ . + BIKES + BIKES_Miss))
# motor vehicles: (none)
coeftest(update(mod3.1.side, formula= . ~ . + CARS + CARS_Miss))
# adults: ADULT
coeftest(update(mod3.1.side, formula= . ~ . + ADULT + ADULT_Miss))
# children: (none)
coeftest(update(mod3.1.side, formula= . ~ . + CHILD + CHILD_Miss))
# bicycle use frequency: I(MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few) + MODEUSE2_BIKE_Week
coeftest(update(mod3.1.side, formula= . ~ . + MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week))
# type of cyclist: btype_S + btype_E + btype_
coeftest(update(mod3.1.side, formula= . ~ . + btype_S + btype_E + btype_M))
# crash experience: Crash
coeftest(update(mod3.1.side, formula= . ~ . + Crash))
# frequency roundabout: MODEROUND_BIKE_Never
coeftest(update(mod3.1.side, formula= . ~ . + MODEROUND_BIKE_Never + MODEROUND_BIKE_Often + MODEROUND_BIKE_Always + MODEROUND_BIKE_Missing))
# route choice: (none)
coeftest(update(mod3.1.side, formula= . ~ . + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + MODEROUTE_BIKE_Yes_Prefer + MODEROUTE_BIKE_Missing))
# mode choice: ROUNDMODE_YesLess
coeftest(update(mod3.1.side, formula= . ~ . + ROUNDMODE_YesLess + ROUNDMODE_YesMore + ROUNDMODE_Missing))
# test combined (use p<0.10)
coeftest(update(mod3.1.side, formula= . ~ . + AGE_65 + GEND_Female + GEND_Missing + EDUC_LessBAc + STUD_Yes + WORK_No + BIKES + ADULT + I(MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few) + MODEUSE2_BIKE_Week + btype_S + btype_E + Crash + MODEROUND_BIKE_Never + ROUNDMODE_YesLess))
coeftest(update(mod3.1.side, formula= . ~ . + GEND_Female + GEND_Missing + EDUC_LessBAc + STUD_Yes + WORK_No + BIKES + ADULT + I(MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few) + MODEUSE2_BIKE_Week + btype_S + btype_E + Crash + MODEROUND_BIKE_Never + ROUNDMODE_YesLess))
coeftest(update(mod3.1.side, formula= . ~ . + GEND_Female + GEND_Missing + EDUC_LessBAc + STUD_Yes + WORK_No + BIKES + ADULT + I(MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few) + MODEUSE2_BIKE_Week + btype_S + btype_E + Crash + ROUNDMODE_YesLess))
coeftest(update(mod3.1.side, formula= . ~ . + GEND_Female + GEND_Missing + STUD_Yes + WORK_No + BIKES + ADULT + I(MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few) + MODEUSE2_BIKE_Week + btype_S + btype_E + Crash + ROUNDMODE_YesLess))
coeftest(update(mod3.1.side, formula= . ~ . + STUD_Yes + WORK_No + BIKES + ADULT + I(MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few) + MODEUSE2_BIKE_Week + btype_S + btype_E + Crash + ROUNDMODE_YesLess))
coeftest(update(mod3.1.side, formula= . ~ . + STUD_Yes + WORK_No + BIKES + ADULT + I(MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few) + MODEUSE2_BIKE_Week + I(btype_S + btype_E) + Crash + ROUNDMODE_YesLess))
# final combined
mod3.2.side <- update(mod3.1.side, formula= . ~ . + STUD_Yes + WORK_No + BIKES + ADULT + I(MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few) + MODEUSE2_BIKE_Week + I(btype_S + btype_E) + Crash + ROUNDMODE_YesLess)
summary(mod3.2.side); logLik(mod3.2.side); coeftest(mod3.2.side)

# 3.2.cros add personal characteristics (use p<0.15)
# age: (none)
coeftest(update(mod3.1.cros, formula= . ~ . + AGE_25 + AGE_25_34 + AGE_35_44 + AGE_45_54 + AGE_65 + AGE_Missing))
# gender: GEND_Female + GEND_Missing
coeftest(update(mod3.1.cros, formula= . ~ . + GEND_Female + GEND_Missing))
# race/ethnicity: (none)
coeftest(update(mod3.1.cros, formula= . ~ . + RaceOther))
# education level: EDUC_LessBAc
coeftest(update(mod3.1.cros, formula= . ~ . + EDUC_LessBAc + EDUC_Bach + EDUC_Missing))
# student status: STUD_Yes
coeftest(update(mod3.1.cros, formula= . ~ . + STUD_Yes + STUD_Missing))
# worker status: WORK_No + WORK_Missing
coeftest(update(mod3.1.cros, formula= . ~ . + WORK_No + WORK_Missing))
# household income: (none)
coeftest(update(mod3.1.cros, formula= . ~ . + HHINC_50 + HHINC_50_75 + HHINC_75_100 + HHINC_150 + HHINC_Missing))
# bicycles: BIKES + BIKES_Miss
coeftest(update(mod3.1.cros, formula= . ~ . + BIKES + BIKES_Miss))
# motor vehicles: (none)
coeftest(update(mod3.1.cros, formula= . ~ . + CARS + CARS_Miss))
# adults: (none)
coeftest(update(mod3.1.cros, formula= . ~ . + ADULT + ADULT_Miss))
# children: (none)
coeftest(update(mod3.1.cros, formula= . ~ . + CHILD + CHILD_Miss))
# bicycle use frequency: I(MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few) + MODEUSE2_BIKE_Week
coeftest(update(mod3.1.cros, formula= . ~ . + MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week))
# type of cyclist: (none)
coeftest(update(mod3.1.cros, formula= . ~ . + btype_S + btype_E + btype_M))
# crash experience: Crash
coeftest(update(mod3.1.cros, formula= . ~ . + Crash))
# frequency roundabout: MODEROUND_BIKE_Always
coeftest(update(mod3.1.cros, formula= . ~ . + MODEROUND_BIKE_Never + MODEROUND_BIKE_Often + MODEROUND_BIKE_Always + MODEROUND_BIKE_Missing))
# route choice: MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt
coeftest(update(mod3.1.cros, formula= . ~ . + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + MODEROUTE_BIKE_Yes_Prefer + MODEROUTE_BIKE_Missing))
# mode choice: ROUNDMODE_YesMore
coeftest(update(mod3.1.cros, formula= . ~ . + ROUNDMODE_YesLess + ROUNDMODE_YesMore + ROUNDMODE_Missing))
# test combined (use p<0.10)
coeftest(update(mod3.1.cros, formula= . ~ . + GEND_Female + GEND_Missing + EDUC_LessBAc + STUD_Yes + WORK_No + BIKES + I(MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few) + MODEUSE2_BIKE_Week + Crash + MODEROUND_BIKE_Always + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesMore))
coeftest(update(mod3.1.cros, formula= . ~ . + GEND_Female + GEND_Missing + EDUC_LessBAc + WORK_No + BIKES + I(MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few) + MODEUSE2_BIKE_Week + Crash + MODEROUND_BIKE_Always + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesMore))
coeftest(update(mod3.1.cros, formula= . ~ . + GEND_Female + GEND_Missing + EDUC_LessBAc + BIKES + I(MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few) + MODEUSE2_BIKE_Week + Crash + MODEROUND_BIKE_Always + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesMore))
coeftest(update(mod3.1.cros, formula= . ~ . + GEND_Female + GEND_Missing + EDUC_LessBAc + I(MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few) + MODEUSE2_BIKE_Week + Crash + MODEROUND_BIKE_Always + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesMore))
# final combined
mod3.2.cros <- update(mod3.1.cros, formula= . ~ . + GEND_Female + GEND_Missing + EDUC_LessBAc + I(MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few) + MODEUSE2_BIKE_Week + Crash + MODEROUND_BIKE_Always + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesMore)
summary(mod3.2.cros); logLik(mod3.2.cros); coeftest(mod3.2.cros)

########################################
# Model 4
# path analysis, with ordered probit links
# DV: overall comfort, 5x situation comfort
# IV: 5x situation comfort, roundabout attributes, personal characteristics

# 4.0 null model
form4.0 <- "
  OSUPCOMFALL ~ 1
  OSUPCOMF_ENTR ~ 1
  OSUPCOMF_CIRC ~ 1
  OSUPCOMF_EXIT ~ 1
  OSUPCOMF_SIDE ~ 1
  OSUPCOMF_CROS ~ 1
  OSUPCOMFALL ~~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_ENTR ~~ OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_CIRC ~~ OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_EXIT ~~ OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_SIDE ~~ OSUPCOMF_CROS
"
mod4.0 <- lavaan(form4.0, data=dat, ordered=T)
summary(mod4.0, standardized=T, fit.measures=T, rsquare=T)

# 4.1 add 5x situation comfort
form4.1 <- "
  OSUPCOMFALL ~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_ENTR ~ 1
  OSUPCOMF_CIRC ~ 1
  OSUPCOMF_EXIT ~ 1
  OSUPCOMF_SIDE ~ 1
  OSUPCOMF_CROS ~ 1
  # OSUPCOMFALL ~~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_ENTR ~~ OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_CIRC ~~ OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_EXIT ~~ OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_SIDE ~~ OSUPCOMF_CROS
"
mod4.1 <- lavaan(form4.1, data=dat, ordered=T)
summary(mod4.1, standardized=T, fit.measures=T, rsquare=T)

# 4.1a add 5x situation comfort as formative
form4.1a <- "
  OSUPCOMFALL ~ 1*fSUPCOMFALL
  fSUPCOMFALL <~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_ENTR ~ 1
  OSUPCOMF_CIRC ~ 1
  OSUPCOMF_EXIT ~ 1
  OSUPCOMF_SIDE ~ 1
  OSUPCOMF_CROS ~ 1
  # OSUPCOMFALL ~~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_ENTR ~~ OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_CIRC ~~ OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_EXIT ~~ OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_SIDE ~~ OSUPCOMF_CROS
"
mod4.1a <- lavaan(form4.1a, data=dat, ordered=T)
summary(mod4.1a, standardized=T, fit.measures=T, rsquare=T)

# 4.2 add roundabout attributes
form4.2 <- "
  OSUPCOMFALL ~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMFALL ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_ENTR ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_CIRC ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_EXIT ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_SIDE ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_CROS ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  # OSUPCOMFALL ~~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_ENTR ~~ OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_CIRC ~~ OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_EXIT ~~ OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_SIDE ~~ OSUPCOMF_CROS
"
mod4.2 <- lavaan(form4.2, data=dat, ordered=T)
summary(mod4.2, standardized=T, fit.measures=T, rsquare=T)

# 4.3.entr add personal characteristics (use p<0.15 one-by-one, then use p<0.10 for all-at-once)
# first: GEND_Female + GEND_Missing + HHINC_50 + BIKES + ADULT + MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week + btype_S + btype_E + Crash MODEROUND_BIKE_Always + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesLess + ROUNDMODE_YesMore
# final: GEND_Female + GEND_Missing + HHINC_50 + btype_S + btype_E + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt
form4.3.entr <- "
  OSUPCOMFALL ~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMFALL ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_ENTR ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_CIRC ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_EXIT ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_SIDE ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_CROS ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_ENTR ~ GEND_Female + GEND_Missing + HHINC_50 + btype_S + btype_E + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt
  OSUPCOMF_CIRC ~ 1
  OSUPCOMF_EXIT ~ 1
  OSUPCOMF_SIDE ~ 1
  OSUPCOMF_CROS ~ 1
  # OSUPCOMFALL ~~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_ENTR ~~ OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_CIRC ~~ OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_EXIT ~~ OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_SIDE ~~ OSUPCOMF_CROS
"
mod4.3.entr <- lavaan(form4.3.entr, data=dat, ordered=T)
summary(mod4.3.entr)
summary(mod4.3.entr, standardized=T, fit.measures=T, rsquare=T)

# 4.3.circ add personal characteristics (use p<0.15 one-by-one, then use p<0.10 for all-at-once)
# first: GEND_Female + GEND_Missing + HHINC_50 + ADULT + CHILD + MODEUSE2_BIKE_Never + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesLess + ROUNDMODE_YesMore
# final: HHINC_50 + btype_S + btype_E + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt
form4.3.circ <- "
  OSUPCOMFALL ~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMFALL ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_ENTR ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_CIRC ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_EXIT ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_SIDE ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_CROS ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_ENTR ~ 1
  OSUPCOMF_CIRC ~ HHINC_50 + btype_S + btype_E + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt
  OSUPCOMF_EXIT ~ 1
  OSUPCOMF_SIDE ~ 1
  OSUPCOMF_CROS ~ 1
  # OSUPCOMFALL ~~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_ENTR ~~ OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_CIRC ~~ OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_EXIT ~~ OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_SIDE ~~ OSUPCOMF_CROS
"
mod4.3.circ <- lavaan(form4.3.circ, data=dat, ordered=T)
summary(mod4.3.circ)
summary(mod4.3.circ, standardized=T, fit.measures=T, rsquare=T)

# 4.3.exit add personal characteristics (use p<0.15 one-by-one, then use p<0.10 for all-at-once)
# first: AGE_65 + GEND_Female + GEND_Missing + RaceOther + EDUC_LessBAc + EDUC_Bach + HHINC_50 + ADULT + MODEUSE2_BIKE_NeverFewWeek + btype_S + btype_E + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesLess + ROUNDMODE_YesMore
# final: AGE_65 + EDUC_LessBAc + HHINC_50 + ADULT + btype_S + btype_E + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt
form4.3.exit <- "
  OSUPCOMFALL ~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMFALL ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_ENTR ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_CIRC ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_EXIT ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_SIDE ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_CROS ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_ENTR ~ 1
  OSUPCOMF_CIRC ~ 1
  OSUPCOMF_EXIT ~ AGE_65 + EDUC_LessBAc + HHINC_50 + ADULT + btype_S + btype_E + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt
  OSUPCOMF_SIDE ~ 1
  OSUPCOMF_CROS ~ 1
  # OSUPCOMFALL ~~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_ENTR ~~ OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_CIRC ~~ OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_EXIT ~~ OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_SIDE ~~ OSUPCOMF_CROS
"
mod4.3.exit <- lavaan(form4.3.exit, data=dat, ordered=T)
summary(mod4.3.exit)
summary(mod4.3.exit, standardized=T, fit.measures=T, rsquare=T)

# 4.3.side add personal characteristics (use p<0.15 one-by-one, then use p<0.10 for all-at-once)
# first: GEND_Female + GEND_Missing + EDUC_LessBAc + STUD_Yes + WORK_No + BIKES + ADULT + MODEUSE2_BIKE_NeverFewWeek + btype_S + btype_E + Crash + MODEROUND_BIKE_Never + ROUNDMODE_YesLess
# final: STUD_Yes + WORK_No + BIKES + ADULT + MODEUSE2_BIKE_NeverFewWeek + btype_S + btype_E + ROUNDMODE_YesLess
form4.3.side <- "
  OSUPCOMFALL ~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMFALL ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_ENTR ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_CIRC ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_EXIT ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_SIDE ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_CROS ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_ENTR ~ 1
  OSUPCOMF_CIRC ~ 1
  OSUPCOMF_EXIT ~ 1
  OSUPCOMF_SIDE ~ STUD_Yes + WORK_No + BIKES + ADULT + MODEUSE2_BIKE_NeverFewWeek + btype_S + btype_E + ROUNDMODE_YesLess
  OSUPCOMF_CROS ~ 1
  # OSUPCOMFALL ~~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_ENTR ~~ OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_CIRC ~~ OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_EXIT ~~ OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_SIDE ~~ OSUPCOMF_CROS
"
mod4.3.side <- lavaan(form4.3.side, data=dat, ordered=T)
summary(mod4.3.side)
summary(mod4.3.side, standardized=T, fit.measures=T, rsquare=T)

# 4.3.cros add personal characteristics (use p<0.15 one-by-one, then use p<0.10 for all-at-once)
# first: EDUC_LessBAc + WORK_No + BIKES + MODEUSE2_BIKE_NeverFewWeek + btype_S + Crash + MODEROUND_BIKE_Always + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesMore
# final: EDUC_LessBAc + MODEUSE2_BIKE_NeverFewWeek + btype_S + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesMore
form4.3.cros <- "
  OSUPCOMFALL ~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE
  OSUPCOMFALL ~ OSUPCOMF_CROS + Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_ENTR ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_CIRC ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_EXIT ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_SIDE ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_CROS ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_ENTR ~ 1
  OSUPCOMF_CIRC ~ 1
  OSUPCOMF_EXIT ~ 1
  OSUPCOMF_SIDE ~ 1
  OSUPCOMF_CROS ~ EDUC_LessBAc + MODEUSE2_BIKE_NeverFewWeek + btype_S + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesMore
  # OSUPCOMFALL ~~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_ENTR ~~ OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_CIRC ~~ OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_EXIT ~~ OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_SIDE ~~ OSUPCOMF_CROS
"
mod4.3.cros <- lavaan(form4.3.cros, data=dat, ordered=T)
summary(mod4.3.cros)
summary(mod4.3.cros, standardized=T, fit.measures=T, rsquare=T)

# 4.3 add personal characteristics (5x)
# first: (all from above)
# final: (only those with p<0.10)
form4.3 <- "
  OSUPCOMFALL ~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMFALL ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_ENTR ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_CIRC ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_EXIT ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_SIDE ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_CROS ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_ENTR ~ GEND_Female + GEND_Missing + btype_S + btype_E + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt
  OSUPCOMF_CIRC ~ HHINC_50 + btype_S + btype_E + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt
  OSUPCOMF_EXIT ~ AGE_65 + EDUC_LessBAc + HHINC_50 + ADULT + btype_S + btype_E + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt
  OSUPCOMF_SIDE ~ STUD_Yes + WORK_No + BIKES + ADULT + MODEUSE2_BIKE_NeverFewWeek + btype_S + btype_E + ROUNDMODE_YesLess
  OSUPCOMF_CROS ~ EDUC_LessBAc + MODEUSE2_BIKE_NeverFewWeek + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesMore
  # OSUPCOMFALL ~~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_ENTR ~~ OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_CIRC ~~ OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_EXIT ~~ OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_SIDE ~~ OSUPCOMF_CROS
"
mod4.3 <- lavaan(form4.3, data=dat, ordered=T)
summary(mod4.3)
summary(mod4.3, standardized=T, fit.measures=T, rsquare=T)

# 4.4.all add personal characteristics (all)
# AGE_25 + AGE_25_34 + AGE_35_44 + AGE_45_54 + AGE_65 + AGE_Missing
# GEND_Female + GEND_Missing
# RaceOther
# EDUC_LessBAc + EDUC_Bach + EDUC_Missing
# STUD_Yes + STUD_Missing
# WORK_No + WORK_Missing
# HHINC_50 + HHINC_50_75 + HHINC_75_100 + HHINC_150 + HHINC_Missing
# BIKES + BIKES_Miss
# CARS + CARS_Miss
# ADULT + ADULT_Miss
# CHILD + CHILD_Miss
# MODEUSE2_BIKE_Never + MODEUSE2_BIKE_Few + MODEUSE2_BIKE_Week
# btype_S + btype_E + btype_M
# Crash
# MODEROUND_BIKE_Never + MODEROUND_BIKE_Often + MODEROUND_BIKE_Always + MODEROUND_BIKE_Missing
# MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + MODEROUTE_BIKE_Yes_Prefer + MODEROUTE_BIKE_Missing
# ROUNDMODE_YesLess + ROUNDMODE_YesMore + ROUNDMODE_Missing
# first: AGE_65 + EDUC_LessBAc + HHINC_50 + MODEUSE2_BIKE_NeverFewWeek + btype_S + MODEROUTE_BIKE_Yes_AvoidAvoidAlt + ROUNDMODE_YesLess
# final: EDUC_LessBAc + MODEROUTE_BIKE_Yes_AvoidAvoidAlt + ROUNDMODE_YesLess
form4.4.all <- "
  OSUPCOMFALL ~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMFALL ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_ENTR ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_CIRC ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_EXIT ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_SIDE ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_CROS ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMFALL ~ EDUC_LessBAc + MODEROUTE_BIKE_Yes_AvoidAvoidAlt + ROUNDMODE_YesLess
  OSUPCOMF_ENTR ~ GEND_Female + GEND_Missing + btype_S + btype_E + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt
  OSUPCOMF_CIRC ~ HHINC_50 + btype_S + btype_E + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt
  OSUPCOMF_EXIT ~ AGE_65 + EDUC_LessBAc + HHINC_50 + ADULT + btype_S + btype_E + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt
  OSUPCOMF_SIDE ~ STUD_Yes + WORK_No + BIKES + ADULT + MODEUSE2_BIKE_NeverFewWeek + btype_S + btype_E + ROUNDMODE_YesLess
  OSUPCOMF_CROS ~ EDUC_LessBAc + MODEUSE2_BIKE_NeverFewWeek + Crash + MODEROUTE_BIKE_Yes_Avoid + MODEROUTE_BIKE_Yes_AvoidAlt + ROUNDMODE_YesMore
  # OSUPCOMFALL ~~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_ENTR ~~ OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_CIRC ~~ OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_EXIT ~~ OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_SIDE ~~ OSUPCOMF_CROS
"
mod4.4.all <- lavaan(form4.4.all, data=dat, ordered=T)
summary(mod4.4.all)
summary(mod4.4.all, standardized=T, fit.measures=T, rsquare=T)

# 4.4 add personal characteristics (all)
# first: (all from above)
# final: (only those with p<0.10)
form4.4 <- "
  OSUPCOMFALL ~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMFALL ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_ENTR ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_CIRC ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_EXIT ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_SIDE ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMF_CROS ~ Island_small + Lane_1 + Facility_Shared + Facility_Ramps + Facility_Seperated + Volume_Medium + Volume_High + Speed_35
  OSUPCOMFALL ~ EDUC_LessBAc + MODEROUTE_BIKE_Yes_AvoidAvoidAlt + ROUNDMODE_YesLess
  OSUPCOMF_ENTR ~ GEND_Female + GEND_Missing + btype_S + btype_E + MODEROUTE_BIKE_Yes_AvoidAvoidAlt
  OSUPCOMF_CIRC ~ HHINC_50 + btype_S + btype_E + MODEROUTE_BIKE_Yes_AvoidAvoidAlt
  OSUPCOMF_EXIT ~ AGE_65 + EDUC_LessBAc + HHINC_50 + ADULT + btype_S + btype_E + MODEROUTE_BIKE_Yes_AvoidAvoidAlt
  OSUPCOMF_SIDE ~ STUD_Yes + WORK_No + BIKES + ADULT + MODEUSE2_BIKE_NeverFewWeek + btype_S + btype_E + ROUNDMODE_YesLess
  OSUPCOMF_CROS ~ EDUC_LessBAc + MODEUSE2_BIKE_NeverFewWeek + Crash + MODEROUTE_BIKE_Yes_AvoidAvoidAlt + ROUNDMODE_YesMore
  # OSUPCOMFALL ~~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_ENTR ~~ OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_CIRC ~~ OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_EXIT ~~ OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_SIDE ~~ OSUPCOMF_CROS
"
mod4.4 <- lavaan(form4.4, data=dat, ordered=T)
summary(mod4.4)
summary(mod4.4, standardized=T, fit.measures=T, rsquare=T)

# 4.5 add mediation calculations (total effects)
form4.5 <- "
  OSUPCOMFALL   ~ x1*OSUPCOMF_ENTR + x2*OSUPCOMF_CIRC + x3*OSUPCOMF_EXIT + x4*OSUPCOMF_SIDE + x5*OSUPCOMF_CROS
  OSUPCOMFALL   ~ a0*Island_small + b0*Lane_1 + c0*Facility_Shared + d0*Facility_Ramps + e0*Facility_Seperated + f0*Volume_Medium + g0*Volume_High + h0*Speed_35
  OSUPCOMF_ENTR ~ a1*Island_small + b1*Lane_1 + c1*Facility_Shared + d1*Facility_Ramps + e1*Facility_Seperated + f1*Volume_Medium + g1*Volume_High + h1*Speed_35
  OSUPCOMF_CIRC ~ a2*Island_small + b2*Lane_1 + c2*Facility_Shared + d2*Facility_Ramps + e2*Facility_Seperated + f2*Volume_Medium + g2*Volume_High + h2*Speed_35
  OSUPCOMF_EXIT ~ a3*Island_small + b3*Lane_1 + c3*Facility_Shared + d3*Facility_Ramps + e3*Facility_Seperated + f3*Volume_Medium + g3*Volume_High + h3*Speed_35
  OSUPCOMF_SIDE ~ a4*Island_small + b4*Lane_1 + c4*Facility_Shared + d4*Facility_Ramps + e4*Facility_Seperated + f4*Volume_Medium + g4*Volume_High + h4*Speed_35
  OSUPCOMF_CROS ~ a5*Island_small + b5*Lane_1 + c5*Facility_Shared + d5*Facility_Ramps + e5*Facility_Seperated + f5*Volume_Medium + g5*Volume_High + h5*Speed_35
  OSUPCOMFALL   ~ EDUC_LessBAc + MODEROUTE_BIKE_Yes_AvoidAvoidAlt + ROUNDMODE_YesLess
  OSUPCOMF_ENTR ~ GEND_Female + GEND_Missing + btype_S + btype_E + MODEROUTE_BIKE_Yes_AvoidAvoidAlt
  OSUPCOMF_CIRC ~ HHINC_50 + btype_S + btype_E + MODEROUTE_BIKE_Yes_AvoidAvoidAlt
  OSUPCOMF_EXIT ~ AGE_65 + EDUC_LessBAc + HHINC_50 + ADULT + btype_S + btype_E + MODEROUTE_BIKE_Yes_AvoidAvoidAlt
  OSUPCOMF_SIDE ~ STUD_Yes + WORK_No + BIKES + ADULT + MODEUSE2_BIKE_NeverFewWeek + btype_S + btype_E + ROUNDMODE_YesLess
  OSUPCOMF_CROS ~ EDUC_LessBAc + MODEUSE2_BIKE_NeverFewWeek + Crash + MODEROUTE_BIKE_Yes_AvoidAvoidAlt + ROUNDMODE_YesMore
  # OSUPCOMFALL ~~ OSUPCOMF_ENTR + OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_ENTR ~~ OSUPCOMF_CIRC + OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_CIRC ~~ OSUPCOMF_EXIT + OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_EXIT ~~ OSUPCOMF_SIDE + OSUPCOMF_CROS
  OSUPCOMF_SIDE ~~ OSUPCOMF_CROS
  i_Island_small        := x1*a1 + x2*a2 + x3*a3 + x4*a4 + x5*a5
  i_Lane_1              := x1*b1 + x2*b2 + x3*b3 + x4*b4 + x5*b5
  i_Facility_Shared     := x1*c1 + x2*c2 + x3*c3 + x4*c4 + x5*c5
  i_Facility_Ramps      := x1*d1 + x2*d2 + x3*d3 + x4*d4 + x5*d5
  i_Facility_Seperated  := x1*e1 + x2*e2 + x3*e3 + x4*e4 + x5*e5
  i_Volume_Medium       := x1*f1 + x2*f2 + x3*f3 + x4*f4 + x5*f5
  i_Volume_High         := x1*g1 + x2*g2 + x3*g3 + x4*g4 + x5*g5
  i_Speed_35            := x1*h1 + x2*h2 + x3*h3 + x4*h4 + x5*h5
  t_Island_small        := a0 + i_Island_small
  t_Lane_1              := b0 + i_Lane_1
  t_Facility_Shared     := c0 + i_Facility_Shared
  t_Facility_Ramps      := d0 + i_Facility_Ramps
  t_Facility_Seperated  := e0 + i_Facility_Seperated
  t_Volume_Medium       := f0 + i_Volume_Medium
  t_Volume_High         := g0 + i_Volume_High
  t_Speed_35            := h0 + i_Speed_35
"
mod4.5 <- lavaan(form4.5, data=dat, ordered=T)
summary(mod4.5)
summary(mod4.5, standardized=T, fit.measures=T, rsquare=T)

########################################
# Save results

# Create list
mods <- list(dat, mod1.0, mod1.1, mod1.2, mod2.0, mod2.1, mod2.2, mod2.3, 
             mod3.0.entr, mod3.0.circ, mod3.0.exit, mod3.0.side, mod3.0.cros, 
             mod3.1.entr, mod3.1.circ, mod3.1.exit, mod3.1.side, mod3.1.cros, 
             mod3.2.entr, mod3.2.circ, mod3.2.exit, mod3.2.side, mod3.2.cros, 
             mod4.0, mod4.1, mod4.2, mod4.3, mod4.4, 
             form4.0, form4.1, form4.2, form4.3, form4.4)
names(mods) <- c("dat", "mod1.0", "mod1.1", "mod1.2", "mod2.0", "mod2.1", "mod2.2", "mod2.3", 
                 "mod3.0.entr", "mod3.0.circ", "mod3.0.exit", "mod3.0.side", "mod3.0.cros", 
                 "mod3.1.entr", "mod3.1.circ", "mod3.1.exit", "mod3.1.side", "mod3.1.cros", 
                 "mod3.2.entr", "mod3.2.circ", "mod3.2.exit", "mod3.2.side", "mod3.2.cros", 
                 "mod4.0", "mod4.1", "mod4.2", "mod4.3", "mod4.4", 
                 "form4.0", "form4.1", "form4.2", "form4.3", "form4.4")

# Save list
saveRDS(mods, file=file.path("Analysis", "Comfort analysis", "mods.rds"))
# mods <- readRDS(file=file.path("Analysis", "Comfort analysis", "Comfort analysis, "mods.rds"))

########################################
# Clean up

# Remove
rm(mod1.0, mod1.1, mod1.2)
rm(mod2.0, mod2.1, mod2.2, mod2.3)
rm(mod3.0.entr, mod3.0.circ, mod3.0.exit, mod3.0.side, mod3.0.cros, 
   mod3.1.entr, mod3.1.circ, mod3.1.exit, mod3.1.side, mod3.1.cros, 
   mod3.2.entr, mod3.2.circ, mod3.2.exit, mod3.2.side, mod3.2.cros)
rm(mod4.0, mod4.1, mod4.1a, mod4.2, mod4.3, mod4.4, 
   form4.0, form4.1, form4.1a, form4.2, form4.3, form4.4)
rm(mod4.3.entr, mod4.3.circ, mod4.3.exit, mod4.3.side, mod4.3.cros, mod4.4.all, 
   form4.3.entr, form4.3.circ, form4.3.exit, form4.3.side, form4.3.cros, form4.4.all)
rm(Complete, dat, mods)
gc()

########################################
# END
########################################