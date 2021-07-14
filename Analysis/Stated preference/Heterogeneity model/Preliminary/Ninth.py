# -*- coding: utf-8 -*-
"""
Created on Thu May 13 18:30:10 2021

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

## New added variables
BBIKES_S = Beta ('BBIKES_S', 0, None, None, 0)
BBIKES_VH = Beta ('BBIKES_VH', 0, None, None, 0)
BBIKES_VM = Beta ('BBIKES_VM', 0, None, None, 0)
BBIKES_FSep = Beta ('BBIKES_FSep', 0, None, None, 0)
BBIKES_FShared = Beta ('BBIKES_FShared', 0, None, None, 0)
BBIKES_FR = Beta ('BBIKES_FR', 0, None, None, 0)
BBIKES_L = Beta ('BBIKES_L', 0, None, None, 0)
BBIKES_I = Beta ('BBIKES_I', 0, None, None, 0)

BCARS_S = Beta ('BCARS_S', 0, None, None, 0)
BCARS_VH = Beta ('BCARS_VH', 0, None, None, 0)
BCARS_VM = Beta ('BCARS_VM', 0, None, None, 0)
BCARS_FSep = Beta ('BCARS_FSep', 0, None, None, 0)
BCARS_FShared = Beta ('BCARS_FShared', 0, None, None, 0)
BCARS_FR = Beta ('BCARS_FR', 0, None, None, 0)
BCARS_L = Beta ('BCARS_L', 0, None, None, 0)
BCARS_I = Beta ('BCARS_I', 0, None, None, 0)

BADULT_S = Beta ('BADULT_S', 0, None, None, 0)
BADULT_VH = Beta ('BADULT_VH', 0, None, None, 0)
BADULT_VM = Beta ('BADULT_VM', 0, None, None, 0)
BADULT_FSep = Beta ('BADULT_FSep', 0, None, None, 0)
BADULT_FShared = Beta ('BADULT_FShared', 0, None, None, 0)
BADULT_FR = Beta ('BADULT_FR', 0, None, None, 0)
BADULT_L = Beta ('BADULT_L', 0, None, None, 0)
BADULT_I = Beta ('BADULT_I', 0, None, None, 0)

BCHILD_S = Beta ('BCHILD_S', 0, None, None, 0)
BCHILD_VH = Beta ('BCHILD_VH', 0, None, None, 0)
BCHILD_VM = Beta ('BCHILD_VM', 0, None, None, 0)
BCHILD_FSep = Beta ('BCHILD_FSep', 0, None, None, 0)
BCHILD_FShared = Beta ('BCHILD_FShared', 0, None, None, 0)
BCHILD_FR = Beta ('BCHILD_FR', 0, None, None, 0)
BCHILD_L = Beta ('BCHILD_L', 0, None, None, 0)
BCHILD_I = Beta ('BCHILD_I', 0, None, None, 0)

BADULTMiss_S = Beta ('BADULTMiss_S', 0, None, None, 0)
BADULTMiss_VH = Beta ('BADULTMiss_VH', 0, None, None, 0)
BADULTMiss_VM = Beta ('BADULTMiss_VM', 0, None, None, 0)
BADULTMiss_FSep = Beta ('BADULTMiss_FSep', 0, None, None, 0)
BADULTMiss_FShared = Beta ('BADULTMiss_FShared', 0, None, None, 0)
BADULTMiss_FR = Beta ('BADULTMiss_FR', 0, None, None, 0)
BADULTMiss_L = Beta ('BADULTMiss_L', 0, None, None, 0)
BADULTMiss_I = Beta ('BADULTMiss_I', 0, None, None, 0)


BSpeed_35RND = BSpeed_35 + sigma_speed_35 * bioDraws('BSpeed_35RND','NORMAL') + \
                BBIKES_S * BIKES + BCARS_S * CARS + BADULT_S * ADULT + BCHILD_S * CHILD + BADULTMiss_S * ADULT_Miss

BVolume_HighRND = BVolume_High + sigma_volume_high * bioDraws('BVolume_HighRND','NORMAL')  + \
                BBIKES_VH * BIKES + BCARS_VH * CARS + BADULT_VH * ADULT + BCHILD_VH * CHILD + BADULTMiss_VH * ADULT_Miss
                
BVolume_MediumRND = BVolume_Medium+ sigma_volume_medium * bioDraws('BVolume_MediumRND','NORMAL')+ \
                BBIKES_VM * BIKES + BCARS_VM * CARS + BADULT_VM * ADULT + BCHILD_VM * CHILD+ BADULTMiss_VM * ADULT_Miss
                
BFacility_SeperatedRND = BFacility_Seperated + sigma_facility_seperated * bioDraws('BFacility_SeperatedRND','NORMAL') + \
                BBIKES_FSep * BIKES + BCARS_FSep * CARS + BADULT_FSep * ADULT + BCHILD_FSep * CHILD+ BADULTMiss_FSep * ADULT_Miss
                            
BFacility_SharedRND = BFacility_Shared + sigma_facility_shared * bioDraws('BFacility_SharedRND','NORMAL') + \
                BBIKES_FShared * BIKES + BCARS_FShared * CARS + BADULT_FShared * ADULT + BCHILD_FShared * CHILD+ BADULTMiss_FShared * ADULT_Miss
                
                            
BFacility_RampsRND = BFacility_Ramps + sigma_facility_ramps * bioDraws('BFacility_RampsRND','NORMAL') + \
                BBIKES_FR * BIKES + BCARS_FR * CARS + BADULT_FR * ADULT + BCHILD_FR * CHILD + BADULTMiss_FR * ADULT_Miss
                
                           
BLane_1RND = BLane_1 + sigma_lane_1 * bioDraws('BLane_1RND','NORMAL') +\
                BBIKES_L * BIKES + BCARS_L * CARS + BADULT_L * ADULT + BCHILD_L * CHILD  + BADULTMiss_L * ADULT_Miss

BIsland_smallRND = BIsland_small + sigma_island_small * bioDraws('BIsland_smallRND','NORMAL') + \
                BBIKES_I * BIKES + BCARS_I * CARS + BADULT_I * ADULT + BCHILD_I * CHILD + BADULTMiss_I * ADULT_Miss


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
biogeme.modelName = "Ninth"
results = biogeme.estimate(saveIterations=True)
pandasResults = results.getEstimatedParameters()
print(pandasResults)                 
                
                
               