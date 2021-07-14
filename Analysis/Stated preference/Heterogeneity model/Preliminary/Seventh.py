# -*- coding: utf-8 -*-
"""
Created on Thu May 13 18:08:43 2021

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

BMODEROUND_A_S = Beta('BMODEROUND_A_S',0,None,None,0)
BMODEROUND_A_VH = Beta('BMODEROUND_A_VH',0,None,None,0)
BMODEROUND_A_VM = Beta('BMODEROUND_A_VM',0,None,None,0)
BMODEROUND_A_FSep = Beta('BMODEROUND_A_FSep',0,None,None,0)
BMODEROUND_A_FShared = Beta('BMODEROUND_A_FShared',0,None,None,0)
BMODEROUND_A_FR = Beta('BMODEROUND_A_FR',0,None,None,0)
BMODEROUND_A_L = Beta('BMODEROUND_A_L',0,None,None,0)
BMODEROUND_A_I = Beta('BMODEROUND_A_I',0,None,None,0)

BMODEROUND_N_S = Beta('BMODEROUND_N_S',0,None,None,0)
BMODEROUND_N_VH = Beta('BMODEROUND_N_VH',0,None,None,0)
BMODEROUND_N_VM = Beta('BMODEROUND_N_VM',0,None,None,0)
BMODEROUND_N_FSep = Beta('BMODEROUND_N_FSep',0,None,None,0)
BMODEROUND_N_FShared = Beta('BMODEROUND_N_FShared',0,None,None,0)
BMODEROUND_N_FR = Beta('BMODEROUND_N_FR',0,None,None,0)
BMODEROUND_N_L = Beta('BMODEROUND_N_L',0,None,None,0)
BMODEROUND_N_I = Beta('BMODEROUND_N_I',0,None,None,0)

BMODEROUND_O_S = Beta('BMODEROUND_O_S',0,None,None,0)
BMODEROUND_O_VH = Beta('BMODEROUND_O_VH',0,None,None,0)
BMODEROUND_O_VM = Beta('BMODEROUND_O_VM',0,None,None,0)
BMODEROUND_O_FSep = Beta('BMODEROUND_O_FSep',0,None,None,0)
BMODEROUND_O_FShared = Beta('BMODEROUND_O_FShared',0,None,None,0)
BMODEROUND_O_FR = Beta('BMODEROUND_O_FR',0,None,None,0)
BMODEROUND_O_L = Beta('BMODEROUND_O_L',0,None,None,0)
BMODEROUND_O_I = Beta('BMODEROUND_O_I',0,None,None,0)

BMODEROUND_MISS_S = Beta('BMODEROUND_MISS_S',0,None,None,0)
BMODEROUND_MISS_VH = Beta('BMODEROUND_MISS_VH',0,None,None,0)
BMODEROUND_MISS_VM = Beta('BMODEROUND_MISS_VM',0,None,None,0)
BMODEROUND_MISS_FSep = Beta('BMODEROUND_MISS_FSep',0,None,None,0)
BMODEROUND_MISS_FShared = Beta('BMODEROUND_MISS_FShared',0,None,None,0)
BMODEROUND_MISS_FR = Beta('BMODEROUND_MISS_FR',0,None,None,0)
BMODEROUND_MISS_L = Beta('BMODEROUND_MISS_L',0,None,None,0)
BMODEROUND_MISS_I = Beta('BMODEROUND_MISS_I',0,None,None,0)

BSpeed_35RND = BSpeed_35 + sigma_speed_35 * bioDraws('BSpeed_35RND','NORMAL')  + BMODEROUND_O_S * MODEROUND_BIKE_Often + \
                BMODEROUND_A_S * MODEROUND_BIKE_Always + BMODEROUND_N_S * MODEROUND_BIKE_Never + BMODEROUND_MISS_S * MODEROUND_BIKE_Missing

BVolume_HighRND = BVolume_High + sigma_volume_high * bioDraws('BVolume_HighRND','NORMAL')   + BMODEROUND_O_VH * MODEROUND_BIKE_Often + \
                BMODEROUND_A_VH * MODEROUND_BIKE_Always + BMODEROUND_N_VH * MODEROUND_BIKE_Never + BMODEROUND_MISS_VH * MODEROUND_BIKE_Missing
                
BVolume_MediumRND = BVolume_Medium+ sigma_volume_medium * bioDraws('BVolume_MediumRND','NORMAL') + BMODEROUND_O_VM * MODEROUND_BIKE_Often + \
                BMODEROUND_A_VM * MODEROUND_BIKE_Always + BMODEROUND_N_VM * MODEROUND_BIKE_Never+ BMODEROUND_MISS_VM * MODEROUND_BIKE_Missing
                
BFacility_SeperatedRND = BFacility_Seperated + sigma_facility_seperated * bioDraws('BFacility_SeperatedRND','NORMAL') + BMODEROUND_O_FSep * MODEROUND_BIKE_Often + \
                BMODEROUND_A_FSep * MODEROUND_BIKE_Always + BMODEROUND_N_FSep * MODEROUND_BIKE_Never+ BMODEROUND_MISS_FSep * MODEROUND_BIKE_Missing

BFacility_SharedRND = BFacility_Shared + sigma_facility_shared * bioDraws('BFacility_SharedRND','NORMAL')  + BMODEROUND_O_FShared * MODEROUND_BIKE_Often + \
                BMODEROUND_A_FShared * MODEROUND_BIKE_Always + BMODEROUND_N_FShared * MODEROUND_BIKE_Never+ BMODEROUND_MISS_FShared * MODEROUND_BIKE_Missing

BFacility_RampsRND = BFacility_Ramps + sigma_facility_ramps * bioDraws('BFacility_RampsRND','NORMAL') + BMODEROUND_O_FR * MODEROUND_BIKE_Often + \
                BMODEROUND_A_FR * MODEROUND_BIKE_Always + BMODEROUND_N_FR * MODEROUND_BIKE_Never+ BMODEROUND_MISS_FR * MODEROUND_BIKE_Missing

BLane_1RND = BLane_1 + sigma_lane_1 * bioDraws('BLane_1RND','NORMAL') + BMODEROUND_O_L * MODEROUND_BIKE_Often + \
                BMODEROUND_A_L * MODEROUND_BIKE_Always + BMODEROUND_N_L * MODEROUND_BIKE_Never+ BMODEROUND_MISS_L * MODEROUND_BIKE_Missing

BIsland_smallRND = BIsland_small + sigma_island_small * bioDraws('BIsland_smallRND','NORMAL')  + BMODEROUND_O_I * MODEROUND_BIKE_Often + \
                BMODEROUND_A_I * MODEROUND_BIKE_Always + BMODEROUND_N_I * MODEROUND_BIKE_Never+ BMODEROUND_MISS_I * MODEROUND_BIKE_Missing
                
                 
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
biogeme.modelName = "Seventh"
results = biogeme.estimate(saveIterations=True)
pandasResults = results.getEstimatedParameters()
print(pandasResults) 

               
                
                
