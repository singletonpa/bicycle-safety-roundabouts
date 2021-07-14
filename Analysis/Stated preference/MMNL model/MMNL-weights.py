# -*- coding: utf-8 -*-
"""
Created on Fri Jan 15 13:02:35 2021

@author: Niranjan.p
"""


import pandas as pd
import biogeme.database as db
import biogeme.biogeme as bio
import biogeme.models as models
import biogeme.messaging as msg
from biogeme.expressions import Beta, Variable, bioMultSum, DefineVariable, \
    bioDraws, MonteCarlo, log, exp
    
df = pd.read_csv('Stated_wide_weight.csv')
df = df.drop(columns=['ResponseId'])
database = db.Database('Stated_wide_weight', df)

# Number of observations for each individual. The are numbered from 0 to 8 in the dat set.
nbrQuestions = 6

# The following statement allows you to use the names of the variable
# as Python variable.
globals().update(database.variables)   

### Parameters to be estimated
BIsland_small = Beta('BIsland_small',0,None,None,0)
BLane_1 = Beta('BLane_1',0,None,None,0)
BFacility_Shared = Beta('BFacility_Shared',0, None,None,0)
BFacility_Ramps = Beta('BFacility_Ramps',0,None,None,0)
BFacility_Seperated = Beta('BFacility_Seperated',0,None,None,0)
BVolume_Medium = Beta('BVolume_Medium',0,None,None,0)
BVolume_High = Beta('BVolume_High',0,None,None,0)
BSpeed_35 = Beta('BSpeed_35',0,None,None,0)

 #Defining the standard deviation for the parameters
sigma_speed_35 = Beta('sigma_speed_35',0.15, None, None,0)
sigma_volume_high = Beta('sigma_volume_high',0,None,None,0)
sigma_volume_medium = Beta('sigma_volume_medium',0,None,None,0)
sigma_facility_seperated = Beta('sigma_facility_seperated',0,None,None,0)
sigma_facility_ramps = Beta('sigma_facility_ramps',0,None,None,0)
sigma_facility_shared = Beta('sigma_facility_shared',0,None,None,0)
sigma_lane_1 = Beta('sigma_lane_1',0,None,None,0)
sigma_island_small = Beta('sigma_island_small',0,None,None,0)

### Defining the random parameters
BSpeed_35RND = BSpeed_35 + sigma_speed_35 * bioDraws('BSpeed_35RND','NORMAL')
BVolume_HighRND = BVolume_High + sigma_volume_high * bioDraws('BVolume_HighRND','NORMAL')
BVolume_MediumRND = BVolume_Medium+ sigma_volume_medium * bioDraws('BVolume_MediumRND','NORMAL')
BFacility_SeperatedRND = BFacility_Seperated + sigma_facility_seperated * bioDraws('BFacility_SeperatedRND','NORMAL')
BFacility_RampsRND = BFacility_Ramps + sigma_facility_ramps * bioDraws('BFacility_RampsRND','NORMAL')
BFacility_SharedRND = BFacility_Shared + sigma_facility_shared * bioDraws('BFacility_SharedRND','NORMAL')
BLane_1RND = BLane_1 + sigma_lane_1 * bioDraws('BLane_1RND','NORMAL')
BIsland_smallRND = BIsland_small + sigma_island_small * bioDraws('BIsland_smallRND','NORMAL')

#### Defining the utility equations
V1 = [BIsland_smallRND *  Variable(f'Island_small_A_{q}') + BLane_1RND * Variable(f'Lane_1_A_{q}') + \
      BFacility_SharedRND * Variable(f'Facility_Shared_A_{q}') + BFacility_RampsRND * Variable(f'Facility_Ramps_A_{q}') + \
      BFacility_SeperatedRND * Variable(f'Facility_Seperated_A_{q}') + BVolume_MediumRND * Variable(f'Volume_Medium_A_{q}') + \
      BVolume_HighRND * Variable(f'Volume_High_A_{q}') + BSpeed_35RND * Variable(f'Speed_35_A_{q}')
      for q in range(nbrQuestions)]


V2 = [BIsland_smallRND *  Variable(f'Island_small_B_{q}') + BLane_1RND * Variable(f'Lane_1_B_{q}') + \
      BFacility_SharedRND * Variable(f'Facility_Shared_B_{q}') + BFacility_RampsRND * Variable(f'Facility_Ramps_B_{q}') + \
      BFacility_SeperatedRND * Variable(f'Facility_Seperated_B_{q}') + BVolume_MediumRND * Variable(f'Volume_Medium_B_{q}') + \
      BVolume_HighRND * Variable(f'Volume_High_B_{q}') + BSpeed_35RND * Variable(f'Speed_35_B_{q}')
      for q in range(nbrQuestions)]

V =[{1: V1[q],
    2: V2[q]}
    for q in range(nbrQuestions)]

av = {1: av ,
      2: av}

## Proceeding towards estimation
obslogprob = [models.loglogit(V[q], av, Variable(f'Choice_{q}'))
                for q in range(nbrQuestions)]

## Panel nature of the data
condprobIndiv = exp(bioMultSum(obslogprob))

logprob = log(MonteCarlo(condprobIndiv))

formulas = {'loglike': logprob, 'weight': weight}

import biogeme.messaging as msg
logger = msg.bioMessage()
#logger.setSilent()
#logger.setWarning()
#logger.setGeneral()
logger.setDetailed()

biogeme = bio.BIOGEME(database,formulas,numberOfDraws = 1000,suggestScales=False)
biogeme.loadSavedIteration()
biogeme.modelName = "MMNL-weights"
results = biogeme.estimate(saveIterations=True)
pandasResults = results.getEstimatedParameters()
print(pandasResults)