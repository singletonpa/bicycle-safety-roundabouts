# -*- coding: utf-8 -*-
"""
Created on Fri Nov 20 15:57:09 2020

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
df = pd.read_csv('Stated.csv')
df = df.drop(columns=['ResponseId'])
database=db.Database("Stated",df)

database.panel("ID")
globals().update(database.variables)



### Paramter to be estimated, (Here i have provided some initial values for fast calculations)
BIsland_small = Beta('BIsland_small',0.381,None,None,0)
BLane_1 = Beta('BLane_1',1.27,None,None,0)
BFacility_Shared = Beta('BFacility_Shared',1.53, None,None,0)
BFacility_Ramps = Beta('BFacility_Ramps',-0.217,None,None,0)
BFacility_Seperated = Beta('BFacility_Seperated',2.42,None,None,0)
BVolume_Medium = Beta('BVolume_Medium',-0.621,None,None,0)
BVolume_High = Beta('BVolume_High',-1.75,None,None,0)
BSpeed_35 = Beta('BSpeed_35',-0.426,None,None,0)

#We need at least on random parameter for monte carlo
sigma_speed_35 = Beta('sigma_speed_35',0.786, None, None,0)
sigma_volume_high = Beta('sigma_volume_high',0.631,None,None,0)
sigma_volume_medium = Beta('sigma_volume_medium',0.119,None,None,0)
sigma_facility_seperated = Beta('sigma_facility_seperated',3.97,None,None,0)
sigma_facility_ramps = Beta('sigma_facility_ramps',3.34,None,None,0)
sigma_facility_shared = Beta('sigma_facility_shared',1.62,None,None,0)
sigma_lane_1 = Beta('sigma_lane_1',1.62,None,None,0)
sigma_island_small = Beta('sigma_island_small',0.193,None,None,0)



BSpeed_35RND = BSpeed_35 + sigma_speed_35 * bioDraws('BSpeed_35RND','NORMAL')
BVolume_HighRND = BVolume_High + sigma_volume_high * bioDraws('BVolume_HighRND','NORMAL')
BVolume_MediumRND = BVolume_Medium+ sigma_volume_medium * bioDraws('BVolume_MediumRND','NORMAL')
BFacility_SeperatedRND = BFacility_Seperated + sigma_facility_seperated * bioDraws('BFacility_SeperatedRND','NORMAL')
BFacility_RampsRND = BFacility_Ramps + sigma_facility_ramps * bioDraws('BFacility_RampsRND','NORMAL')
BFacility_SharedRND = BFacility_Shared + sigma_facility_shared * bioDraws('BFacility_SharedRND','NORMAL')
BLane_1RND = BLane_1 + sigma_lane_1 * bioDraws('BLane_1RND','NORMAL')
BIsland_smallRND = BIsland_small + sigma_island_small * bioDraws('BIsland_smallRND','NORMAL')
 

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
biogeme.modelName = "MMNL"
results = biogeme.estimate(saveIterations=True)
pandasResults = results.getEstimatedParameters()
print(pandasResults) 




