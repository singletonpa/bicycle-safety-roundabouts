# -*- coding: utf-8 -*-
"""
Created on Wed Jan 27 12:06:15 2021

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

globals().update(database.variables)


### Paramter to be extimated
BIsland_small = Beta('BIsland_small',0,None,None,0)
BLane_1 = Beta('BLane_1',0,None,None,0)
BFacility_Shared = Beta('BFacility_Shared',0, None,None,0)
BFacility_Ramps = Beta('BFacility_Ramps',0,None,None,0)
BFacility_Seperated = Beta('BFacility_Seperated',0,None,None,0)
BVolume_Medium = Beta('BVolume_Medium',0,None,None,0)
BVolume_High = Beta('BVolume_High',0,None,None,0)
BSpeed_35 = Beta('BSpeed_35',0,None,None,0)


# Next defining the utility function

V1 = BIsland_small * Island_small_A + BLane_1 * Lane_1_A + BFacility_Shared * Facility_Shared_A + \
     BFacility_Ramps * Facility_Ramps_A + BFacility_Seperated * Facility_Seperated_A + BVolume_Medium * Volume_Medium_A + \
     BVolume_High * Volume_High_A + BSpeed_35 * Speed_35_A
     
V2 = BIsland_small * Island_small_B + BLane_1 * Lane_1_B + BFacility_Shared * Facility_Shared_B + \
     BFacility_Ramps * Facility_Ramps_B + BFacility_Seperated * Facility_Seperated_B + BVolume_Medium * Volume_Medium_B + \
     BVolume_High * Volume_High_B + BSpeed_35 * Speed_35_B
     
V ={1: V1,
    2: V2,}

av = {1: av ,
      2: av,}

## Proceeding towards estimation

logprob = models.loglogit(V, av, Choice)

import biogeme.messaging as msg
logger = msg.bioMessage()
#logger.setSilent()
#logger.setWarning()
#logger.setGeneral()
logger.setDetailed()

biogeme = bio.BIOGEME(database,logprob,suggestScales=False)
biogeme.loadSavedIteration()
biogeme.modelName = "MNL"
results = biogeme.estimate(saveIterations=True)
pandasResults = results.getEstimatedParameters()
print(pandasResults) 






