# bicycle-safety-roundabouts
## MPC-603 Investigating bicyclist safety perceptions and behaviors at roundabouts
This repository contains data and scripts associated with the ["Investigating bicyclist safety perceptions and behaviors at roundabouts" research project MPC-603](https://www.mountain-plains.org/research/details.php?id=500), funded by the [Mountain-Plains Consortium](https://www.mountain-plains.org/), and carried out by [Patrick Singleton](https://engineering.usu.edu/cee/people/faculty/singleton-patrick) and the [Singleton Transportation Lab](https://engineering.usu.edu/cee/research/labs/patrick-singleton/index) at Utah State University. 
* **Objectives**
    * Characterize bicyclists’ safety perceptions of roundabouts and roundabout elements.
    * Identify bicyclists’ preferences for various roundabout elements.
* **Methods**
    * Survey data collection, using an online questionnaire about bicyclists' personal characteristics, user behaviors, perceptions of comfort, and preferences for various design and operational elements of roundabouts.
    * Statistical modeling of associations between safety perceptions and user characteristics, roundabout designs, and other factors. 

[![DOI](https://zenodo.org/badge/385982421.svg)](https://zenodo.org/badge/latestdoi/385982421)

### Publications
* Poudel, N., & Singleton P. A. (2021). Bicycle safety at roundabouts: A systematic literature review. *Transport Reviews, 1877207*. https://doi.org/10.1080/01441647.2021.1877207
* Poudel, N., & Singleton, P. A. (2022). Preferences for roundabout attributes among US bicyclists: A discrete choice experiment. *Transportation Research Part A: Policy and Practice, 155*, 316-329. https://doi.org/10.1016/j.tra.2021.11.023

## Description of files and folders
* Many of these scripts were written in R. To use, [download R](https://cloud.r-project.org/) and then [download RStudio](https://www.rstudio.com/products/rstudio/download/#download). 
* Many of these scripts were written in [Python](https://www.python.org/) to use with [Biogeme](https://biogeme.epfl.ch/index.html). To use, follow [installation instructions](https://biogeme.epfl.ch/install.html). 
* **bicycle-safety-roundabouts.Rproj**: This [RStudio project](https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects) file allows R users to use relative file paths from this root folder, if R scripts are opened after opening this R project file. 

### Data
These folders contain data collected, assembled, and generated as part of this research project. 
* **Census**: Files associated with weighting the data. 
* **Experimental designs**: Files associated with generating and selecting the experimental designs. 
* **Final images**: JPG and GIF files depicting the photorealistic simulated roundabouts. 
* **Survey**: Anonymized survey data collected, along with questionnaire. 

### Analysis
These folders contain processed data, scripts, and outputs associated with analyses of the research project data. 
* **Data cleaning**: Files associated with the processing and cleaning of the survey data. 
* **Stated preference**: Files associated with the discrete choice analysis of stated preference survey data. 
    * **Data cleaning and weighting**: Files associated with the preparation of the survey/experimental data for the analyses. 
    * **Heterogeneity model**: Files associated with the panel mixed multinomial logit models, including systematic preference heterogeneity. 
    * **MMNL model**: Files associated with the panel mixed multinomial logit models. 
    * **MNL model**: Files associated with the multinomial logit models. 
* **Comfort analysis**: Files associated with the analysis of perceived comfort data. 
   * **Data cleaning**: Files associated with the preparation of survey data for the analysis. 
   * **Comfort analysis**: Files associated with the multivariate ordered probit models of comfort. 
