# -*- coding: utf-8 -*-
"""
Created on Thu May 13 16:58:43 2021

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
BCrash_S = Beta('BCrash_S',0,None,None,0)
BCrash_VH = Beta('BCrash_VH',0,None,None,0)
BCrash_VM = Beta('BCrash_VM',0,None,None,0)
BCrash_FSep = Beta('BCrash_FSep',0,None,None,0)
BCrash_FShared = Beta('BCrash_FShared',0,None,None,0)
BCrash_FR = Beta('BCrash_FR',0,None,None,0)
BCrash_L = Beta('BCrash_L',0,None,None,0)
BCrash_I = Beta('BCrash_I',0,None,None,0)

BRaceOther_S = Beta('BRaceOther_S',0,None,None,0)
BRaceOther_VH = Beta('BRaceOther_VH',0,None,None,0)
BRaceOther_VM = Beta('BRaceOther_VM',0,None,None,0)
BRaceOther_FSep = Beta('BRaceOther_FSep',0,None,None,0)
BRaceOther_FShared = Beta('BRaceOther_FShared',0,None,None,0)
BRaceOther_FR = Beta('BRaceOther_FR',0,None,None,0)
BRaceOther_L = Beta('BRaceOther_L',0,None,None,0)
BRaceOther_I = Beta('BRaceOther_I',0,None,None,0)

BStudY_S = Beta('BStudY_S',0,None,None,0)
BStudY_VH = Beta('BStudY_VH',0,None,None,0)
BStudY_VM = Beta('BStudY_VM',0,None,None,0)
BStudY_FSep = Beta('BStudY_FSep',0,None,None,0)
BStudY_FShared = Beta('BStudY_FShared',0,None,None,0)
BStudY_FR = Beta('BStudY_FR',0,None,None,0)
BStudY_L = Beta('BStudY_L',0,None,None,0)
BStudY_I = Beta('BStudY_I',0,None,None,0)


BWorkN_S = Beta('BWorkN_S',0,None,None,0)
BWorkN_VH = Beta('BWorkN_VH',0,None,None,0)
BWorkN_VM = Beta('BWorkN_VM',0,None,None,0)
BWorkN_FSep = Beta('BWorkN_FSep',0,None,None,0)
BWorkN_FShared = Beta('BWorkN_FShared',0,None,None,0)
BWorkN_FR = Beta('BWorkN_FR',0,None,None,0)
BWorkN_L = Beta('BWorkN_L',0,None,None,0)
BWorkN_I = Beta('BWorkN_I',0,None,None,0)


### Random equation
BSpeed_35RND = BSpeed_35 + sigma_speed_35 * bioDraws('BSpeed_35RND','NORMAL') +\
                BCrash_S * Crash + BRaceOther_S * RaceOther + BStudY_S * STUD_Yes +\
                BWorkN_S * WORK_No 
                

BVolume_HighRND = BVolume_High + sigma_volume_high * bioDraws('BVolume_HighRND','NORMAL')  +\
                BCrash_VH * Crash + BRaceOther_VH * RaceOther + BStudY_VH * STUD_Yes +\
                 BWorkN_VH * WORK_No 
                
                
BVolume_MediumRND = BVolume_Medium+ sigma_volume_medium * bioDraws('BVolume_MediumRND','NORMAL') +\
                BCrash_VM * Crash + BRaceOther_VM * RaceOther + BStudY_VM * STUD_Yes +\
                BWorkN_VM * WORK_No 
                
                
BFacility_SeperatedRND = BFacility_Seperated + sigma_facility_seperated * bioDraws('BFacility_SeperatedRND','NORMAL') +\
                BCrash_FSep * Crash + BRaceOther_FSep * RaceOther + BStudY_FSep * STUD_Yes +\
                BWorkN_FSep * WORK_No 
                

BFacility_SharedRND = BFacility_Shared + sigma_facility_shared * bioDraws('BFacility_SharedRND','NORMAL') +\
                BCrash_FShared * Crash + BRaceOther_FShared * RaceOther + BStudY_FShared * STUD_Yes +\
                BWorkN_FShared * WORK_No 
                

BFacility_RampsRND = BFacility_Ramps + sigma_facility_ramps * bioDraws('BFacility_RampsRND','NORMAL')+\
                BCrash_FR * Crash + BRaceOther_FR * RaceOther + BStudY_FR * STUD_Yes +\
                BWorkN_FR * WORK_No 
                

BLane_1RND = BLane_1 + sigma_lane_1 * bioDraws('BLane_1RND','NORMAL') +\
                BCrash_L * Crash + BRaceOther_L * RaceOther + BStudY_L * STUD_Yes +\
                BWorkN_L * WORK_No 
                

BIsland_smallRND = BIsland_small + sigma_island_small * bioDraws('BIsland_smallRND','NORMAL') +\
                BCrash_I * Crash + BRaceOther_I * RaceOther + BStudY_I * STUD_Yes +\
                BWorkN_I * WORK_No 
                

               

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
biogeme.modelName = "Third"
results = biogeme.estimate(saveIterations=True)
pandasResults = results.getEstimatedParameters()
print(pandasResults) 
                




