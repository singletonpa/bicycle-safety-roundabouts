# -*- coding: utf-8 -*-
"""
Created on Thu May 13 16:33:41 2021

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
BAge_25_S = Beta('BAge_25_S',-0.206,None,None,0)
BAge_25_VH = Beta('BAge_25_VH',-0.988,None,None,0)
BAge_25_VM = Beta('BAge_25_VM',0.0844,None,None,0)
BAge_25_FSep = Beta('BAge_25_FSep',3.2,None,None,0)
BAge_25_FShared = Beta('BAge_25_FShared',1.02,None,None,0)
BAge_25_FR = Beta('BAge_25_FR',2.93,None,None,0)
BAge_25_L = Beta('BAge_25_L',0.0455,None,None,0)
BAge_25_I = Beta('BAge_25_I',1.1,None,None,0)

BAge_2534_S = Beta('BAge_2534_S',-0.0353,None,None,0)
BAge_2534_VH = Beta('BAge_2534_VH',-0.453,None,None,0)
BAge_2534_VM = Beta('BAge_2534_VM',-0.38,None,None,0)
BAge_2534_FSep = Beta('BAge_2534_FSep',2.46,None,None,0)
BAge_2534_FShared = Beta('BAge_2534_FShared',0.764,None,None,0)
BAge_2534_FR = Beta('BAge_2534_FR',0.706,None,None,0)
BAge_2534_L = Beta('BAge_2534_L',0.945,None,None,0)
BAge_2534_I = Beta('BAge_2534_I',0.0779,None,None,0)

BAge_3544_S = Beta('BAge_3544_S',-0.0125,None,None,0)
BAge_3544_VH = Beta('BAge_3544_VH',-0.133,None,None,0)
BAge_3544_VM = Beta('BAge_3544_VM',-0.0583,None,None,0)
BAge_3544_FSep = Beta('BAge_3544_FSep',1.95,None,None,0)
BAge_3544_FShared = Beta('BAge_3544_FShared',0.346,None,None,0)
BAge_3544_FR = Beta('BAge_3544_FR',0.857,None,None,0)
BAge_3544_L = Beta('BAge_3544_L',-0.0388,None,None,0)
BAge_3544_I = Beta('BAge_3544_I',0.755	,None,None,0)

BAge_4554_S = Beta('BAge_4554_S',0.228,None,None,0)
BAge_4554_VH = Beta('BAge_4554_VH',0.236,None,None,0)
BAge_4554_VM = Beta('BAge_4554_VM',1.08,None,None,0)
BAge_4554_FSep = Beta('BAge_4554_FSep',1.58,None,None,0)
BAge_4554_FShared = Beta('BAge_4554_FShared',0.808,None,None,0)
BAge_4554_FR = Beta('BAge_4554_FR',0.834,None,None,0)
BAge_4554_L = Beta('BAge_4554_L',0.919,None,None,0)
BAge_4554_I = Beta('BAge_4554_I',0.554,None,None,0)

BAge_65_S = Beta('BAge_65_S',0.228,None,None,0)
BAge_65_VH = Beta('BAge_65_VH',0.236,None,None,0)
BAge_65_VM = Beta('BAge_65_VM',1.08,None,None,0)
BAge_65_FSep = Beta('BAge_65_FSep',1.58,None,None,0)
BAge_65_FShared = Beta('BAge_65_FShared',0.808,None,None,0)
BAge_65_FR = Beta('BAge_65_FR',0.834,None,None,0)
BAge_65_L = Beta('BAge_65_L',0.919,None,None,0)
BAge_65_I = Beta('BAge_65_I',0.554,None,None,0)

BAge_Missing_S = Beta('BAge_Missing_S',0.228,None,None,0)
BAge_Missing_VH = Beta('BAge_Missing_VH',0.236,None,None,0)
BAge_Missing_VM = Beta('BAge_Missing_VM',1.08,None,None,0)
BAge_Missing_FSep = Beta('BAge_Missing_FSep',1.58,None,None,0)
BAge_Missing_FShared = Beta('BAge_Missing_FShared',0.808,None,None,0)
BAge_Missing_FR = Beta('BAge_Missing_FR',0.834,None,None,0)
BAge_Missing_L = Beta('BAge_Missing_L',0.919,None,None,0)
BAge_Missing_I = Beta('BAge_Missing_I',0.554,None,None,0)

### Random parameters

BSpeed_35RND = BSpeed_35 + sigma_speed_35 * bioDraws('BSpeed_35RND','NORMAL') + \
                BAge_25_S * AGE_25 + BAge_2534_S * AGE_25_34 + BAge_3544_S * AGE_35_44 \
                + BAge_4554_S * AGE_45_54 + BAge_65_S * AGE_65 + BAge_Missing_S * AGE_Missing
                
BVolume_HighRND = BVolume_High + sigma_volume_high * bioDraws('BVolume_HighRND','NORMAL')  + \
                BAge_25_VH * AGE_25 + BAge_2534_VH * AGE_25_34 + BAge_3544_VH * AGE_35_44 \
                + BAge_4554_VH * AGE_45_54 + BAge_65_VH * AGE_65 + BAge_Missing_VH * AGE_Missing
                
BVolume_MediumRND = BVolume_Medium+ sigma_volume_medium * bioDraws('BVolume_MediumRND','NORMAL')+ \
                BAge_25_VM * AGE_25 + BAge_2534_VM * AGE_25_34 + BAge_3544_VM * AGE_35_44 \
                + BAge_4554_VM * AGE_45_54 + BAge_65_VM * AGE_65 + BAge_Missing_VM * AGE_Missing
                
BFacility_SeperatedRND = BFacility_Seperated + sigma_facility_seperated * bioDraws('BFacility_SeperatedRND','NORMAL') + \
                BAge_25_FSep * AGE_25 + BAge_2534_FSep * AGE_25_34 + BAge_3544_FSep * AGE_35_44 \
                + BAge_4554_FSep * AGE_45_54 + BAge_65_FSep * AGE_65 + BAge_Missing_FSep* AGE_Missing

BFacility_SharedRND = BFacility_Shared + sigma_facility_shared * bioDraws('BFacility_SharedRND','NORMAL') + \
                BAge_25_FShared * AGE_25 + BAge_2534_FShared * AGE_25_34 + BAge_3544_FShared * AGE_35_44 \
                + BAge_4554_FShared * AGE_45_54 + BAge_65_FShared * AGE_65 + BAge_Missing_FShared * AGE_Missing
                
BFacility_RampsRND = BFacility_Ramps + sigma_facility_ramps * bioDraws('BFacility_RampsRND','NORMAL') + \
                BAge_25_FR * AGE_25 + BAge_2534_FR * AGE_25_34 + BAge_3544_FR * AGE_35_44 \
                + BAge_4554_FR * AGE_45_54 + BAge_65_FR * AGE_65 + BAge_Missing_FR * AGE_Missing

BLane_1RND = BLane_1 + sigma_lane_1 * bioDraws('BLane_1RND','NORMAL') + \
                BAge_25_L * AGE_25 + BAge_2534_L * AGE_25_34 + BAge_3544_L * AGE_35_44 \
                + BAge_4554_L * AGE_45_54 + BAge_65_L * AGE_65 + BAge_Missing_L * AGE_Missing
                
BIsland_smallRND = BIsland_small + sigma_island_small * bioDraws('BIsland_smallRND','NORMAL') + \
                BAge_25_I * AGE_25 + BAge_2534_I * AGE_25_34 + BAge_3544_I * AGE_35_44 \
                + BAge_4554_I * AGE_45_54 + BAge_65_I * AGE_65 + BAge_Missing_I * AGE_Missing
                
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
biogeme.modelName = "First"
results = biogeme.estimate(saveIterations=True)
pandasResults = results.getEstimatedParameters()
print(pandasResults) 
