# Authors       : Chance Beachy, Clayton Stuhrenberg
# Creation Date : 9/16/25
# Purpose       : Initial/experimental exploration of the Bee data
#-------------------------------------------------------------------------------

#If needed, install tidyverse package using the comment below
#install.packages("tidyverse")
library(tidyverse)

#If needed, install readxl package using the comment below
#install.packages("readxl")
library(readxl)


#-------------------------------------------------------------------------------
# Import Data Files
#-------------------------------------------------------------------------------

#'Adults and Brood' file:
#'Data format:
#'  Rows = multi-value indices (date, hive)
#'  columns = different variable names
#'  
#'  Each row describes a specific hive on a specific date, with each column 
#'  containing a different variable value.
#'
#'4 sub sheets:
#'  sheet 1: Adults 2021-22 
#'    (Weirdly has duplicate columns, some random missing data values)
#'  sheet 2: Brood 2021-22
#'  sheet 3: Adults 2022-23
#'  sheet 4: Brood 2022-23

df_Adults <- read_excel("./Data/Direct/Adults and brood 2021-2022.xlsx",
                       sheet = 1)

df_Brood <- read_excel("./Data/Direct/Adults and brood 2021-2022.xlsx",
                       sheet = 2)

#'Continuous hive CO2':
#'Data format:
#'  Rows = timestamps every 5 minutes
#'  Columns = Specific hive (and bee variety)
#'    Likely needs column headings cleaned up or combined to import correctly.
#'    
#'  Forms a time series grid with each row containing a recorded CO2 value for
#'  every column/hive at that timestamp
#'  
#'2 sub sheets:
#'  sheet 1: 2021 experiment
#'  sheet 2: 2022 experiment

df_Co2 <- read_excel("./Data/Direct/Continuous hive CO2 2021-2022.xlsx",
                       sheet = 1)

#'Continuous hive temperature':
#'Data format:
#'  Rows = timestamps every 5 minutes
#'  Column headings = Specific hive (and bee variety)
#'    Likely needs column headings cleaned up or combined to import correctly.
#'    
#'  Forms a time series grid with each row containing a recorded temp value for
#'  every column/hive at that timestamp
#'  
#'2 sub sheets:
#'  sheet 1: 2021 experiment
#'  sheet 2: 2022 experiment

df_Temp <- read_excel("./Data/Direct/Continuous hive temperature 2021-2022.xlsx", 
                       sheet = 1)

#'Continuous hive weight':
#'Data format:
#'  Rows = timestamps every 5 minutes
#'  Column headings = Specific hive (and bee variety)
#'    Likely needs column headings cleaned up or combined to import correctly.
#'    
#'  Forms a time series grid with each row containing a recorded weight value for
#'  every column/hive at that timestamp
#'  
#'2 sub sheets:
#'  sheet 1: 2021 experiment
#'  sheet 2: 2022 experiment

df_Weight <- read_excel("./Data/Direct/Continuous hive weight 2021-2022.xlsx", 
                       sheet = 1)
