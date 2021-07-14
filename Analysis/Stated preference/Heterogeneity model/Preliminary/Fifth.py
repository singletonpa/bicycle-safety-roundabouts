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

# Heterogenity Parameters
Bbtype_E_S = Beta('Bbtype_E_S',0,None,None,0)
Bbtype_E_VH = Beta('Bbtype_E_VH',0,None,None,0)
Bbtype_E_VM = Beta('Bbtype_E_VM',0,None,None,0)
Bbtype_E_FSep = Beta('Bbtype_E_FSep',0,None,None,0)
Bbtype_E_FShared = Beta('Bbtype_E_FShared',0,None,None,0)
Bbtype_E_FR = Beta('Bbtype_E_FR',0,None,None,0)
Bbtype_E_L = Beta('Bbtype_E_L',0,None,None,0)
Bbtype_E_I = Beta('Bbtype_E_I',0,None,None,0)

Bbtype_S_S = Beta('Bbtype_S_S',0,None,None,0)
Bbtype_S_VH = Beta('Bbtype_S_VH',0,None,None,0)
Bbtype_S_VM = Beta('Bbtype_S_VM',0,None,None,0)
Bbtype_S_FSep = Beta('Bbtype_S_FSep',0,None,None,0)
Bbtype_S_FShared = Beta('Bbtype_S_FShared',0,None,None,0)
Bbtype_S_FR = Beta('Bbtype_S_FR',0,None,None,0)
Bbtype_S_L = Beta('Bbtype_S_L',0,None,None,0)
Bbtype_S_I = Beta('Bbtype_S_I',0,None,None,0)

Bbtype_Miss_S = Beta('Bbtype_Miss_S',0,None,None,0)
Bbtype_Miss_VH = Beta('Bbtype_Miss_VH',0,None,None,0)
Bbtype_Miss_VM = Beta('Bbtype_Miss_VM',0,None,None,0)
Bbtype_Miss_FSep = Beta('Bbtype_Miss_FSep',0,None,None,0)
Bbtype_Miss_FShared = Beta('Bbtype_Miss_FShared',0,None,None,0)
Bbtype_Miss_FR = Beta('Bbtype_Miss_FR',0,None,None,0)
Bbtype_Miss_L = Beta('Bbtype_Miss_L',0,None,None,0)
Bbtype_Miss_I = Beta('Bbtype_Miss_I',0,None,None,0)


### Random equation
BSpeed_35RND = BSpeed_35 + sigma_speed_35 * bioDraws('BSpeed_35RND','NORMAL') +\
              Bbtype_E_S * btype_E  + Bbtype_S_S * btype_S + Bbtype_Miss_S * btype_M
                

BVolume_HighRND = BVolume_High + sigma_volume_high * bioDraws('BVolume_HighRND','NORMAL')  +\
                Bbtype_E_VH * btype_E  + Bbtype_S_VH * btype_S + Bbtype_Miss_VH * btype_M
                
                
BVolume_MediumRND = BVolume_Medium+ sigma_volume_medium * bioDraws('BVolume_MediumRND','NORMAL') +\
                Bbtype_E_VM * btype_E  + Bbtype_S_VM * btype_S + Bbtype_Miss_VM * btype_M
                
                
BFacility_SeperatedRND = BFacility_Seperated + sigma_facility_seperated * bioDraws('BFacility_SeperatedRND','NORMAL') +\
                Bbtype_E_FSep * btype_E + Bbtype_S_FSep * btype_S + Bbtype_Miss_FSep * btype_M
                

BFacility_SharedRND = BFacility_Shared + sigma_facility_shared * bioDraws('BFacility_SharedRND','NORMAL') +\
               Bbtype_E_FShared * btype_E + Bbtype_S_FShared * btype_S + Bbtype_Miss_FShared * btype_M
                

BFacility_RampsRND = BFacility_Ramps + sigma_facility_ramps * bioDraws('BFacility_RampsRND','NORMAL')+\
               Bbtype_E_FR * btype_E  + Bbtype_S_FR * btype_S + Bbtype_Miss_FR * btype_M
                

BLane_1RND = BLane_1 + sigma_lane_1 * bioDraws('BLane_1RND','NORMAL') +\
                Bbtype_E_L * btype_E  + Bbtype_S_L * btype_S + Bbtype_Miss_L * btype_M

BIsland_smallRND = BIsland_small + sigma_island_small * bioDraws('BIsland_smallRND','NORMAL') +\
                Bbtype_E_I * btype_E + Bbtype_S_I * btype_S + Bbtype_Miss_I * btype_M

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
biogeme.modelName = "Fifth"
results = biogeme.estimate(saveIterations=True)
pandasResults = results.getEstimatedParameters()
print(pandasResults) 

