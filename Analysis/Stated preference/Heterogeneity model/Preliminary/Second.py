# -*- coding: utf-8 -*-
"""
Created on Thu May 13 16:45:10 2021

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

### Heterogenity parameters
BInc50_S = Beta('BInc50_S',-0.277,None,None,0)
BInc50_VH = Beta('BInc50_VH',0.388,None,None,0)
BInc50_VM = Beta('BInc50_VM',0.312,None,None,0)
BInc50_FSep = Beta('BInc50_FSep',0.322,None,None,0)
BInc50_FShared = Beta('BInc50_FShared',0.991,None,None,0)
BInc50_FR = Beta('BInc50_FR',0.595,None,None,0)
BInc50_L = Beta('BInc50_L',-0.803,None,None,0)
BInc50_I = Beta('BInc50_I',0.113,None,None,0)

BInc5075_S = Beta('BInc5075_S',-0.586,None,None,0)
BInc5075_VH = Beta('BInc5075_VH',-0.558,None,None,0)
BInc5075_VM = Beta('BInc5075_VM',0.847,None,None,0)
BInc5075_FSep = Beta('BInc5075_FSep',0.608,None,None,0)
BInc5075_FShared = Beta('BInc5075_FShared',0.595,None,None,0)
BInc5075_FR = Beta('BInc5075_FR',-0.0917,None,None,0)
BInc5075_L = Beta('BInc5075_L',	0.984,None,None,0)
BInc5075_I = Beta('BInc5075_I',0.646,None,None,0)

BInc75100_S = Beta('BInc75100_S',-0.586,None,None,0)
BInc75100_VH = Beta('BInc75100_VH',-0.558,None,None,0)
BInc75100_VM = Beta('BInc75100_VM',0.847,None,None,0)
BInc75100_FSep = Beta('BInc75100_FSep',0.608,None,None,0)
BInc75100_FShared = Beta('BInc75100_FShared',0.595,None,None,0)
BInc75100_FR = Beta('BInc75100_FR',-0.0917,None,None,0)
BInc75100_L = Beta('BInc75100_L',	0.984,None,None,0)
BInc75100_I = Beta('BInc75100_I',0.646,None,None,0)

BInc100150_S = Beta('BInc100150_S',-0.215,None,None,0)
BInc100150_VH = Beta('BInc100150_VH',-0.215,None,None,0)
BInc100150_VM = Beta('BInc100150_VM',0.245,None,None,0)
BInc100150_FSep = Beta('BInc100150_FSep',0.695,None,None,0)
BInc100150_FShared = Beta('BInc100150_FShared',0.837,None,None,0)
BInc100150_FR = Beta('BInc100150_FR',0.417,None,None,0)
BInc100150_L = Beta('BInc100150_L',0.32,None,None,0)
BInc100150_I = Beta('BInc100150_I',-0.188,None,None,0)

BInc_Missing_S = Beta('BInc_Missing_S',-0.215,None,None,0)
BInc_Missing_VH = Beta('BInc_Missing_VH',-0.215,None,None,0)
BInc_Missing_VM = Beta('BInc_Missing_VM',0.245,None,None,0)
BInc_Missing_FSep = Beta('BInc_Missing_FSep',0.695,None,None,0)
BInc_Missing_FShared = Beta('BInc_Missing_FShared',0.837,None,None,0)
BInc_Missing_FR = Beta('BInc_Missing_FR',0.417,None,None,0)
BInc_Missing_L = Beta('BInc_Missing_L',0.32,None,None,0)
BInc_Missing_I = Beta('BInc_Missing_I',-0.188,None,None,0)


BSpeed_35RND = BSpeed_35 + sigma_speed_35 * bioDraws('BSpeed_35RND','NORMAL')  + BInc50_S * HHINC_50  + \
                BInc5075_S * HHINC_50_75 + BInc75100_S * HHINC_75_100 + BInc100150_S * HHINC_100_150 + \
                BInc_Missing_S * HHINC_Missing

BVolume_HighRND = BVolume_High + sigma_volume_high * bioDraws('BVolume_HighRND','NORMAL') + BInc50_VH * HHINC_50  + \
                BInc5075_VH * HHINC_50_75 + BInc75100_VH * HHINC_75_100 + BInc100150_VH * HHINC_100_150 + \
               BInc_Missing_VH * HHINC_Missing
                
BVolume_MediumRND = BVolume_Medium+ sigma_volume_medium * bioDraws('BVolume_MediumRND','NORMAL') + BInc50_VM * HHINC_50  + \
                BInc5075_VM * HHINC_50_75 + BInc75100_VM * HHINC_75_100 + BInc100150_VM * HHINC_100_150 + \
                BInc_Missing_VM * HHINC_Missing
                
BFacility_SeperatedRND = BFacility_Seperated + sigma_facility_seperated * bioDraws('BFacility_SeperatedRND','NORMAL') + BInc50_FSep * HHINC_50  + \
                BInc5075_FSep * HHINC_50_75 + BInc75100_FSep * HHINC_75_100 + BInc100150_FSep * HHINC_100_150 + \
                BInc_Missing_FSep * HHINC_Missing

BFacility_SharedRND = BFacility_Shared + sigma_facility_shared * bioDraws('BFacility_SharedRND','NORMAL') + BInc50_FShared * HHINC_50 + \
                BInc5075_FShared * HHINC_50_75 + BInc75100_FShared * HHINC_75_100 + BInc100150_FShared * HHINC_100_150 + \
                BInc_Missing_FShared * HHINC_Missing

BFacility_RampsRND = BFacility_Ramps + sigma_facility_ramps * bioDraws('BFacility_RampsRND','NORMAL')  + BInc50_FR * HHINC_50  + \
                BInc5075_FR * HHINC_50_75 + BInc75100_FR * HHINC_75_100 + BInc100150_FR * HHINC_100_150 + \
                BInc_Missing_FR * HHINC_Missing

BLane_1RND = BLane_1 + sigma_lane_1 * bioDraws('BLane_1RND','NORMAL') + BInc50_L * HHINC_50  + \
                BInc5075_L * HHINC_50_75 + BInc75100_L * HHINC_75_100 + BInc100150_L * HHINC_100_150 + \
                BInc_Missing_L * HHINC_Missing

BIsland_smallRND = BIsland_small + sigma_island_small * bioDraws('BIsland_smallRND','NORMAL') + BInc50_I * HHINC_50  + \
                BInc5075_I * HHINC_50_75 + BInc75100_I * HHINC_75_100 + BInc100150_I * HHINC_100_150 + \
                BInc_Missing_I * HHINC_Missing
                

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
biogeme.modelName = "Second"
results = biogeme.estimate(saveIterations=True)
pandasResults = results.getEstimatedParameters()
print(pandasResults) 
                


