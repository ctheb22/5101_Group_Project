# Authors       : Chance Beachy, Clayton Stuhrenberg
# Creation Date : 10/02/25
# Purpose       : Initial/experimental exploration of the data
#-------------------------------------------------------------------------------

#If needed, install tidyverse package using the comment below
#install.packages("tidyverse")
library(tidyverse)
set_theme(theme_bw())

#Basically a dummy function that we can check the existence of other scripts 
#to know if the this import script needs to be called with "source"
import_complete <- function(){
  TRUE
}

#-------------------------------------------------------------------------------
# Import Data File
#-------------------------------------------------------------------------------

#'Classics.csv
#'Data format:
#'  1007 rows (including a header row), each representing a different literary
#'    work from the Gutenberg Project
#'  
#'  Many different columns broken into different sub-catagories specified by the
#'    leading words of the column name:
#'  - "bibliography.[specific col]": columns concerning specific publication values
#'      such as author, publish date, subject, language, etc.
#'  - "metadata.[specific col]": columns relating to Gutenberg project metadata such
#'      as number of downloads and Gutenberg project popularity ranking
#'  - "metrics.difficulty.[specific col]": columns containing difficulty ratings
#'      calculated via many different specific standard indexes/methods
#'  - "metrics.sentiments.[specific col]": columns attempting to numerically rate
#'      each book based on the sentiment of the author's writing. For example:
#'      "polarity" is how positive/negative the writing is estimated to be?
#'  - "metrics.statistics.[specific col]": columns containing specific calculated 
#'      statistics for the given text such as "average sentence length", "letter
#'      per word" and "characters" (total number of characters).
#'
#'  Many of the columns have specific explanations about what they represent on the
#'  data source site. The metrics columns specifically should be well understood
#'  before they're used or referenced due to how abstract they can be.


df_classics <- read_csv("./Data/classics.csv")

#To be cleaned:
# bibliography.subjects - they're currently just a big string list of subject keywords
# Maybe transform bibliography.congress classifications to their full descriptions

#columns that can probably be dropped for convenience:
# metadata.id
# all the bibliography.publication data since they're not super useful. Its the
#   publication date of the specific printing, so they're all in the 90s or 2000s
#   which is not helpful for analyzing real publishing date of historic works.
# at least some of the metric.difficulty columns. Probably trim it down to 3-4 at most.

#We should maybe focus only on books with the PR or PS which refer to English and 
#American literature, just to cut down on noise.
#We probably should also think about whether the data is truly independent - if
#one person writes 10 books, is each book a truly independent point, particularly
#if we're looking at complexity of writing? We could zoom out to focus on a per
#author sort of dataset rather than per book.

print("--------------------------------------------")
print("----> DATA HAS BEEN IMPORTED & CLEANED <----")
print("--------------------------------------------")
  
