# -*- coding: utf-8 -*-
"""
Created on Thu May 13 18:07:38 2021

@author: Niranjan.p
"""
import pandas as pd           
import biogeme.database as db
import biogeme.biogeme as bio
import biogeme.models as models
import biogeme.messaging as msg
from biogeme.expressions import Beta, DefineVariable, bioDraws, \
    PanelLikelihoodTrajectory, MonteCarlo, log


# Read the data
df = pd.read_csv('Hetero.csv')
df = df.drop(columns=['ResponseId'])
database=db.Database("Hetero",df)

database.panel("ID")
globals().update(database.variables)


### Paramter to be extimated

BIsland_small = Beta('BIsland_small',0.246,None,None,0)
BLane_1 = Beta('BLane_1',0.827,None,None,0)
BFacility_Shared = Beta('BFacility_Shared',0.665, None,None,0)
BFacility_Ramps = Beta('BFacility_Ramps',-1.47,None,None,0)
BFacility_Seperated = Beta('BFacility_Seperated',0.501,None,None,0)
BVolume_Medium = Beta('BVolume_Medium',-0.823,None,None,0)
BVolume_High = Beta('BVolume_High',-1.45,None,None,0)
BSpeed_35 = Beta('BSpeed_35',-0.239,None,None,0)

#We need at least on random parameter for monte carlo
sigma_speed_35 = Beta('sigma_speed_35',-0.752, None, None,0)
sigma_volume_high = Beta('sigma_volume_high',0.736,None,None,0)
sigma_volume_medium = Beta('sigma_volume_medium',-0.302,None,None,0)
sigma_facility_seperated = Beta('sigma_facility_seperated',	-4.16,None,None,0)
sigma_facility_ramps = Beta('sigma_facility_ramps',3.67,None,None,0)
sigma_facility_shared = Beta('sigma_facility_shared',1.75,None,None,0)
sigma_lane_1 = Beta('sigma_lane_1',1.7,None,None,0)
sigma_island_small = Beta('sigma_island_small',-0.218,None,None,0)


BMROUTE_B_YA_S = Beta('BMROUTE_B_YA_S',0,None,None,0)
BMROUTE_B_YA_VH = Beta('BMROUTE_B_YA_VH',0,None,None,0)
BMROUTE_B_YA_VM = Beta('BMROUTE_B_YA_VM',0,None,None,0)
BMROUTE_B_YA_FSep = Beta('BMROUTE_B_YA_FSep',0,None,None,0)
BMROUTE_B_YA_FShared = Beta('BMROUTE_B_YA_FShared',0,None,None,0)
BMROUTE_B_YA_FR = Beta('BMROUTE_B_YA_FR',0,None,None,0)
BMROUTE_B_YA_L = Beta('BMROUTE_B_YA_L',0,None,None,0)
BMROUTE_B_YA_I = Beta('BMROUTE_B_YA_I',0,None,None,0)

BMROUTE_B_YAt_S = Beta('BMROUTE_B_YAt_S',0,None,None,0)
BMROUTE_B_YAt_VH = Beta('BMROUTE_B_YAt_VH',0,None,None,0)
BMROUTE_B_YAt_VM = Beta('BMROUTE_B_YAt_VM',0,None,None,0)
BMROUTE_B_YAt_FSep = Beta('BMROUTE_B_YAt_FSep',0,None,None,0)
BMROUTE_B_YAt_FShared = Beta('BMROUTE_B_YAt_FShared',0,None,None,0)
BMROUTE_B_YAt_FR = Beta('BMROUTE_B_YAt_FR',0,None,None,0)
BMROUTE_B_YAt_L = Beta('BMROUTE_B_YAt_L',0,None,None,0)
BMROUTE_B_YAt_I = Beta('BMROUTE_B_YAt_I',0,None,None,0)

BMROUTE_B_YP_S = Beta('BMROUTE_B_YP_S',0,None,None,0)
BMROUTE_B_YP_VH = Beta('BMROUTE_B_YP_VH',0,None,None,0)
BMROUTE_B_YP_VM = Beta('BMROUTE_B_YP_VM',0,None,None,0)
BMROUTE_B_YP_FSep = Beta('BMROUTE_B_YP_FSep',0,None,None,0)
BMROUTE_B_YP_FShared = Beta('BMROUTE_B_YP_FShared',0,None,None,0)
BMROUTE_B_YP_FR = Beta('BMROUTE_B_YP_FR',0,None,None,0)
BMROUTE_B_YP_L = Beta('BMROUTE_B_YP_L',0,None,None,0)
BMROUTE_B_YP_I = Beta('BMROUTE_B_YP_I',0,None,None,0)

BMROUTE_MISS_S = Beta('BMROUTE_Miss_S',0,None,None,0)
BMROUTE_MISS_VH = Beta('BMROUTE_Miss_VH',0,None,None,0)
BMROUTE_MISS_VM = Beta('BMROUTE_Miss_VM',0,None,None,0)
BMROUTE_MISS_FSep = Beta('BMROUTE_Miss_FSep',0,None,None,0)
BMROUTE_MISS_FShared = Beta('BMROUTE_Miss_FShared',0,None,None,0)
BMROUTE_MISS_FR = Beta('BMROUTE_Miss_FR',0,None,None,0)
BMROUTE_MISS_L = Beta('BMROUTE_Miss_L',0,None,None,0)
BMROUTE_MISS_I = Beta('BMROUTE_Miss_I',0,None,None,0)

BROUNDMODE_Miss_S = Beta('BROUNDMODE_Miss_S',0,None,None,0)
BROUNDMODE_Miss_VH = Beta('BROUNDMODE_Miss_VH',0,None,None,0)
BROUNDMODE_Miss_VM = Beta('BROUNDMODE_Miss_VM',0,None,None,0)
BROUNDMODE_Miss_FSep = Beta('BROUNDMODE_Miss_FSep',0,None,None,0)
BROUNDMODE_Miss_FShared = Beta('BROUNDMODE_Miss_FShared',0,None,None,0)
BROUNDMODE_Miss_FR = Beta('BROUNDMODE_Miss_FR',0,None,None,0)
BROUNDMODE_Miss_L = Beta('BROUNDMODE_Miss_L',0,None,None,0)
BROUNDMODE_Miss_I = Beta('BROUNDMODE_Miss_I',0,None,None,0)

BROUNDMODE_YesLess_S = Beta('BROUNDMODE_YesLess_S',0,None,None,0)
BROUNDMODE_YesLess_VH = Beta('BROUNDMODE_YesLess_VH',0,None,None,0)
BROUNDMODE_YesLess_VM = Beta('BROUNDMODE_YesLess_VM',0,None,None,0)
BROUNDMODE_YesLess_FSep = Beta('BROUNDMODE_YesLess_FSep',0,None,None,0)
BROUNDMODE_YesLess_FShared = Beta('BROUNDMODE_YesLess_FShared',0,None,None,0)
BROUNDMODE_YesLess_FR = Beta('BROUNDMODE_YesLess_FR',0,None,None,0)
BROUNDMODE_YesLess_L = Beta('BROUNDMODE_YesLess_L',0,None,None,0)
BROUNDMODE_YesLess_I = Beta('BROUNDMODE_YesLess_I',0,None,None,0)

BROUNDMODE_YesMore_S = Beta('BROUNDMODE_YesMore_S',0,None,None,0)
BROUNDMODE_YesMore_VH = Beta('BROUNDMODE_YesMore_VH',0,None,None,0)
BROUNDMODE_YesMore_VM = Beta('BROUNDMODE_YesMore_VM',0,None,None,0)
BROUNDMODE_YesMore_FSep = Beta('BROUNDMODE_YesMore_FSep',0,None,None,0)
BROUNDMODE_YesMore_FShared = Beta('BROUNDMODE_YesMore_FShared',0,None,None,0)
BROUNDMODE_YesMore_FR = Beta('BROUNDMODE_YesMore_FR',0,None,None,0)
BROUNDMODE_YesMore_L = Beta('BROUNDMODE_YesMore_L',0,None,None,0)
BROUNDMODE_YesMore_I = Beta('BROUNDMODE_YesMore_I',0,None,None,0)


BSpeed_35RND = BSpeed_35 + sigma_speed_35 * bioDraws('BSpeed_35RND','NORMAL') + \
                BMROUTE_B_YA_S * MODEROUTE_BIKE_Yes_Avoid  + \
                BMROUTE_B_YAt_S * MODEROUTE_BIKE_Yes_AvoidAlt + BMROUTE_B_YP_S * MODEROUTE_BIKE_Yes_Prefer +\
                BMROUTE_MISS_S * MODEROUTE_BIKE_Missing + BROUNDMODE_Miss_S * ROUNDMODE_Missing +\
                BROUNDMODE_YesLess_S * ROUNDMODE_YesLess + BROUNDMODE_YesMore_S * ROUNDMODE_YesMore

BVolume_HighRND = BVolume_High + sigma_volume_high * bioDraws('BVolume_HighRND','NORMAL')  + \
                 BMROUTE_B_YA_VH * MODEROUTE_BIKE_Yes_Avoid  + \
                BMROUTE_B_YAt_VH * MODEROUTE_BIKE_Yes_AvoidAlt + BMROUTE_B_YP_VH * MODEROUTE_BIKE_Yes_Prefer +\
                BMROUTE_MISS_VH * MODEROUTE_BIKE_Missing + BROUNDMODE_Miss_VH * ROUNDMODE_Missing +\
                BROUNDMODE_YesLess_VH * ROUNDMODE_YesLess + BROUNDMODE_YesMore_VH * ROUNDMODE_YesMore

                
BVolume_MediumRND = BVolume_Medium+ sigma_volume_medium * bioDraws('BVolume_MediumRND','NORMAL')+ \
                BMROUTE_B_YA_VM * MODEROUTE_BIKE_Yes_Avoid  + \
                BMROUTE_B_YAt_VM * MODEROUTE_BIKE_Yes_AvoidAlt + BMROUTE_B_YP_VM * MODEROUTE_BIKE_Yes_Prefer +\
                BMROUTE_MISS_VM * MODEROUTE_BIKE_Missing + BROUNDMODE_Miss_VM * ROUNDMODE_Missing +\
                BROUNDMODE_YesLess_VM * ROUNDMODE_YesLess + BROUNDMODE_YesMore_VM * ROUNDMODE_YesMore

                
BFacility_SeperatedRND = BFacility_Seperated + sigma_facility_seperated * bioDraws('BFacility_SeperatedRND','NORMAL') + \
                 BMROUTE_B_YA_FSep * MODEROUTE_BIKE_Yes_Avoid  + \
                BMROUTE_B_YAt_FSep * MODEROUTE_BIKE_Yes_AvoidAlt + BMROUTE_B_YP_FSep * MODEROUTE_BIKE_Yes_Prefer +\
                BMROUTE_MISS_FSep * MODEROUTE_BIKE_Missing+ BROUNDMODE_Miss_FSep * ROUNDMODE_Missing +\
                BROUNDMODE_YesLess_FSep * ROUNDMODE_YesLess + BROUNDMODE_YesMore_FSep * ROUNDMODE_YesMore

BFacility_SharedRND = BFacility_Shared + sigma_facility_shared * bioDraws('BFacility_SharedRND','NORMAL') + \
                BMROUTE_B_YA_FShared * MODEROUTE_BIKE_Yes_Avoid  + \
                BMROUTE_B_YAt_FShared * MODEROUTE_BIKE_Yes_AvoidAlt + BMROUTE_B_YP_FShared * MODEROUTE_BIKE_Yes_Prefer +\
                BMROUTE_MISS_FShared * MODEROUTE_BIKE_Missing+ BROUNDMODE_Miss_FShared * ROUNDMODE_Missing +\
                BROUNDMODE_YesLess_FShared * ROUNDMODE_YesLess + BROUNDMODE_YesMore_FShared * ROUNDMODE_YesMore


BFacility_RampsRND = BFacility_Ramps + sigma_facility_ramps * bioDraws('BFacility_RampsRND','NORMAL') + \
                 BMROUTE_B_YA_FR * MODEROUTE_BIKE_Yes_Avoid  + \
                BMROUTE_B_YAt_FR * MODEROUTE_BIKE_Yes_AvoidAlt + BMROUTE_B_YP_FR * MODEROUTE_BIKE_Yes_Prefer +\
                BMROUTE_MISS_FR * MODEROUTE_BIKE_Missing+ BROUNDMODE_Miss_FR * ROUNDMODE_Missing +\
                BROUNDMODE_YesLess_FR * ROUNDMODE_YesLess + BROUNDMODE_YesMore_FR * ROUNDMODE_YesMore


BLane_1RND = BLane_1 + sigma_lane_1 * bioDraws('BLane_1RND','NORMAL') + \
                BMROUTE_B_YA_L * MODEROUTE_BIKE_Yes_Avoid  + \
                BMROUTE_B_YAt_L * MODEROUTE_BIKE_Yes_AvoidAlt + BMROUTE_B_YP_L * MODEROUTE_BIKE_Yes_Prefer +\
                BMROUTE_MISS_L * MODEROUTE_BIKE_Missing + BROUNDMODE_Miss_L * ROUNDMODE_Missing +\
                BROUNDMODE_YesLess_L * ROUNDMODE_YesLess + BROUNDMODE_YesMore_L * ROUNDMODE_YesMore


BIsland_smallRND = BIsland_small + sigma_island_small * bioDraws('BIsland_smallRND','NORMAL') + \
                 BMROUTE_B_YA_I * MODEROUTE_BIKE_Yes_Avoid  + \
                BMROUTE_B_YAt_I * MODEROUTE_BIKE_Yes_AvoidAlt + BMROUTE_B_YP_I * MODEROUTE_BIKE_Yes_Prefer +\
                BMROUTE_MISS_I * MODEROUTE_BIKE_Missing + BROUNDMODE_Miss_I * ROUNDMODE_Missing +\
                BROUNDMODE_YesLess_I * ROUNDMODE_YesLess + BROUNDMODE_YesMore_I * ROUNDMODE_YesMore


# Next defining the utility function

V1 = BIsland_smallRND * Island_small_A + BLane_1RND * Lane_1_A + BFacility_SharedRND * Facility_Shared_A + \
     BFacility_RampsRND * Facility_Ramps_A + BFacility_SeperatedRND * Facility_Seperated_A + BVolume_MediumRND * Volume_Medium_A + \
     BVolume_HighRND * Volume_High_A + BSpeed_35RND * Speed_35_A
     
V2 = BIsland_smallRND * Island_small_B + BLane_1RND * Lane_1_B + BFacility_SharedRND * Facility_Shared_B + \
     BFacility_RampsRND * Facility_Ramps_B + BFacility_SeperatedRND * Facility_Seperated_B + BVolume_MediumRND * Volume_Medium_B + \
     BVolume_HighRND * Volume_High_B + BSpeed_35RND * Speed_35_B
     
V ={1: V1,
    2: V2,}

av = {1: av ,
      2: av,}

## Proceeding towards estimation
obsprob = models.logit(V,av,Choice) 

## Panel nature of the data
condprobIndiv = PanelLikelihoodTrajectory(obsprob)

logprob = log(MonteCarlo(condprobIndiv))

import biogeme.messaging as msg
logger = msg.bioMessage()
#logger.setSilent()
#logger.setWarning()
#logger.setGeneral()
logger.setDetailed()

biogeme = bio.BIOGEME(database,logprob,numberOfDraws = 1000,suggestScales=False)
#biogeme.loadSavedIteration()
biogeme.modelName = "Eight"
results = biogeme.estimate(saveIterations=True)
pandasResults = results.getEstimatedParameters()
print(pandasResults) 

               
                
                

                
                
