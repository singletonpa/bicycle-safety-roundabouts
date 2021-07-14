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


## Para as results
BAge_4554_VM = Beta('BAge_4554_VM',1.3,None,None,0)
BAge_65_VM = Beta('BAge_65_VM',0.862,None,None,0)

BBIKES_L = Beta ('BBIKES_L', 0.298, None, None, 0)

BBUseF_FR = Beta('BBUseF_FR',3.14,None,None,0)
BBUseF_FSep = Beta('BBUseF_FSep',2.36,None,None,0)
BBUseN_VH = Beta('BBUseN_VH',1.33,None,None,0)

BBUseW_S = Beta('BBUseW_S',0.715,None,None,0)
BBUseW_VH = Beta('BBUseW_VH',0.926,None,None,0)
BBUseW_VM = Beta('BBUseW_VM',0.501,None,None,0)

BCARS_I = Beta ('BCARS_I', -0.341, None, None, 0)
BCARS_L = Beta ('BCARS_L', -0.455, None, None, 0)

BCHILD_S = Beta ('BCHILD_S', 0.223, None, None, 0)

BCrash_S = Beta('BCrash_S',0.46,None,None,0)
BCrash_VM = Beta('BCrash_VM',0.645,None,None,0)

BEDUC_B_VH = Beta('BEDUC_B_VH',0.614,None,None,0)
BEDUC_B_VM = Beta('BEDUC_B_VM',0.801,None,None,0)

BGENDF_FSep = Beta('BGENDF_FSep',2.03,None,None,0)
BGENDF_VH = Beta('BGENDF_VH',-0.772,None,None,0)

BInc75100_VM = Beta('BInc75100_VM',0.847,None,None,0)

BMODEROUND_A_FSep = Beta('BMODEROUND_A_FSep',-2.13,None,None,0)

BMODEROUND_N_FShared = Beta('BMODEROUND_N_FShared',-0.831,None,None,0)
BMODEROUND_N_I = Beta('BMODEROUND_N_I',-0.881,None,None,0)

BMROUTE_B_YA_FSep = Beta('BMROUTE_B_YA_FSep',-0.0577,None,None,0)
BMROUTE_B_YAt_FShared = Beta('BMROUTE_B_YAt_FShared',0.0455,None,None,0)
BMROUTE_B_YP_FR = Beta('BMROUTE_B_YP_FR',-1.62,None,None,0)

BROUNDMODE_Miss_VH = Beta('BROUNDMODE_Miss_VH',3.05,None,None,0)
BROUNDMODE_YesLess_FSep = Beta('BROUNDMODE_YesLess_FSep',4.11,None,None,0)
BROUNDMODE_YesMore_FShared = Beta('BROUNDMODE_YesMore_FShared',-1.64,None,None,0)
BROUNDMODE_YesMore_VH = Beta('BROUNDMODE_YesMore_VH', 0.724, None, None, 0) #New

BStudY_FSep = Beta('BStudY_FSep',1.83,None,None,0)

Bbtype_E_FR = Beta('Bbtype_E_FR',-2.63,None,None,0)
Bbtype_E_FSep = Beta('Bbtype_E_FSep',-1.26,None,None,0)

Bbtype_S_FSep = Beta('Bbtype_S_FSep',-3.28,None,None,0)
Bbtype_S_L = Beta('Bbtype_S_L',-0.989,None,None,0)
Bbtype_S_VH = Beta('Bbtype_S_VH',1.14,None,None,0)

### Random parameters

BSpeed_35RND = BSpeed_35 + sigma_speed_35 * bioDraws('BSpeed_35RND','NORMAL') +\
                BCrash_S * Crash +\
                 BBUseW_S * MODEUSE2_BIKE_Week + \
                 BCHILD_S * CHILD
                         
                
BVolume_HighRND = BVolume_High + sigma_volume_high * bioDraws('BVolume_HighRND','NORMAL') +\
                 BGENDF_VH * GEND_Female + BEDUC_B_VH * EDUC_Bach  +\
                 BEDUC_B_VH * EDUC_Bach + BBUseN_VH * MODEUSE2_BIKE_Never +\
                 Bbtype_S_VH * btype_S + \
                 BBUseW_VH * MODEUSE2_BIKE_Week + \
                 BROUNDMODE_Miss_VH * ROUNDMODE_Missing + BROUNDMODE_YesMore_VH *ROUNDMODE_YesMore
                
                
BVolume_MediumRND = BVolume_Medium+ sigma_volume_medium * bioDraws('BVolume_MediumRND','NORMAL')+ \
                 BAge_4554_VM * AGE_45_54 + BAge_65_VM * AGE_65 +\
                 BCrash_VM * Crash +\
                 BBUseW_VM * MODEUSE2_BIKE_Week + \
                 BInc75100_VM * HHINC_75_100 +  BEDUC_B_VM * EDUC_Bach
                               
                
BFacility_SeperatedRND = BFacility_Seperated + sigma_facility_seperated * bioDraws('BFacility_SeperatedRND','NORMAL') + \
               BStudY_FSep * STUD_Yes +\
                BGENDF_FSep * GEND_Female +\
                Bbtype_E_FSep * btype_E  + Bbtype_S_FSep * btype_S + \
                BBUseF_FSep * MODEUSE2_BIKE_Few  + \
                BMODEROUND_A_FSep * MODEROUND_BIKE_Always + \
                BMROUTE_B_YA_FSep * MODEROUTE_BIKE_Yes_Avoid  +\
                BROUNDMODE_YesLess_FSep * ROUNDMODE_YesLess 
                
BFacility_SharedRND = BFacility_Shared + sigma_facility_shared * bioDraws('BFacility_SharedRND','NORMAL') +\
                BMROUTE_B_YAt_FShared * MODEROUTE_BIKE_Yes_AvoidAlt +\
                BROUNDMODE_YesMore_FShared * ROUNDMODE_YesMore + \
                BMODEROUND_N_FShared * MODEROUND_BIKE_Never 

                            
BFacility_RampsRND = BFacility_Ramps + sigma_facility_ramps * bioDraws('BFacility_RampsRND','NORMAL') + \
                Bbtype_E_FR * btype_E + \
                BMROUTE_B_YP_FR * MODEROUTE_BIKE_Yes_Prefer +\
                BBUseF_FR * MODEUSE2_BIKE_Few 
                             
BLane_1RND = BLane_1 + sigma_lane_1 * bioDraws('BLane_1RND','NORMAL') + \
                 Bbtype_S_L * btype_S + \
                BBIKES_L * BIKES + BCARS_L * CARS 
                            
BIsland_smallRND = BIsland_small + sigma_island_small * bioDraws('BIsland_smallRND','NORMAL')  + \
                BCARS_I * CARS
 

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
biogeme.modelName = "Fourth-all"
results = biogeme.estimate(saveIterations=True)
pandasResults = results.getEstimatedParameters()
print(pandasResults) 
               
               
