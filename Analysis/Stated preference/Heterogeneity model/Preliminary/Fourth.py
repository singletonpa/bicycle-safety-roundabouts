# -*- coding: utf-8 -*-
"""
Created on Thu May 13 17:15:14 2021

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
BGENDF_S = Beta('BGENDF_S',0,None,None,0)
BGENDF_VH = Beta('BGENDF_VH',0,None,None,0)
BGENDF_VM = Beta('BGENDF_VM',0,None,None,0)
BGENDF_FSep = Beta('BGENDF_FSep',0,None,None,0)
BGENDF_FShared = Beta('BGENDF_FShared',0,None,None,0)
BGENDF_FR = Beta('BGENDF_FR',0,None,None,0)
BGENDF_L = Beta('BGENDF_L',0,None,None,0)
BGENDF_I = Beta('BGENDF_I',0,None,None,0)

BGENDMiss_S = Beta('BGENDMiss_S',0,None,None,0)
BGENDMiss_VH = Beta('BGENDMiss_VH',0,None,None,0)
BGENDMiss_VM = Beta('BGENDMiss_VM',0,None,None,0)
BGENDMiss_FSep = Beta('BGENDMiss_FSep',0,None,None,0)
BGENDMiss_FShared = Beta('BGENDMiss_FShared',0,None,None,0)
BGENDMiss_FR = Beta('BGENDMiss_FR',0,None,None,0)
BGENDMiss_L = Beta('BGENDMiss_L',0,None,None,0)
BGENDMiss_I = Beta('BGENDMiss_I',0,None,None,0)

BEDUC_B_S = Beta('BEDUC_B_S',0,None,None,0)
BEDUC_B_VH = Beta('BEDUC_B_VH',0,None,None,0)
BEDUC_B_VM = Beta('BEDUC_B_VM',0,None,None,0)
BEDUC_B_FSep = Beta('BEDUC_B_FSep',0,None,None,0)
BEDUC_B_FShared = Beta('BEDUC_B_FShared',0,None,None,0)
BEDUC_B_FR = Beta('BEDUC_B_FR',0,None,None,0)
BEDUC_B_L = Beta('BEDUC_B_L',0,None,None,0)
BEDUC_B_I = Beta('BEDUC_B_I',0,None,None,0)

BEDUC_LB_S = Beta('BEDUC_LB_S',0,None,None,0)
BEDUC_LB_VH = Beta('BEDUC_LB_VH',0,None,None,0)
BEDUC_LB_VM = Beta('BEDUC_LB_VM',0,None,None,0)
BEDUC_LB_FSep = Beta('BEDUC_LB_FSep',0,None,None,0)
BEDUC_LB_FShared = Beta('BEDUC_LB_FShared',0,None,None,0)
BEDUC_LB_FR = Beta('BEDUC_LB_FR',0,None,None,0)
BEDUC_LB_L = Beta('BEDUC_LB_L',0,None,None,0)
BEDUC_LB_I = Beta('BEDUC_LB_I',0,None,None,0)

BEDUC_Miss_S = Beta('BEDUC_Miss_S',0,None,None,0)
BEDUC_Miss_VH = Beta('BEDUC_Miss_VH',0,None,None,0)
BEDUC_Miss_VM = Beta('BEDUC_Miss_VM',0,None,None,0)
BEDUC_Miss_FSep = Beta('BEDUC_Miss_FSep',0,None,None,0)
BEDUC_Miss_FShared = Beta('BEDUC_Miss_FShared',0,None,None,0)
BEDUC_Miss_FR = Beta('BEDUC_Miss_FR',0,None,None,0)
BEDUC_Miss_L = Beta('BEDUC_Miss_L',0,None,None,0)
BEDUC_Miss_I = Beta('BEDUC_Miss_I',0,None,None,0)


### Random equation
BSpeed_35RND = BSpeed_35 + sigma_speed_35 * bioDraws('BSpeed_35RND','NORMAL') +\
               BGENDF_S * GEND_Female + BGENDMiss_S * GEND_Missing + BEDUC_B_S * EDUC_Bach +\
               BEDUC_LB_S * EDUC_LessBAc + BEDUC_Miss_S * EDUC_Missing 
                

BVolume_HighRND = BVolume_High + sigma_volume_high * bioDraws('BVolume_HighRND','NORMAL')  +\
                BGENDF_VH * GEND_Female + BGENDMiss_VH * GEND_Missing + BEDUC_B_VH * EDUC_Bach +\
               BEDUC_LB_VH * EDUC_LessBAc + BEDUC_Miss_VH * EDUC_Missing
                
                
BVolume_MediumRND = BVolume_Medium+ sigma_volume_medium * bioDraws('BVolume_MediumRND','NORMAL') +\
                BGENDF_VM * GEND_Female + BGENDMiss_VM * GEND_Missing + BEDUC_B_VM * EDUC_Bach +\
               BEDUC_LB_VM * EDUC_LessBAc + BEDUC_Miss_VM * EDUC_Missing
                
                
BFacility_SeperatedRND = BFacility_Seperated + sigma_facility_seperated * bioDraws('BFacility_SeperatedRND','NORMAL') +\
                BGENDF_FSep * GEND_Female + BGENDMiss_FSep * GEND_Missing + BEDUC_B_FSep * EDUC_Bach +\
               BEDUC_LB_FSep * EDUC_LessBAc + BEDUC_Miss_FSep * EDUC_Missing
                

BFacility_SharedRND = BFacility_Shared + sigma_facility_shared * bioDraws('BFacility_SharedRND','NORMAL') +\
               BGENDF_FShared * GEND_Female + BGENDMiss_FShared * GEND_Missing + BEDUC_B_FShared * EDUC_Bach +\
               BEDUC_LB_FShared * EDUC_LessBAc + BEDUC_Miss_FShared * EDUC_Missing
                

BFacility_RampsRND = BFacility_Ramps + sigma_facility_ramps * bioDraws('BFacility_RampsRND','NORMAL')+\
                BGENDF_FR * GEND_Female + BGENDMiss_FR * GEND_Missing + BEDUC_B_FR * EDUC_Bach +\
               BEDUC_LB_FR * EDUC_LessBAc + BEDUC_Miss_FR * EDUC_Missing
                

BLane_1RND = BLane_1 + sigma_lane_1 * bioDraws('BLane_1RND','NORMAL') +\
                BGENDF_L * GEND_Female + BGENDMiss_L * GEND_Missing + BEDUC_B_L * EDUC_Bach +\
               BEDUC_LB_L * EDUC_LessBAc + BEDUC_Miss_L * EDUC_Missing
                

BIsland_smallRND = BIsland_small + sigma_island_small * bioDraws('BIsland_smallRND','NORMAL') +\
                BGENDF_I * GEND_Female + BGENDMiss_I * GEND_Missing + BEDUC_B_I * EDUC_Bach +\
               BEDUC_LB_I * EDUC_LessBAc + BEDUC_Miss_I * EDUC_Missing
                

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
biogeme.modelName = "Fourth"
results = biogeme.estimate(saveIterations=True)
pandasResults = results.getEstimatedParameters()
print(pandasResults) 
