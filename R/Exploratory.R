# Authors       : Chance Beachy, Clayton Stuhrenberg
# Creation Date : 9/16/25
# Purpose       : Initial/experimental exploration of the data
#-------------------------------------------------------------------------------

#If needed, install tidyverse package using the comment below
#install.packages("tidyverse")
library(tidyverse)

#-------------------------------------------------------------------------------
# Import Data File
#-------------------------------------------------------------------------------

#'Classics.csv
#'Data format:
#'  1007 rows (including a header row), each representing a different literary
#'    work from the Gutenburg Project
#'  
#'  Many different columns broken into different subcatagories specified by the
#'    leading words of the column name:
#'  - "bibliography.[specific col]": columns concerning specific publication values
#'      such as author, publish date, subject, language, etc.
#'  - "metadata.[specific col]": columns relating to gutenburg project metadata such
#'      as number of downloads and Gutenburg project popularity ranking
#'  - "metrics.difficulty.[specific col]": columns containing difficulty ratings
#'      calculated via many different specific standard indexes/methods
#'  - "metrics.sentiments.[specific col]": columns attempting to numerically rate
#'      each book based on public sentiment regarding the text such as polarity,
#'      or subjectivity
#'  - "metrics.statistics.[specific col]": columns containing specific calculated 
#'      statistics for the given text such as "average sentance length", "letter
#'      per word" and "characters" (total number of characters).
#'
#'  Many of the columns have specific explanations about what they represent on the
#'  data source site. The metrics columns specifically should be well understood
#'  before they're used or referenced due to how abstract they can be.
 

df_classics <- read_csv("./Data/classics.csv")
