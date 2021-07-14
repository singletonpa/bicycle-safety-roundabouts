########################################
# Project:  MPC-603 Bicycle safety roundabouts
# Authors:  Patrick Singleton (patrick.singleton@usu.edu)
# File:     clean_data.R
# Date:     2020 Fall, 2021 Spring, Summer
# About:    Script to clean survey data
########################################

# Major edits
# 2020-09-29 created
# 2020-12-04 updated with anonymous
# 2021-05-11 updated with additional variables
# 2021-07-14 updated to make dat3 anonymous

########################################
# Notes

# Open R project first, then open this R script

# Install, load packages
# library("")

########################################
# Load data from Qualtrics CSV

# Get names
tempN <- read.csv(file=file.path("Data", "Survey", "Data-Raw.csv"), 
                  stringsAsFactors=F, header=T, nrows=2)
temp_names <- data.frame(NAME1=as.character(names(tempN)), stringsAsFactors=F)
temp_names$NAME2 <- as.character(tempN[1,])
temp_names$NAME3 <- as.character(tempN[2,])
rm(tempN)

# Get data
temp <- read.csv(file=file.path("Data", "Survey", "Data-Raw.csv"), 
                 stringsAsFactors=F)
temp <- temp[-c(1:2),]

# Backup data
old_temp <- temp
# temp <- old_temp

########################################
# Format columns and data types

# Survey metadata
temp$StartDate <- as.POSIXct(temp$StartDate, tz="America/Denver")
temp$EndDate <- as.POSIXct(temp$EndDate, tz="America/Denver")
temp$Status <- as.integer(temp$Status)
# temp$IPAddress
temp$Progress <- as.integer(temp$Progress)
names(temp)[which(names(temp)=="Duration..in.seconds.")] <- "Duration"
temp_names$NAME1[which(temp_names$NAME1=="Duration..in.seconds.")] <- "Duration"
temp$Duration <- as.integer(temp$Duration)
temp$Finished <- as.integer(temp$Finished)
temp$RecordedDate <- as.POSIXct(temp$RecordedDate, tz="America/Denver")
# temp$ResponseId
temp$RecipientLastName <- ifelse(temp$RecipientLastName=="", NA, temp$RecipientLastName)
temp$RecipientFirstName <- ifelse(temp$RecipientFirstName=="", NA, temp$RecipientFirstName)
temp$RecipientEmail <- ifelse(temp$RecipientEmail=="", NA, temp$RecipientEmail)
temp$ExternalReference <- ifelse(temp$ExternalReference=="", NA, temp$ExternalReference)
temp$LocationLatitude <- as.numeric(temp$LocationLatitude)
temp$LocationLongitude <- as.numeric(temp$LocationLongitude)
# temp$DistributionChannel
# temp$UserLanguage

# Start & Bike filter
tc <- c("LOIYES", "RESID", "AGE18", "CANBIKE")
for (i in tc) { temp[,i] <- as.integer(temp[,i]) }; rm(i)
rm(tc)
temp$LOIYES <- factor(temp$LOIYES, levels=c(1,2), labels=c("Accept", "Decline"))
temp$RESID <- factor(temp$RESID, levels=c(1,2), labels=c("Yes", "No"))
temp$AGE18 <- factor(temp$AGE18, levels=c(1,2), labels=c("Yes", "No"))
temp$CANBIKE <- factor(temp$CANBIKE, levels=c(1:3), labels=c("Able_K", "Able_DK", "Unable"))

# Roundabout introduction
tc <- c(grep("ROUND_", names(temp), value=T)[1:5], grep("ROUND_DO_", names(temp), value=T), 
        grep("MODEUSE1_", names(temp), value=T), grep("MODEUSE2_", names(temp), value=T), 
        grep("MODEROUND_", names(temp), value=T), grep("MODEROUTE_", names(temp), value=T), "ROUNDMODE")
for (i in tc) { temp[,i] <- as.integer(temp[,i]) }; rm(i)
rm(tc)
for (i in grep("ROUND_", names(temp), value=T)[1:5]) {
  temp[,i] <- ifelse(is.na(temp[,i]), F, ifelse(temp[,i]==1, T, NA))
}; rm(i)
names(temp)[which(names(temp)=="ROUND_2")] <- "ROUND_TCIRC"
temp_names$NAME1[which(temp_names$NAME1=="ROUND_2")] <- "ROUND_TCIRC"
names(temp)[which(names(temp)=="ROUND_1")] <- "ROUND_ROUND"
temp_names$NAME1[which(temp_names$NAME1=="ROUND_1")] <- "ROUND_ROUND"
names(temp)[which(names(temp)=="ROUND_3")] <- "ROUND_MINIR"
temp_names$NAME1[which(temp_names$NAME1=="ROUND_3")] <- "ROUND_MINIR"
names(temp)[which(names(temp)=="ROUND_4")] <- "ROUND_UTURN"
temp_names$NAME1[which(temp_names$NAME1=="ROUND_4")] <- "ROUND_UTURN"
names(temp)[which(names(temp)=="ROUND_9")] <- "ROUND_DK"
temp_names$NAME1[which(temp_names$NAME1=="ROUND_9")] <- "ROUND_DK"
names(temp)[which(names(temp)=="ROUND_DO_2")] <- "ROUND_DO_TCIRC"
temp_names$NAME1[which(temp_names$NAME1=="ROUND_DO_2")] <- "ROUND_DO_TCIRC"
names(temp)[which(names(temp)=="ROUND_DO_1")] <- "ROUND_DO_ROUND"
temp_names$NAME1[which(temp_names$NAME1=="ROUND_DO_1")] <- "ROUND_DO_ROUND"
names(temp)[which(names(temp)=="ROUND_DO_3")] <- "ROUND_DO_MINIR"
temp_names$NAME1[which(temp_names$NAME1=="ROUND_DO_3")] <- "ROUND_DO_MINIR"
names(temp)[which(names(temp)=="ROUND_DO_4")] <- "ROUND_DO_UTURN"
temp_names$NAME1[which(temp_names$NAME1=="ROUND_DO_4")] <- "ROUND_DO_UTURN"
names(temp)[which(names(temp)=="ROUND_DO_9")] <- "ROUND_DO_DK"
temp_names$NAME1[which(temp_names$NAME1=="ROUND_DO_9")] <- "ROUND_DO_DK"
for (i in grep("MODEUSE1_", names(temp), value=T)) {
  temp[,i] <- ordered(temp[,i], levels=c(1:6), labels=c("Never", "Less than once a month", "1-3 days per month", "1-3 days per week", "4-6 days per week", "Almost every day"))
}; rm(i)
names(temp)[which(names(temp)=="MODEUSE1_1")] <- "MODEUSE1_WALK"
temp_names$NAME1[which(temp_names$NAME1=="MODEUSE1_1")] <- "MODEUSE1_WALK"
names(temp)[which(names(temp)=="MODEUSE1_2")] <- "MODEUSE1_BIKE"
temp_names$NAME1[which(temp_names$NAME1=="MODEUSE1_2")] <- "MODEUSE1_BIKE"
names(temp)[which(names(temp)=="MODEUSE1_3")] <- "MODEUSE1_DRIV"
temp_names$NAME1[which(temp_names$NAME1=="MODEUSE1_3")] <- "MODEUSE1_DRIV"
names(temp)[which(names(temp)=="MODEUSE1_4")] <- "MODEUSE1_PASS"
temp_names$NAME1[which(temp_names$NAME1=="MODEUSE1_4")] <- "MODEUSE1_PASS"
names(temp)[which(names(temp)=="MODEUSE1_5")] <- "MODEUSE1_TRAN"
temp_names$NAME1[which(temp_names$NAME1=="MODEUSE1_5")] <- "MODEUSE1_TRAN"
for (i in grep("MODEUSE2_", names(temp), value=T)) {
  temp[,i] <- ordered(temp[,i], levels=c(1:6), labels=c("Never", "Less than once a month", "1-3 days per month", "1-3 days per week", "4-6 days per week", "Almost every day"))
}; rm(i)
names(temp)[which(names(temp)=="MODEUSE2_1")] <- "MODEUSE2_WALK"
temp_names$NAME1[which(temp_names$NAME1=="MODEUSE2_1")] <- "MODEUSE2_WALK"
names(temp)[which(names(temp)=="MODEUSE2_2")] <- "MODEUSE2_BIKE"
temp_names$NAME1[which(temp_names$NAME1=="MODEUSE2_2")] <- "MODEUSE2_BIKE"
names(temp)[which(names(temp)=="MODEUSE2_3")] <- "MODEUSE2_DRIV"
temp_names$NAME1[which(temp_names$NAME1=="MODEUSE2_3")] <- "MODEUSE2_DRIV"
names(temp)[which(names(temp)=="MODEUSE2_4")] <- "MODEUSE2_PASS"
temp_names$NAME1[which(temp_names$NAME1=="MODEUSE2_4")] <- "MODEUSE2_PASS"
names(temp)[which(names(temp)=="MODEUSE2_5")] <- "MODEUSE2_TRAN"
temp_names$NAME1[which(temp_names$NAME1=="MODEUSE2_5")] <- "MODEUSE2_TRAN"
for (i in grep("MODEROUND_", names(temp), value=T)) {
  temp[,i] <- ordered(temp[,i], levels=c(37:40), labels=c("Never", "Sometimes", "Often", "Always"))
}; rm(i)
names(temp)[which(names(temp)=="MODEROUND_1")] <- "MODEROUND_WALK"
temp_names$NAME1[which(temp_names$NAME1=="MODEROUND_1")] <- "MODEROUND_WALK"
names(temp)[which(names(temp)=="MODEROUND_2")] <- "MODEROUND_BIKE"
temp_names$NAME1[which(temp_names$NAME1=="MODEROUND_2")] <- "MODEROUND_BIKE"
names(temp)[which(names(temp)=="MODEROUND_3")] <- "MODEROUND_DRIV"
temp_names$NAME1[which(temp_names$NAME1=="MODEROUND_3")] <- "MODEROUND_DRIV"
for (i in grep("MODEROUTE_", names(temp), value=T)) {
  temp[,i] <- factor(temp[,i], levels=c(1:4), labels=c("Yes_Avoid", "Yes_AvoidAlt", "Yes_Prefer", "No"))
}; rm(i)
names(temp)[which(names(temp)=="MODEROUTE_1")] <- "MODEROUTE_WALK"
temp_names$NAME1[which(temp_names$NAME1=="MODEROUTE_1")] <- "MODEROUTE_WALK"
names(temp)[which(names(temp)=="MODEROUTE_2")] <- "MODEROUTE_BIKE"
temp_names$NAME1[which(temp_names$NAME1=="MODEROUTE_2")] <- "MODEROUTE_BIKE"
names(temp)[which(names(temp)=="MODEROUTE_3")] <- "MODEROUTE_DRIV"
temp_names$NAME1[which(temp_names$NAME1=="MODEROUTE_3")] <- "MODEROUTE_DRIV"
temp$ROUNDMODE <- factor(temp$ROUNDMODE, levels=c(1:5), labels=c("Yes_MuchLess", "Yes_SomeLess", "Yes_SomeMore", "Yes_MuchMore", "No"))

# Experiment
tc <- c(grep("E[0-9][0-9]", names(temp), value=T)[2:55])
for (i in tc) { temp[,i] <- as.integer(temp[,i]) }; rm(i)
for (i in tc[!grepl("DO", tc)]) {
  temp[,i] <- factor(temp[,i], levels=c(1,2), labels=c("1", "2"))
}; rm(i)
for (i in tc[grepl("DO", tc)]) {
  temp[,i] <- factor(temp[,i], levels=c(1,2), labels=c("Left", "Right"))
}; rm(i)
rm(tc)

# Supplemental
tc <- c("SUPCOMFALL", "SUPCOMF_1", "SUPCOMF_2", "SUPCOMF_3", "SUPCOMF_4", "SUPCOMF_5", 
        "SUPTH1", "LPOSTH", "DRCOMF_1", "DRCOMF_2", "DRCOMF_3", "DRBIKEPOS")
for (i in tc) { temp[,i] <- as.integer(temp[,i]) }; rm(i)
rm(tc)
temp$SUPCOMFALL <- ordered(temp$SUPCOMFALL, levels=c(4:1), labels=c("Very uncomfortable", "Somewhat uncomfortable", "Somewhat comfortable", "Very comfortable"))
for (i in grep("SUPCOMF_", names(temp), value=T)) {
  temp[,i] <- ordered(temp[,i], levels=c(4:1), labels=c("Very uncomfortable", "Somewhat uncomfortable", "Somewhat comfortable", "Very comfortable"))
}; rm(i)
names(temp)[which(names(temp)=="SUPCOMF_1")] <- "SUPCOMF_ENTR"
temp_names$NAME1[which(temp_names$NAME1=="SUPCOMF_1")] <- "SUPCOMF_ENTR"
names(temp)[which(names(temp)=="SUPCOMF_2")] <- "SUPCOMF_CIRC"
temp_names$NAME1[which(temp_names$NAME1=="SUPCOMF_2")] <- "SUPCOMF_CIRC"
names(temp)[which(names(temp)=="SUPCOMF_3")] <- "SUPCOMF_EXIT"
temp_names$NAME1[which(temp_names$NAME1=="SUPCOMF_3")] <- "SUPCOMF_EXIT"
names(temp)[which(names(temp)=="SUPCOMF_4")] <- "SUPCOMF_SIDE"
temp_names$NAME1[which(temp_names$NAME1=="SUPCOMF_4")] <- "SUPCOMF_SIDE"
names(temp)[which(names(temp)=="SUPCOMF_5")] <- "SUPCOMF_CROS"
temp_names$NAME1[which(temp_names$NAME1=="SUPCOMF_5")] <- "SUPCOMF_CROS"
temp$SUPTH1 <- factor(temp$SUPTH1, levels=c(1,3,4), labels=c("TravelLane", "SideCrossWalk", "AvoidRoute"))
temp$LPOSTH <- factor(temp$LPOSTH, levels=c(1,2,3), labels=c("Left", "Center", "Right"))
temp$DRCOMFALL <- ordered(temp$DRCOMFALL, levels=c(4:1), labels=c("Very uncomfortable", "Somewhat uncomfortable", "Somewhat comfortable", "Very comfortable"))
for (i in grep("DRCOMF_", names(temp), value=T)) {
  temp[,i] <- ordered(temp[,i], levels=c(4:1), labels=c("Very uncomfortable", "Somewhat uncomfortable", "Somewhat comfortable", "Very comfortable"))
}; rm(i)
names(temp)[which(names(temp)=="DRCOMF_1")] <- "DRCOMF_ENTR"
temp_names$NAME1[which(temp_names$NAME1=="DRCOMF_1")] <- "DRCOMF_ENTR"
names(temp)[which(names(temp)=="DRCOMF_2")] <- "DRCOMF_CIRC"
temp_names$NAME1[which(temp_names$NAME1=="DRCOMF_2")] <- "DRCOMF_CIRC"
names(temp)[which(names(temp)=="DRCOMF_3")] <- "DRCOMF_EXIT"
temp_names$NAME1[which(temp_names$NAME1=="DRCOMF_3")] <- "DRCOMF_EXIT"
temp$DRBIKEPOS <- factor(temp$DRBIKEPOS, levels=c(1,2,3,4), labels=c("Left", "Center", "Right", "NotInLane"))

# Bicycling
tc <- c(grep("CRASH_", names(temp), value=T), grep("CRLOC_", names(temp), value=T)[1:7], "BTRANS", "BREC", "BMORE", 
        grep("BWHYY_", names(temp), value=T)[1:7], grep("BWHYY_DO_", names(temp), value=T), 
        grep("BWHYN_", names(temp), value=T)[1:10], grep("BWHYN_DO_", names(temp), value=T), 
        grep("BC", names(temp), value=T), grep("ATT_", names(temp), value=T), "HELMET_1", "SEATBELT_1")
for (i in tc) { temp[,i] <- as.integer(temp[,i]) }; rm(i)
rm(tc)
for (i in grep("CRASH_", names(temp), value=T)) {
  temp[,i] <- ifelse(is.na(temp[,i]), F, ifelse(temp[,i]==1, T, NA))
}; rm(i)
names(temp)[which(names(temp)=="CRASH_1")] <- "CRASH_HIT"
temp_names$NAME1[which(temp_names$NAME1=="CRASH_1")] <- "CRASH_HIT"
names(temp)[which(names(temp)=="CRASH_3")] <- "CRASH_NHIT"
temp_names$NAME1[which(temp_names$NAME1=="CRASH_3")] <- "CRASH_NHIT"
names(temp)[which(names(temp)=="CRASH_2")] <- "CRASH_NO"
temp_names$NAME1[which(temp_names$NAME1=="CRASH_2")] <- "CRASH_NO"
for (i in grep("CRLOC_", names(temp), value=T)[1:7]) {
  temp[,i] <- ifelse(is.na(temp[,i]), F, ifelse(temp[,i]==1, T, NA))
}; rm(i)
names(temp)[which(names(temp)=="CRLOC_1")] <- "CRLOC_ENTR"
temp_names$NAME1[which(temp_names$NAME1=="CRLOC_1")] <- "CRLOC_ENTR"
names(temp)[which(names(temp)=="CRLOC_2")] <- "CRLOC_CIRCENTR"
temp_names$NAME1[which(temp_names$NAME1=="CRLOC_2")] <- "CRLOC_CIRCENTR"
names(temp)[which(names(temp)=="CRLOC_3")] <- "CRLOC_CIRCEXIT"
temp_names$NAME1[which(temp_names$NAME1=="CRLOC_3")] <- "CRLOC_CIRCEXIT"
names(temp)[which(names(temp)=="CRLOC_4")] <- "CRLOC_EXIT"
temp_names$NAME1[which(temp_names$NAME1=="CRLOC_4")] <- "CRLOC_EXIT"
names(temp)[which(names(temp)=="CRLOC_7")] <- "CRLOC_SIDE"
temp_names$NAME1[which(temp_names$NAME1=="CRLOC_7")] <- "CRLOC_SIDE"
names(temp)[which(names(temp)=="CRLOC_5")] <- "CRLOC_CROS"
temp_names$NAME1[which(temp_names$NAME1=="CRLOC_5")] <- "CRLOC_CROS"
names(temp)[which(names(temp)=="CRLOC_6")] <- "CRLOC_OTHR"
temp_names$NAME1[which(temp_names$NAME1=="CRLOC_6")] <- "CRLOC_OTHR"
names(temp)[which(names(temp)=="CRLOC_6_TEXT")] <- "CRLOC_TEXT"
temp_names$NAME1[which(temp_names$NAME1=="CRLOC_6_TEXT")] <- "CRLOC_TEXT"
temp[!is.na(temp$CRLOC_TEXT) & temp$CRLOC_TEXT!="",103:179]
i <- which(temp$CRLOC_TEXT=="While being passed within the roundabout")
temp[i,c("CRLOC_CIRCENTR", "CRLOC_CIRCEXIT", "CRLOC_OTHR", "CRLOC_TEXT", "CRCOMM")] <- list(TRUE, TRUE, FALSE, NA, paste(temp[i,c("CRLOC_TEXT", "CRCOMM")], collapse=" "))
rm(i)
i <- which(temp$CRLOC_TEXT=="car not seeing me in the travel lane")
temp[i,c("CRLOC_ENTR", "CRLOC_OTHR", "CRLOC_TEXT", "CRCOMM")] <- list(TRUE, FALSE, NA, paste(temp[i,c("CRLOC_TEXT", "CRCOMM")], collapse=". "))
rm(i)
temp$CRLOC_TEXT <- ifelse(temp$CRLOC_TEXT=="", NA, temp$CRLOC_TEXT)
temp[!is.na(temp$CRCOMM) & temp$CRCOMM!="","CRCOMM"]
temp$CRCOMM <- ifelse(temp$CRCOMM=="", NA, temp$CRCOMM)
temp$BTRANS <- ordered(temp$BTRANS, levels=c(1:6), labels=c("In the last week", "In the last month", "In the last year", "In the last 5 years", "More than 5 years ago", "Never"))
temp$BREC <- ordered(temp$BREC, levels=c(1:6), labels=c("In the last week", "In the last month", "In the last year", "In the last 5 years", "More than 5 years ago", "Never"))
temp$BMORE <- ordered(temp$BMORE, levels=c(1:4), labels=c("Strongly agree", "Somewhat agree", "Somewhat disagree", "Strongly disagree"))
for (i in grep("BWHYY_", names(temp), value=T)[1:7]) {
  temp[,i] <- ifelse(is.na(temp[,i]), F, ifelse(temp[,i]==1, T, NA))
}; rm(i)
names(temp)[which(names(temp)=="BWHYY_1")] <- "BWHYY_EXER"
temp_names$NAME1[which(temp_names$NAME1=="BWHYY_1")] <- "BWHYY_EXER"
names(temp)[which(names(temp)=="BWHYY_2")] <- "BWHYY_OUTS"
temp_names$NAME1[which(temp_names$NAME1=="BWHYY_2")] <- "BWHYY_OUTS"
names(temp)[which(names(temp)=="BWHYY_3")] <- "BWHYY_ENVR"
temp_names$NAME1[which(temp_names$NAME1=="BWHYY_3")] <- "BWHYY_ENVR"
names(temp)[which(names(temp)=="BWHYY_4")] <- "BWHYY_COST"
temp_names$NAME1[which(temp_names$NAME1=="BWHYY_4")] <- "BWHYY_COST"
names(temp)[which(names(temp)=="BWHYY_5")] <- "BWHYY_PARK"
temp_names$NAME1[which(temp_names$NAME1=="BWHYY_5")] <- "BWHYY_PARK"
names(temp)[which(names(temp)=="BWHYY_6")] <- "BWHYY_FAST"
temp_names$NAME1[which(temp_names$NAME1=="BWHYY_6")] <- "BWHYY_FAST"
names(temp)[which(names(temp)=="BWHYY_7")] <- "BWHYY_OTHR"
temp_names$NAME1[which(temp_names$NAME1=="BWHYY_7")] <- "BWHYY_OTHR"
names(temp)[which(names(temp)=="BWHYY_7_TEXT")] <- "BWHYY_TEXT"
temp_names$NAME1[which(temp_names$NAME1=="BWHYY_7_TEXT")] <- "BWHYY_TEXT"
temp[!is.na(temp$BWHYY_TEXT) & temp$BWHYY_TEXT!="","BWHYY_TEXT"]
temp$BWHYY_TEXT <- ifelse(temp$BWHYY_TEXT=="", NA, temp$BWHYY_TEXT)
names(temp)[which(names(temp)=="BWHYY_DO_1")] <- "BWHYY_DO_EXER"
temp_names$NAME1[which(temp_names$NAME1=="BWHYY_DO_1")] <- "BWHYY_DO_EXER"
names(temp)[which(names(temp)=="BWHYY_DO_2")] <- "BWHYY_DO_OUTS"
temp_names$NAME1[which(temp_names$NAME1=="BWHYY_DO_2")] <- "BWHYY_DO_OUTS"
names(temp)[which(names(temp)=="BWHYY_DO_3")] <- "BWHYY_DO_ENVR"
temp_names$NAME1[which(temp_names$NAME1=="BWHYY_DO_3")] <- "BWHYY_DO_ENVR"
names(temp)[which(names(temp)=="BWHYY_DO_4")] <- "BWHYY_DO_COST"
temp_names$NAME1[which(temp_names$NAME1=="BWHYY_DO_4")] <- "BWHYY_DO_COST"
names(temp)[which(names(temp)=="BWHYY_DO_5")] <- "BWHYY_DO_PARK"
temp_names$NAME1[which(temp_names$NAME1=="BWHYY_DO_5")] <- "BWHYY_DO_PARK"
names(temp)[which(names(temp)=="BWHYY_DO_6")] <- "BWHYY_DO_FAST"
temp_names$NAME1[which(temp_names$NAME1=="BWHYY_DO_6")] <- "BWHYY_DO_FAST"
names(temp)[which(names(temp)=="BWHYY_DO_7")] <- "BWHYY_DO_OTHR"
temp_names$NAME1[which(temp_names$NAME1=="BWHYY_DO_7")] <- "BWHYY_DO_OTHR"
for (i in grep("BWHYN_", names(temp), value=T)[1:10]) {
  temp[,i] <- ifelse(is.na(temp[,i]), F, ifelse(temp[,i]==1, T, NA))
}; rm(i)
names(temp)[which(names(temp)=="BWHYN_1")] <- "BWHYN_SAFC"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_1")] <- "BWHYN_SAFC"
names(temp)[which(names(temp)=="BWHYN_2")] <- "BWHYN_SAFT"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_2")] <- "BWHYN_SAFT"
names(temp)[which(names(temp)=="BWHYN_3")] <- "BWHYN_NOBI"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_3")] <- "BWHYN_NOBI"
names(temp)[which(names(temp)=="BWHYN_4")] <- "BWHYN_VEHI"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_4")] <- "BWHYN_VEHI"
names(temp)[which(names(temp)=="BWHYN_5")] <- "BWHYN_WEAT"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_5")] <- "BWHYN_WEAT"
names(temp)[which(names(temp)=="BWHYN_6")] <- "BWHYN_DIST"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_6")] <- "BWHYN_DIST"
names(temp)[which(names(temp)=="BWHYN_7")] <- "BWHYN_BFEW"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_7")] <- "BWHYN_BFEW"
names(temp)[which(names(temp)=="BWHYN_9")] <- "BWHYN_CARY"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_9")] <- "BWHYN_CARY"
names(temp)[which(names(temp)=="BWHYN_10")] <- "BWHYN_OMOD"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_10")] <- "BWHYN_OMOD"
names(temp)[which(names(temp)=="BWHYN_8")] <- "BWHYN_OTHR"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_8")] <- "BWHYN_OTHR"
names(temp)[which(names(temp)=="BWHYN_8_TEXT")] <- "BWHYN_TEXT"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_8_TEXT")] <- "BWHYN_TEXT"
temp[!is.na(temp$BWHYN_TEXT) & temp$BWHYN_TEXT!="","BWHYN_TEXT"]
temp$BWHYN_TEXT <- ifelse(temp$BWHYN_TEXT=="", NA, temp$BWHYN_TEXT)
names(temp)[which(names(temp)=="BWHYN_DO_1")] <- "BWHYN_DO_SAFC"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_DO_1")] <- "BWHYN_DO_SAFC"
names(temp)[which(names(temp)=="BWHYN_DO_2")] <- "BWHYN_DO_SAFT"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_DO_2")] <- "BWHYN_DO_SAFT"
names(temp)[which(names(temp)=="BWHYN_DO_3")] <- "BWHYN_DO_NOBI"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_DO_3")] <- "BWHYN_DO_NOBI"
names(temp)[which(names(temp)=="BWHYN_DO_4")] <- "BWHYN_DO_VEHI"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_DO_4")] <- "BWHYN_DO_VEHI"
names(temp)[which(names(temp)=="BWHYN_DO_5")] <- "BWHYN_DO_WEAT"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_DO_5")] <- "BWHYN_DO_WEAT"
names(temp)[which(names(temp)=="BWHYN_DO_6")] <- "BWHYN_DO_DIST"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_DO_6")] <- "BWHYN_DO_DIST"
names(temp)[which(names(temp)=="BWHYN_DO_7")] <- "BWHYN_DO_BFEW"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_DO_7")] <- "BWHYN_DO_BFEW"
names(temp)[which(names(temp)=="BWHYN_DO_9")] <- "BWHYN_DO_CARY"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_DO_9")] <- "BWHYN_DO_CARY"
names(temp)[which(names(temp)=="BWHYN_DO_10")] <- "BWHYN_DO_OMOD"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_DO_10")] <- "BWHYN_DO_OMOD"
names(temp)[which(names(temp)=="BWHYN_DO_8")] <- "BWHYN_DO_OTHR"
temp_names$NAME1[which(temp_names$NAME1=="BWHYN_DO_8")] <- "BWHYN_DO_OTHR"
for (i in grep("BC", names(temp), value=T)) {
  temp[,i] <- ordered(temp[,i], levels=c(4:1), labels=c("Very uncomfortable", "Somewhat uncomfortable", "Somewhat comfortable", "Very comfortable"))
}; rm(i)
names(temp)[which(names(temp)=="BC1")] <- "BC_TRAIL"
temp_names$NAME1[which(temp_names$NAME1=="BC1")] <- "BC_TRAIL"
names(temp)[which(names(temp)=="BC2")] <- "BC_RESID1"
temp_names$NAME1[which(temp_names$NAME1=="BC2")] <- "BC_RESID1"
names(temp)[which(names(temp)=="BC3")] <- "BC_RESID2"
temp_names$NAME1[which(temp_names$NAME1=="BC3")] <- "BC_RESID2"
names(temp)[which(names(temp)=="BC4")] <- "BC_MAJOR1"
temp_names$NAME1[which(temp_names$NAME1=="BC4")] <- "BC_MAJOR1"
names(temp)[which(names(temp)=="BC5")] <- "BC_MAJOR2"
temp_names$NAME1[which(temp_names$NAME1=="BC5")] <- "BC_MAJOR2"
names(temp)[which(names(temp)=="BC6")] <- "BC_MAJOR3"
temp_names$NAME1[which(temp_names$NAME1=="BC6")] <- "BC_MAJOR3"
for (i in grep("ATT_", names(temp), value=T)) {
  temp[,i] <- ordered(temp[,i], levels=c(1:4), labels=c("Strongly agree", "Somewhat agree", "Somewhat disagree", "Strongly disagree"))
}; rm(i)
names(temp)[which(names(temp)=="ATT_5")] <- "ATT_WALK"
temp_names$NAME1[which(temp_names$NAME1=="ATT_5")] <- "ATT_WALK"
names(temp)[which(names(temp)=="HELMET_1")] <- "HELMET"
temp_names$NAME1[which(temp_names$NAME1=="HELMET_1")] <- "HELMET"
names(temp)[which(names(temp)=="SEATBELT_1")] <- "SEATBELT"
temp_names$NAME1[which(temp_names$NAME1=="SEATBELT_1")] <- "SEATBELT"

# Personal characteristics
temp$HLOC_1 <- ifelse(temp$HLOC_1=="", NA, temp$HLOC_1)
temp$HLOC_2 <- ifelse(temp$HLOC_2=="", NA, temp$HLOC_2)
temp$HLOC_3 <- ifelse(temp$HLOC_3=="", NA, temp$HLOC_3)
sort(unique(temp$HLOC_1))
table(temp$HLOC_2)
tempstate <- c()
temp$HLOC_2 <- toupper(temp$HLOC_2)
for (i in 1:nrow(temp)) {
  if (is.na(temp$HLOC_2[i])) { 
    # NA, so no edit 
  } else if (temp$HLOC_2[i] %in% state.abb) {
    # abbrevated, so no edit
  } else if (temp$HLOC_2[i] %in% toupper(state.name)) {
    j <- which(toupper(state.name)==temp$HLOC_2[i])
    temp$HLOC_2[i] <- state.abb[j]
    rm(j)
  } else { tempstate <- c(tempstate, i) }
}; rm(i)
temp$HLOC_2[tempstate]
temp$HLOC_2[tempstate] <- "DC"
rm(tempstate)
table(temp$HLOC_2)
sort(unique(temp$HLOC_3))
temp$HLOC_3 <- substr(temp$HLOC_3, 1, 5)
sort(unique(temp$HLOC_3))
names(temp)[which(names(temp)=="HLOC_1")] <- "HLOC_CIT"
temp_names$NAME1[which(temp_names$NAME1=="HLOC_1")] <- "HLOC_CIT"
names(temp)[which(names(temp)=="HLOC_2")] <- "HLOC_STA"
temp_names$NAME1[which(temp_names$NAME1=="HLOC_2")] <- "HLOC_STA"
names(temp)[which(names(temp)=="HLOC_3")] <- "HLOC_ZIP"
temp_names$NAME1[which(temp_names$NAME1=="HLOC_3")] <- "HLOC_ZIP"
tc <- c("HHINC", "BIKES", "CARS", "ADULT", "CHILD", "AGE", "GEND", 
        grep("RACE_", names(temp), value=T)[1:8], "EDUC", "STUD", "WORK")
for (i in tc) { temp[,i] <- as.integer(temp[,i]) }; rm(i)
rm(tc)
temp$HHINC <- factor(temp$HHINC, levels=c(1:11), labels=c("000_009", "010_014", "015_024", "025_034", "035_049", "050_074", "075_099", "100_149", "150_999", "DK", "NA"))
temp$BIKES <- ordered(temp$BIKES, levels=c(1:6), labels=c("0", "1", "2", "3", "4", "5+"))
temp$CARS <- ordered(temp$CARS, levels=c(1:6), labels=c("0", "1", "2", "3", "4", "5+"))
temp$ADULT <- ordered(temp$ADULT, levels=c(1:6), labels=c("0", "1", "2", "3", "4", "5+"))
temp$CHILD <- ordered(temp$CHILD, levels=c(1:6), labels=c("0", "1", "2", "3", "4", "5+"))
temp$AGE <- factor(temp$AGE, levels=c(1:10), labels=c("18_19", "20_24", "25_34", "35_44", "45_54", "55_64", "65_74", "75_84", "85_99", "NA"))
temp$GEND <- factor(temp$GEND, levels=c(1:4), labels=c("Female", "Male", "SD", "NA"))
names(temp)[which(names(temp)=="GEND_3_TEXT")] <- "GEND_TEXT"
temp_names$NAME1[which(temp_names$NAME1=="GEND_3_TEXT")] <- "GEND_TEXT"
temp$GEND_TEXT <- ifelse(temp$GEND_TEXT=="", NA, temp$GEND_TEXT)
for (i in grep("RACE_", names(temp), value=T)[1:8]) {
  temp[,i] <- ifelse(is.na(temp[,i]), F, ifelse(temp[,i]==1, T, NA))
}; rm(i)
names(temp)[which(names(temp)=="RACE_1")] <- "RACE_WHIT"
temp_names$NAME1[which(temp_names$NAME1=="RACE_1")] <- "RACE_WHIT"
names(temp)[which(names(temp)=="RACE_2")] <- "RACE_HISP"
temp_names$NAME1[which(temp_names$NAME1=="RACE_2")] <- "RACE_HISP"
names(temp)[which(names(temp)=="RACE_3")] <- "RACE_ASIA"
temp_names$NAME1[which(temp_names$NAME1=="RACE_3")] <- "RACE_ASIA"
names(temp)[which(names(temp)=="RACE_4")] <- "RACE_BLAC"
temp_names$NAME1[which(temp_names$NAME1=="RACE_4")] <- "RACE_BLAC"
names(temp)[which(names(temp)=="RACE_5")] <- "RACE_AIAN"
temp_names$NAME1[which(temp_names$NAME1=="RACE_5")] <- "RACE_AIAN"
names(temp)[which(names(temp)=="RACE_6")] <- "RACE_NHPI"
temp_names$NAME1[which(temp_names$NAME1=="RACE_6")] <- "RACE_NHPI"
names(temp)[which(names(temp)=="RACE_7")] <- "RACE_SD"
temp_names$NAME1[which(temp_names$NAME1=="RACE_7")] <- "RACE_SD"
names(temp)[which(names(temp)=="RACE_8")] <- "RACE_NA"
temp_names$NAME1[which(temp_names$NAME1=="RACE_8")] <- "RACE_NA"
names(temp)[which(names(temp)=="RACE_7_TEXT")] <- "RACE_TEXT"
temp_names$NAME1[which(temp_names$NAME1=="RACE_7_TEXT")] <- "RACE_TEXT"
temp$RACE_TEXT <- ifelse(temp$RACE_TEXT=="", NA, temp$RACE_TEXT)
temp$EDUC <- factor(temp$EDUC, levels=c(1,2,5,6,9), labels=c("LessHS", "HSGED", "BachAs", "MastUp", "NA"))
temp$STUD <- factor(temp$STUD, levels=c(1,3), labels=c("Yes", "No"))
temp$WORK <- factor(temp$WORK, levels=c(1,4), labels=c("Yes", "No"))

# End
tc <- c("DRAW")
for (i in tc) { temp[,i] <- as.integer(temp[,i]) }; rm(i)
rm(tc)
temp$COMMENTS <- ifelse(temp$COMMENTS=="", NA, temp$COMMENTS)
temp$DRAW <- factor(temp$DRAW, levels=c(1,2), labels=c("Yes", "No"))
temp$EMAIL <- ifelse(temp$EMAIL=="", NA, temp$EMAIL)

# Display order
tc <- c(grep("ExperimentBlock", names(temp), value=T), grep("Supplemental", names(temp), value=T))
for (i in tc) { temp[,i] <- as.integer(temp[,i]) }; rm(i)
rm(tc)
for (i in grep("DO_ExperimentBlock", names(temp), value=T)) {
  temp[,i] <- ifelse(is.na(temp[,i]), F, ifelse(temp[,i]==1, T, NA))
}; rm(i)
names(temp)[which(names(temp)=="FL_41_DO_ExperimentBlock1")] <- "EB1"
temp_names$NAME1[which(temp_names$NAME1=="FL_41_DO_ExperimentBlock1")] <- "EB1"
names(temp)[which(names(temp)=="FL_41_DO_ExperimentBlock2")] <- "EB2"
temp_names$NAME1[which(temp_names$NAME1=="FL_41_DO_ExperimentBlock2")] <- "EB2"
names(temp)[which(names(temp)=="FL_41_DO_ExperimentBlock3")] <- "EB3"
temp_names$NAME1[which(temp_names$NAME1=="FL_41_DO_ExperimentBlock3")] <- "EB3"
names(temp) <- gsub("ExperimentBlock1_DO_", "EB1_DO_", names(temp))
temp_names$NAME1 <- gsub("ExperimentBlock1_DO_", "EB1_DO_", temp_names$NAME1)
names(temp) <- gsub("ExperimentBlock2_DO_", "EB2_DO_", names(temp))
temp_names$NAME1 <- gsub("ExperimentBlock2_DO_", "EB2_DO_", temp_names$NAME1)
names(temp) <- gsub("ExperimentBlock3_DO_", "EB3_DO_", names(temp))
temp_names$NAME1 <- gsub("ExperimentBlock3_DO_", "EB3_DO_", temp_names$NAME1)
for (i in grep("Supplemental_DO_S[0-9]", names(temp), value=T)) {
  temp[,i] <- ifelse(is.na(temp[,i]), F, ifelse(temp[,i]==2, T, NA))
}; rm(i)
temp$Supplemental_DO_QDRIVE2 <- ifelse(is.na(temp$Supplemental_DO_QDRIVE2), F, ifelse(temp$Supplemental_DO_QDRIVE2==9, T, NA))
temp$Supplemental_DO_QSUPBIKE2 <- ifelse(is.na(temp$Supplemental_DO_QSUPBIKE2), F, ifelse(temp$Supplemental_DO_QSUPBIKE2==4, T, NA))
names(temp) <- gsub("Supplemental_DO_", "S_DO_", names(temp))
temp_names$NAME1 <- gsub("Supplemental_DO_", "S_DO_", temp_names$NAME1)

# Save
saveRDS(temp, file.path("Data", "Survey", "dat1raw.rds"))
write.csv(temp, file.path("Data", "Survey", "dat1raw.csv"), row.names=F)
saveRDS(temp_names, file.path("Data", "Survey", "dat1raw_names.rds"))
write.csv(temp_names, file.path("Data", "Survey", "dat1raw_names.csv"), row.names=F)

########################################
# Anonymize data

# Create new
tempa <- temp

# Inspect
names(tempa)
str(tempa[,1:48])
str(tempa[,49:102])
str(tempa[,103:179])
str(tempa[,180:205])
str(tempa[,206:259])

# Remove personally-identifyable information
tempa$IPAddress <- NA
tempa$RecipientLastName <- NA
tempa$RecipientFirstName <- NA
tempa$RecipientEmail <- NA
tempa$ExternalReference <- NA
tempa$LocationLatitude <- NA
tempa$LocationLongitude <- NA
tempa$CRLOC_TEXT <- NA
tempa$CRCOMM <- NA
unique(tempa$BWHYY_TEXT) # okay to keep
unique(tempa$BWHYN_TEXT) # okay to keep
sort(table(tempa$HLOC_CIT), decreasing=T)
tempa$HLOC_CIT <- NA # zip-code more accurate
sort(table(tempa$HLOC_STA), decreasing=T) # okay to keep
sort(table(tempa$HLOC_ZIP), decreasing=T) # okay to keep
table(tempa$GEND_TEXT)
tempa$GEND_TEXT <- NA
table(tempa$RACE_TEXT)
tempa$RACE_TEXT <- NA
unique(tempa$COMMENTS)
tempa$COMMENTS <- NA
tempa$EMAIL <- NA

# Save
saveRDS(tempa, file.path("Data", "Survey", "dat2anon.rds"))
write.csv(tempa, file.path("Data", "Survey", "dat2anon.csv"), row.names=F)

########################################
# Add additional variables

# Create new
# tempb <- temp
tempb <- tempa

# Bicyclist type (Dill & McNeil 2012, Dill & McNeil 2016)
# inspect questions
temp_names[temp_names$NAME1=="BC_MAJOR1",]; table(tempb$BC_MAJOR1)
temp_names[temp_names$NAME1=="BC_MAJOR2",]; table(tempb$BC_MAJOR2)
temp_names[temp_names$NAME1=="CANBIKE",]; table(tempb$CANBIKE)
temp_names[temp_names$NAME1=="BC_TRAIL",]; table(tempb$BC_TRAIL)
temp_names[temp_names$NAME1=="BMORE",]; table(tempb$BMORE)
temp_names[temp_names$NAME1=="Finished",]; table(tempb$Finished)
temp_names[temp_names$NAME1=="BTRANS",]; table(tempb$BTRANS)
temp_names[temp_names$NAME1=="BREC",]; table(tempb$BREC)
# create cyclist type
tempb$btype <- NA
tempb$btype <- ifelse(is.na(tempb$btype) & tempb$BC_MAJOR1=="Very comfortable", "Strong and fearless", tempb$btype) # 42
tempb$btype <- ifelse(is.na(tempb$btype) & tempb$BC_MAJOR2=="Very comfortable", "Enthused and confident", tempb$btype) # 112
tempb$btype <- ifelse(is.na(tempb$btype) & tempb$CANBIKE %in% c("Able_DK", "Unable"), "No way, no how", tempb$btype) # 4
tempb$btype <- ifelse(is.na(tempb$btype) & tempb$BC_TRAIL=="Very uncomfortable", "No way, no how", tempb$btype) # 1
tempb$btype <- ifelse(is.na(tempb$btype) & tempb$BMORE=="Strongly disagree", "No way, no how", tempb$btype) # 7
tempb$btype <- ifelse(is.na(tempb$btype) & tempb$Finished==1, "Interested but concerned", tempb$btype) # 436
tempb$btype <- ifelse(tempb$btype=="No way, no how" & tempb$BTRANS %in% c("In the last week", "In the last month"), "Interested but concerned", tempb$btype) # 4
tempb$btype <- ifelse(tempb$btype=="No way, no how" & tempb$BREC %in% c("In the last week", "In the last month"), "Interested but concerned", tempb$btype) # 3
# create ordered factor
tempb$btype <- ordered(tempb$btype, levels=c("No way, no how", "Interested but concerned", "Enthused and confident", "Strong and fearless"))
# inspect
summary(tempb$btype)
prop.table(table(tempb$btype))
c(56,9,4)/sum(c(56,9,4)) # Dill & McNeil 2012 (Portland)
c(51,5,7)/sum(c(51,5,7)) # Dill & McNeil 2016 (national)
# --> breakdown by type of cyclist is approximately okay (excluding "no way, no how", which our survey does)

# Save
saveRDS(tempb, file.path("Data", "Survey", "dat3.rds"))
write.csv(tempb, file.path("Data", "Survey", "dat3.csv"), row.names=F)

########################################
# Clean up

# Remove
rm(old_temp, temp_names, temp, tempa, tempb)
gc()

########################################
# END
########################################