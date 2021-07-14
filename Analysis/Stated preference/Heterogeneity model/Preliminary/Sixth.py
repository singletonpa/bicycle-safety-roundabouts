# -*- coding: utf-8 -*-
"""
Created on Thu May 13 17:57:32 2021

@author: Niranjan.p
"""

# -*- coding: utf-8 -*-
"""
Created on Thu May 13 17:29:36 2021

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

BBUseF_S = Beta('BBUseF_S',0,None,None,0)
BBUseF_VH = Beta('BBUseF_VH',0,None,None,0)
BBUseF_VM = Beta('BBUseF_VM',0,None,None,0)
BBUseF_FSep = Beta('BBUseF_FSep',0,None,None,0)
BBUseF_FShared = Beta('BBUseF_FShared',0,None,None,0)
BBUseF_FR = Beta('BBUseF_FR',0,None,None,0)
BBUseF_L = Beta('BBUseF_L',0,None,None,0)
BBUseF_I = Beta('BBUseF_I',0,None,None,0)

BBUseW_S = Beta('BBUseW_S',0,None,None,0)
BBUseW_VH = Beta('BBUseW_VH',0,None,None,0)
BBUseW_VM = Beta('BBUseW_VM',0,None,None,0)
BBUseW_FSep = Beta('BBUseW_FSep',0,None,None,0)
BBUseW_FShared = Beta('BBUseW_FShared',0,None,None,0)
BBUseW_FR = Beta('BBUseW_FR',0,None,None,0)
BBUseW_L = Beta('BBUseW_L',0,None,None,0)
BBUseW_I = Beta('BBUseW_I',0,None,None,0)

BBUseN_S = Beta('BBUseN_S',0,None,None,0)
BBUseN_VH = Beta('BBUseN_VH',0,None,None,0)
BBUseN_VM = Beta('BBUseN_VM',0,None,None,0)
BBUseN_FSep = Beta('BBUseN_FSep',0,None,None,0)
BBUseN_FShared = Beta('BBUseN_FShared',0,None,None,0)
BBUseN_FR = Beta('BBUseN_FR',0,None,None,0)
BBUseN_L = Beta('BBUseN_L',0,None,None,0)
BBUseN_I = Beta('BBUseN_I',0,None,None,0)


BSpeed_35RND = BSpeed_35 + sigma_speed_35 * bioDraws('BSpeed_35RND','NORMAL') + \
                BBUseF_S * MODEUSE2_BIKE_Few + BBUseW_S * MODEUSE2_BIKE_Week + BBUseN_S * MODEUSE2_BIKE_Never 
                

BVolume_HighRND = BVolume_High + sigma_volume_high * bioDraws('BVolume_HighRND','NORMAL')  + \
                BBUseF_VH * MODEUSE2_BIKE_Few + BBUseW_VH * MODEUSE2_BIKE_Week + BBUseN_VH * MODEUSE2_BIKE_Never 
                
                
BVolume_MediumRND = BVolume_Medium+ sigma_volume_medium * bioDraws('BVolume_MediumRND','NORMAL')+ \
                BBUseF_VM * MODEUSE2_BIKE_Few + BBUseW_VM * MODEUSE2_BIKE_Week + BBUseN_VM * MODEUSE2_BIKE_Never 
                
                
BFacility_SeperatedRND = BFacility_Seperated + sigma_facility_seperated * bioDraws('BFacility_SeperatedRND','NORMAL') + \
                BBUseF_FSep * MODEUSE2_BIKE_Few + BBUseW_FSep * MODEUSE2_BIKE_Week + BBUseN_FSep * MODEUSE2_BIKE_Never 
                

BFacility_SharedRND = BFacility_Shared + sigma_facility_shared * bioDraws('BFacility_SharedRND','NORMAL') + \
                BBUseF_FShared * MODEUSE2_BIKE_Few + BBUseW_FShared * MODEUSE2_BIKE_Week + BBUseN_FShared * MODEUSE2_BIKE_Never
                

BFacility_RampsRND = BFacility_Ramps + sigma_facility_ramps * bioDraws('BFacility_RampsRND','NORMAL') + \
                BBUseF_FR * MODEUSE2_BIKE_Few + BBUseW_FR * MODEUSE2_BIKE_Week + BBUseN_FR * MODEUSE2_BIKE_Never
                
BLane_1RND = BLane_1 + sigma_lane_1 * bioDraws('BLane_1RND','NORMAL') + \
                BBUseF_L * MODEUSE2_BIKE_Few + BBUseW_L * MODEUSE2_BIKE_Week + BBUseN_L * MODEUSE2_BIKE_Never


BIsland_smallRND = BIsland_small + sigma_island_small * bioDraws('BIsland_smallRND','NORMAL') + \
                BBUseF_I * MODEUSE2_BIKE_Few + BBUseW_I * MODEUSE2_BIKE_Week + BBUseN_I * MODEUSE2_BIKE_Never
                
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
biogeme.modelName = "Sixth"
results = biogeme.estimate(saveIterations=True)
pandasResults = results.getEstimatedParameters()
print(pandasResults) 

