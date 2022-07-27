########################################
# Project:  MPC-603 Bicycle safety roundabouts
# Authors:  Patrick Singleton (patrick.singleton@usu.edu)
#           Niranjan Poudel (niranjan.poudel@usu.edu)
# File:     create_comfort.R
# Date:     2020 Fall, 2021 Spring, Summer, 2022 Summer
# About:    Script to create data for comfort analysis
########################################

# Major edits
# 2020-XX-XX created by NP
# 2021-05-19 updated by NP
# 2021-05-20 updated by PAS, reformat script
# 2022-07-16 updated by PAS, minor edits

########################################
# Notes

# Open R project first, then open this R script

# Install, load packages
# library("")
library(tidyr)
library(dplyr)

########################################
# Load data

# Load survey data
dat <- readRDS(file.path("Data", "Survey", "dat3.rds"))

# Backup
tdat <- dat

########################################
# Create data about scenarios

# Get the names of 21 columns for scenarios
mycol <- colnames(dat)
mycol <- grep("S_DO_S\\d+", mycol, value = TRUE); mycol

# Creating a new dataframe for the 21 scenarios with 5 attributes + scenario #
myatt <- data.frame(matrix(ncol=6, nrow=21))
colnames(myatt) <- c("Scenario","Island","Lane","Facility","Volume","Speed")

# Individually adding the attributes for alternatives
# scenario number
myatt$Scenario <- sort(mycol)
# central island diameter
myatt$Island <- c("large","large","large","large","large","large","large","large",
                  "large","large","small","small","small","small","small","small",
                  "small","small","small","small","small")
# circulating travel lanes
myatt$Lane <- c(2,2,2,2,2,1,1,1,1,1,2,2,2,2,2,2,1,1,1,1,1)
# bicycle facility type
myatt$Facility <- c("ramps","ramps","No","separated","shared","ramps","No","separated",
                    "shared","shared","ramps","No","separated","separated","shared",
                    "shared","ramps","No","No","separated","shared")
# traffic volume
myatt$Volume <- c("low","medium","medium","high","high","high","low","low","low","medium",
                  "low","high","low","medium","low","medium","high","low","medium",
                  "high","high")
# approach speed limit
myatt$Speed <- c(35,25,25,35,25,25,25,35,35,35,35,35,25,25,25,35,25,25,35,35,25)

# Inspect
myatt
# looks good

########################################
# Process data for comfort

# Copy to new dataframe
tempnew <- dat

# Add scenario columns based on which one is true in our data
tempnew$Scenario <- apply(tempnew[mycol], 1, function(x) names(which(x==T)))
# above line created a list inside a column so unlisting first of all
tempnew$Scenario[lengths(tempnew$Scenario) == 0] <- NA_character_
tempnew$Scenario <- unlist(tempnew$Scenario)
table(tempnew$Scenario)

# Merging the two data, NA will be removed automatically.
Complete <- inner_join(tempnew, myatt, by="Scenario")

# Cleanup
# rm(list=(ls()[ls()!="Complete"]))

########################################
# Filter and process comfort dataset

# Select required columns for comfort analysis
Complete %>%
  select(ResponseId, Scenario, Island : Speed, SUPCOMFALL : DRBIKEPOS, 
         MODEUSE2_BIKE, MODEROUND_BIKE, MODEROUTE_BIKE, ROUNDMODE, CRASH_HIT, CRASH_NHIT,
         # HHINC, AGE, GEND, RACE_WHIT, EDUC, 
         HHINC, AGE, GEND, RACE_WHIT:RACE_NA, EDUC, 
         STUD, WORK, btype, BIKES, CARS, ADULT, CHILD) -> ComData

# Process race/ethnicity data to create white-only vs. other
ComData %>%
  mutate(RaceSum = RACE_WHIT + RACE_HISP + RACE_ASIA + RACE_BLAC + RACE_AIAN + RACE_NHPI + RACE_SD + RACE_NA) -> ComData
ComData %>%
  mutate(RaceW = ifelse((RACE_WHIT == TRUE & RaceSum == 1), 1, 0)) %>%
  select(-c(RACE_WHIT:RACE_NA, RaceSum))-> ComData
# create race other variable
ComData$RaceOther <- 1 - ComData$RaceW

# Converting some ordered factor columns to characters
ComData %>%
  mutate(BIKES = as.character(BIKES),
         CARS = as.character(CARS),
         ADULT = as.character(ADULT),
         CHILD = as.character(CHILD)) -> ComData

# Change values in some columns
# inspect
table(ComData$BIKES); table(is.na(ComData$BIKES))
table(ComData$CARS); table(is.na(ComData$CARS))
table(ComData$ADULT); table(is.na(ComData$ADULT))
table(ComData$CHILD); table(is.na(ComData$CHILD))
# columns with 5+ we will change to 5
# ComData[ComData == "5+"] <- 5
ComData$BIKES[ComData$BIKES=="5+"] <- 5
ComData$CARS[ComData$CARS=="5+"] <- 5
ComData$ADULT[ComData$ADULT=="5+"] <- 5
ComData$CHILD[ComData$CHILD=="5+"] <- 5
# create dummy missing
ComData$BIKES_Miss <- ifelse(is.na(ComData$BIKES), 1, 0)
ComData$CARS_Miss <- ifelse(is.na(ComData$CARS), 1, 0)
ComData$ADULT_Miss <- ifelse(is.na(ComData$ADULT), 1, 0)
ComData$CHILD_Miss <- ifelse(is.na(ComData$CHILD), 1, 0)
# columns with NA we will change to 0
ComData$BIKES[is.na(ComData$BIKES)] <- 0
ComData$CARS[is.na(ComData$CARS)] <- 0
ComData$ADULT[is.na(ComData$ADULT)] <- 0
ComData$CHILD[is.na(ComData$CHILD)] <- 0
# create as integer
ComData$BIKES <- as.integer(ComData$BIKES)
ComData$CARS <- as.integer(ComData$CARS)
ComData$ADULT <- as.integer(ComData$ADULT)
ComData$CHILD <- as.integer(ComData$CHILD)
# add 1 to ADULT (b/c measured other adults)
ComData$ADULT <- ComData$ADULT + 1
# --> in the model, use just ADULT_miss (b/c other _miss are likely colinear)

# Remove observations for No-way-no-how cyclists
ComData <- ComData[is.na(ComData$btype) | ComData$btype!="No way, no how",]

# Remove observations with NAs for our outcome variables
temp1 <- ComData %>% select(ResponseId, SUPCOMFALL : DRBIKEPOS)
temp1$nas <- rowSums(is.na(temp1))
table(temp1$nas); sum(temp1$nas>0)
temp2 <- temp1$ResponseId[temp1$nas>0]
ComData <- ComData[!(ComData$ResponseId %in% temp2),]
rm(temp1, temp2)

# lets do the dummy coding for all our variables
ComData %>%
  mutate(Island_small = ifelse(Island == "small", 1, 0)) %>%
  mutate(Island_large = ifelse(Island == "large", 1, 0)) %>%
  mutate(Lane_1 = ifelse(Lane == 1, 1, 0)) %>%
  mutate(Lane_2 = ifelse(Lane == 2, 1, 0)) %>%
  mutate(Facility_No = ifelse(Facility == "No", 1, 0)) %>%
  mutate(Facility_Shared = ifelse(Facility == "shared", 1, 0)) %>%
  mutate(Facility_Ramps = ifelse(Facility == "ramps", 1, 0)) %>%
  mutate(Facility_Seperated = ifelse(Facility == "separated", 1, 0)) %>%
  mutate(Volume_Low = ifelse(Volume == "low", 1, 0)) %>%
  mutate(Volume_Medium = ifelse(Volume == "medium", 1, 0)) %>%
  mutate(Volume_High = ifelse(Volume == "high", 1, 0)) %>%
  mutate(Speed_25 = ifelse(Speed == 25, 1, 0)) %>%
  mutate(Speed_35 = ifelse(Speed == 35, 1, 0)) -> ComData

# Comfort variables
myfac <- names(ComData)[grepl("COMF", names(ComData))]; myfac
for (i in myfac) {
  ComData[,i] <- as.numeric(ComData[,i])
}; rm(i)
rm(myfac)

# Lets work with categorical variables and missing values
# Convert some factors to characters
myfac <- c("MODEUSE2_BIKE", "MODEROUND_BIKE", "MODEROUTE_BIKE", "ROUNDMODE", 
           "HHINC", "AGE", "GEND", "EDUC", "STUD", "WORK", "btype")
ComData[,myfac] <- lapply(ComData[,myfac], as.character)
# note NAs
ComData[,myfac][ComData[,myfac] == "NA"] <- "PNA"
ComData[,myfac][is.na(ComData[,myfac])] <- "Missing"
summary(ComData)
# Convert back to factors
ComData[,myfac] <- lapply(ComData[,myfac], factor)
summary(ComData)
# Change levels of factors
table(ComData$MODEUSE2_BIKE)
levels(ComData$MODEUSE2_BIKE) <- c("Few","Week","Freq","Freq","Few","Never")
# mutate(MODEUSE2_BIKE = factor(MODEUSE2_BIKE, labels = c("LessOnceWeek", "LessOnceWeek", "LessOnceWeek", "OneThreeWeek", "FourEveryDay", "FourEveryDay")))
table(ComData$MODEROUND_BIKE)
levels(ComData$MODEROUND_BIKE) <- c("Always","Missing","Never","Often","Sometimes")
table(ComData$MODEROUTE_BIKE)
levels(ComData$MODEROUTE_BIKE) <- c("Missing","No","Yes_Avoid","Yes_AvoidAlt","Yes_Prefer")
table(ComData$ROUNDMODE)
# levels(ComData$ROUNDMODE) <- c("Missing","No","YesMuchLess","YesMuchMore","YesSomeLess","YesSomeMore")
levels(ComData$ROUNDMODE) <- c("Missing","No","YesLess","YesMore","YesLess","YesMore")
table(ComData$HHINC)
levels(ComData$HHINC) <- c("50","50","50","50","50","50_75","75_100","100_150","150","Missing","Missing","Missing")
# mutate(HHINC = factor(HHINC, labels = c("Less50", "Less50", "Less50", "Less50", "Less50", "50to75", "75to100", "100to150", "150plus", "other", "other"))) %>%
table(ComData$AGE)
levels(ComData$AGE) <- c("25","25","25_34","35_44","45_54","55_64","65","65","Missing","Missing")
# mutate(AGE = factor(AGE, labels = c("Less25Other", "Less25Other", "25to34","35to44", "45to54",  "55to64", "65plus", "65plus", "Less25Other"))) %>%
table(ComData$GEND)
levels(ComData$GEND) <- c("Female","Male","Missing","Missing","Missing")
# mutate(GEND = factor(GEND, labels = c("FemaleOther", "Male", "FemaleOther", "FemaleOther"))) %>%
table(ComData$EDUC)
levels(ComData$EDUC) <- c("Bach","LessBAc","LessBAc","MastUp","Missing","Missing")
# mutate(EDUC = factor(EDUC, labels = c( "LessBachOther", "Bac", "MasterUp", "LessBachOther"))) %>%
table(ComData$STUD)
levels(ComData$STUD) <- c("Missing","No","Yes")
table(ComData$WORK)
levels(ComData$WORK) <- c("Missing","No","Yes")
# -> in the models, change variables to match these new levels

# Changing logical columns to number 
ComData$RaceW <- as.numeric(ComData$RaceW)
ComData$CRASH_HIT <- as.numeric(ComData$CRASH_HIT)
ComData$CRASH_NHIT <- as.numeric(ComData$CRASH_NHIT)
ComData$Crash <- ComData$CRASH_HIT + ComData$CRASH_NHIT
summary(ComData$Crash)
ComData$Crash[ComData$Crash > 1] <- 1

# Create dummy variables
library(fastDummies)
Comfort <- dummy_cols(ComData, select_columns=myfac, remove_most_frequent_dummy=F, remove_selected_columns=T)
mycols <- colnames(Comfort)
mycols %>% gsub("(?<=btype_[[:alpha:]]).*","",., perl = T) -> mycols
colnames(Comfort) <- mycols

# Inspect
summary(Comfort)

########################################
# Save files

# Save Comfort
saveRDS(Comfort, file=file.path("Analysis", "Comfort analysis", "Comfort.rds"))
write.csv(Comfort, file=file.path("Analysis", "Comfort analysis", "Comfort.csv"), row.names=F)

########################################
# Clean up

# Remove
rm(myfac, mycols, mycol)
rm(dat, myatt, tdat, tempnew)
rm(Complete, ComData, Comfort)
gc()

########################################
# END
########################################