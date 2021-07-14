########################################
# Project:  MPC-603 Bicycle safety roundabouts
# Authors:  Patrick Singleton (patrick.singleton@usu.edu)
#           Niranjan Poudel (niranjan.poudel@usu.edu)
# File:     create_stated.R
# Date:     2020 Fall, 2021 Spring, Summer
# About:    Script to create data for stated choice analysis
########################################

# Major edits
# 2020-XX-XX created by NP
# 2021-05-10 updated by NP
# 2021-05-13 updated by PAS, reformat script
# 2021-05-13 updated by NP to fix SCE errors
# 2021-05-19 updated by PAS to remove No-way-no-how

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

# Creating a new dataframe for the alternatives later on to merge
stated <- read.csv(text = "QN,Island_A,Lane_A,Facility_A,Volume_A,Speed_A,Island_B,Lane_B,Facility_B,Volume_B,Speed_B")

# 18 choice questions in total
stated[1:18,] <- 0

# Individually adding the attributes for alternatives 
# question number
stated$QN <- c(1,2,3,4,7,8,9,10,11,12,13,14,16,17,18,19,20,22)
# central island diameter
stated$Island_A <- c("Small","Small","Small","Small","Small","Small",
                     "Small","Small","Small","Small","Large","Large",
                     "Large","Large","Large","Large","Large","Large")
stated$Island_B <- c("Small","Small","Small","Large","Large","Small",
                     "Small","Large","Large","Large","Large","Large",
                     "Small","Small","Small","Small","Large","Large")
# circulating travel lanes
stated$Lane_A <- c(1,1,1,1,2,2,2,2,2,2,1,1,1,1,1,2,2,2)
stated$Lane_B <- c(1,2,2,1,2,1,1,1,2,2,2,2,1,2,2,2,1,1)
# bicycle facility type
stated$Facility_A <- c("No","Ramps","Shared","Seperated","Shared","Seperated",
                       "Seperated","Shared","Ramps","No","Ramps","No","Shared",
                       "Shared","Seperated","Ramps","No","Seperated")
stated$Facility_B <- c("Seperated","Seperated","Seperated","Shared","Ramps","Ramps",
                       "No","Ramps","Shared","Seperated","No","Ramps",
                       "Shared","No","Shared","Ramps","Shared","No")
# traffic volume
stated$Volume_A <- c("Low","High","High","High","Low","Medium",
                     "Low","Medium","Low","High","High","Low",
                     "Low","Medium","Low","Medium","Medium","High")
stated$Volume_B <- c("High","Low","Medium","Medium","Medium","High",
                     "Medium","High","High","High","Medium","Low",
                     "High","High","Low","Low","Low","Low")
# approach speed limit
stated$Speed_A <- c(25,25,25,35,25,25,25,35,35,35,25,25,35,35,35,25,25,35)
stated$Speed_B <- c(35,25,25,35,25,25,35,25,25,35,25,35,25,35,25,35,35,25)

# Inspect
stated

# Replicating the newly created dataframe by (number of individual * 18) 
# We will eventually reduce to 6 (one block per person)
stated_long <- do.call("rbind", replicate(nrow(dat), stated, simplify = FALSE))

########################################
# Process data for stated choice

# Copy to new dataframe
new_temp <- dat

# Remove extraneous columns
# Retrieve all the column names
mycols <- colnames(new_temp)
# Getting the E01_DO_1 type of column names 
a <- grep("E[[:digit:]][[:digit:]]_DO_[[:digit:]]", mycols, value = TRUE)
# Removing those columns because they are not needed.
new_temp <- new_temp[,!names(new_temp) %in% a]
rm(mycols, a)

# We need to make long format for each individual 
# 18 per individual for now, which we will reduce to 6 eventually
new_temp <- pivot_longer(new_temp, cols = E02:E22)
# Newly formed columns "name" gives us the choice question faced and "value" gives the choice.
# Changing column name
new_temp <- new_temp %>% rename_at(vars(c("name","value")), ~c("Exp","Choice"))

# Next lets bind the two dataframe together
# First we need a basis for binding, so we need a new column of question number in survey dataframe
new_temp$QN <- substr(new_temp$Exp,2,3) # we are creating the column of question number from E01, E02 removing E
new_temp$QN <- as.integer(new_temp$QN) # Now the QN matches with stated dataframe QN 
# Copying the column response id (from survey data) to stated (newly created dataframe)
# each response id has 18 rows and we have 18 different stated questions ( we will reduce to 6 eventually)
stated_long$ResponseId <- new_temp$ResponseId
# Now we have the basis for combination first by response id and second by QN
new_data <- merge(new_temp, stated_long, by=c("ResponseId","QN"))
# Check if EXp colum and QN colum are same or not (similar)
mycheck <- new_data %>% select("Exp","QN","ResponseId","Choice") # Just a check 
rm(mycheck) # looks okay

########################################
# Filter long stated choice dataset

# Next we have 18 rows per individual we need to reduce it to 6 per individual removing the ones with NA in choice column
# First removing the Na in choice data
Na_remove <- new_data[!is.na(new_data$Choice),]

# Still there are some responses not equal to 6 ( incomplete stated choice)
Incomplete <-  Na_remove %>% count(ResponseId)
table(Incomplete$n)
# Finding responses less than 6 or incomplete responses if needed for future use
Incomplete <- subset(Incomplete, Incomplete$n < 6)
# Separating only the response id for incomplete responses 
Incomplete <- Incomplete$ResponseId
length(Incomplete) # 25

# Removing the data for incomplete response id.
Complete <- Na_remove[!Na_remove$ResponseId %in% Incomplete,]

# Add ID and avaialbility
Complete %>% 
  mutate(ID = as.numeric(as.factor(Complete$ResponseId))) %>%
  arrange(ID, Exp) %>%
  mutate(av = 1 )-> Complete

# Remove observations for No-way-no-how cyclists
Complete <- Complete[is.na(Complete$btype) | Complete$btype!="No way, no how",]

# lets do the dummy coding for all our variables
Complete %>%
  mutate(Island_small_A = ifelse(Island_A == "Small", 1, 0)) %>%
  mutate(Island_large_A = ifelse(Island_A == "Large", 1, 0)) %>%
  mutate(Lane_1_A = ifelse(Lane_A == 1, 1, 0)) %>%
  mutate(Lane_2_A = ifelse(Lane_A == 2, 1, 0)) %>%
  mutate(Facility_No_A = ifelse(Facility_A == "No", 1, 0)) %>%
  mutate(Facility_Shared_A = ifelse(Facility_A == "Shared", 1, 0)) %>%
  mutate(Facility_Ramps_A = ifelse(Facility_A == "Ramps", 1, 0)) %>%
  mutate(Facility_Seperated_A = ifelse(Facility_A == "Seperated", 1, 0)) %>%
  mutate(Volume_Low_A = ifelse(Volume_A == "Low", 1, 0)) %>%
  mutate(Volume_Medium_A = ifelse(Volume_A == "Medium", 1, 0)) %>%
  mutate(Volume_High_A = ifelse(Volume_A == "High", 1, 0)) %>%
  mutate(Speed_25_A = ifelse(Speed_A == 25, 1, 0)) %>%
  mutate(Speed_35_A = ifelse(Speed_A == 35, 1, 0)) %>%
  mutate(Island_small_B = ifelse(Island_B == "Small", 1, 0)) %>%
  mutate(Island_large_B = ifelse(Island_B == "Large", 1, 0)) %>%
  mutate(Lane_1_B = ifelse(Lane_B == 1, 1, 0)) %>%
  mutate(Lane_2_B = ifelse(Lane_B == 2, 1, 0)) %>%
  mutate(Facility_No_B = ifelse(Facility_B == "No", 1, 0)) %>%
  mutate(Facility_Shared_B = ifelse(Facility_B == "Shared", 1, 0)) %>%
  mutate(Facility_Ramps_B = ifelse(Facility_B == "Ramps", 1, 0)) %>%
  mutate(Facility_Seperated_B = ifelse(Facility_B == "Seperated", 1, 0)) %>%
  mutate(Volume_Low_B = ifelse(Volume_B == "Low", 1, 0)) %>%
  mutate(Volume_Medium_B = ifelse(Volume_B == "Medium", 1, 0)) %>%
  mutate(Volume_High_B = ifelse(Volume_B == "High", 1, 0)) %>%
  mutate(Speed_25_B = ifelse(Speed_B == 25, 1, 0)) %>%
  mutate(Speed_35_B = ifelse(Speed_B == 35, 1, 0)) -> Complete

# Select the required columns for unweighted analysis
Complete %>%
  select(ResponseId, ID, av, Choice,
         Island_small_A, Island_large_A, Lane_1_A, Lane_2_A, 
         Facility_No_A, Facility_Shared_A, Facility_Ramps_A, Facility_Seperated_A,
         Volume_Low_A, Volume_Medium_A, Volume_High_A, Speed_25_A, Speed_35_A,
         Island_small_B, Island_large_B, Lane_1_B, Lane_2_B, 
         Facility_No_B, Facility_Ramps_B, Facility_Shared_B, Facility_Seperated_B, 
         Volume_Low_B, Volume_Medium_B, Volume_High_B, Speed_25_B, Speed_35_B) -> Stated

########################################
# Save files

# Save Complete
saveRDS(Complete, file=file.path("Analysis", "Stated preference", "dat_stated.rds"))
write.csv(Complete, file=file.path("Analysis", "Stated preference", "dat_stated.csv"), row.names=F)

# Save Stated
saveRDS(Stated, file=file.path("Analysis", "Stated preference", "Stated.rds"))
write.csv(Stated, file=file.path("Analysis", "Stated preference", "Stated.csv"), row.names=F)

########################################
# Clean up

# Remove
rm(stated, stated_long, new_temp, new_data)
rm(Na_remove, Incomplete, Complete, Stated)
rm(dat, tdat)
gc()

########################################
# END
########################################