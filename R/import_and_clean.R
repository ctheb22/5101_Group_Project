# Authors       : Chance Beachy, Clayton Stuhrenberg
# Creation Date : 10/02/25
# Purpose       : Initial/experimental exploration of the data
#-------------------------------------------------------------------------------

# If needed, install tidyverse package using the comment below
# install.packages("tidyverse")
library(tidyverse)
theme_set(theme_bw())

# Basically a dummy function that we can check the existence of from other
# scripts to know if the this import script needs to be called with "source"
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

#-------------------------------------------------------------------------------
# 1. Column renaming section
#-------------------------------------------------------------------------------

# peeling off unnecessary descriptors and generally shortening column names
# Also removing spaces so we don't have to backtick every column name.
colname_transform <- function(colname) {
  colname |> str_replace_all(c(
    "bibliography."       = "",
    "metadata."           = "",
    "publication"         = "pub",
    "metrics.difficulty." = "",
    "metrics.sentiments." = "",
    "metrics.statistics." = "",
    " "                   = ".",
    "average"             = "avg",
    ".per."               = "/"
  ))
}

# initial shortening of the column names to save time when accessing them later.
df_classics |> names() <-
  df_classics |> names() |> 
    sapply(colname_transform)

# Individual column renamings:
# Change the name of the classification column to less of a mouthful
names(df_classics)[names(df_classics) == 'congress.classifications'] <- 'class'
# Rename this column to match the format of other like columns
names(df_classics)[names(df_classics) == 'avg.sentence.length'] <- 
  "avg.word/sentence"

# Print the column names for reference
names(df_classics)

#-------------------------------------------------------------------------------
# 2. Data Cleaning, Filtering, and Transformation Section
#-------------------------------------------------------------------------------

# Function for searching for the classes we care about PR, PS, PQ, PA, PT
# and renaming the class column accordingly, dropping other classes.
discern_lit_class <- function(cstring) {
  if(!is.na(cstring)) {
    temp <- str_split_1(cstring, ",")
    if(length(i <- grep("P[RSQAT]", temp, value=TRUE))) {
      #Returns a string with all "P[x]" codes.
      return(paste(sort(i), collapse = ','))
    }
  }
  return("NOT IN SCOPE")
}

# transform the class column
df_classics$class <-
  df_classics |> pull(class) |>
    sapply(discern_lit_class)

# Now class is a comma seperated string with only these possible values:
#   Combination of PA, PQ, PR, PS, PT
#   OR the string: "NOT IN SCOPE"

# I don't know if we want to leave it like this, but
# you can filter using grepl to find patterns in the class variable:
#  df_classics |> filter(grepl("PA", class)) |> pull(class) |> unique()

# filtering out all the "Not Lit" books, and classes that we aren't interested in.
df_classics <-
  df_classics |> 
  filter(class != "NOT IN SCOPE")

# Print the resulting counts of distinct class (and class combinations) values
print(n=100, 
      arrange(df_classics |> group_by(class) |> summarize(n=n()), desc(n)))

#Now generate the binned ranking column:
#This creates a new rank.bin column with ranks sorted into 10 ~100 width bins
df_classics <- df_classics |> mutate(rank.bin = cut_interval(
  rank,
  length = 100,
  right = F
))

#Recalculate the smog index and the linsear write formula.
df_classics <- df_classics |> mutate(smog.index = 1.0430*sqrt(polysyllables*(30/sentences))+3.1291) |>
  mutate(smog.index = 1.0430*sqrt(polysyllables*(30/sentences))+3.1291,
         linsear.write.formula_raw = ((words - polysyllables) + ( 3 * polysyllables)) / sentences,
         linsear.write.formula = if_else(
           linsear.write.formula_raw > 20,
           linsear.write.formula_raw / 2,
           (linsear.write.formula_raw / 2) - 1)
         )

#-------------------------------------------------------------------------------
# 3. Column Filtering Section
#-------------------------------------------------------------------------------

#' Columns we're removing with the selection:
#'  type          : the type of media ("text" for all entries)
#'  langugages    : the language the text is in ("en" for 965 of the observations)
#'  id            : unique id used by gutenberg project
#'  url           : unique url linking to gutenberg project page for the title
#'  pub.day       : publication day (not useful, it's not the original publication)
#'  pub.month     : publication month (not useful, it's not the original publication)
#'  pub.month.name: publication month (not useful, it's not the original publication)
#'  pub.year      : publication month (not useful, it's not the original publication)
#'  pub.full      : publication full (not useful, it's not the original publication)
#'  formats.total : int number of different download formats available
#'  formats.type  : string list of different download formats available
#'  flesch.reading.ease : difficulty rating (not being used, not grade level)
#'  difficult .words    : difficulty rating (not being used, not grade level)
#'  linsear.write.formula_raw : raw conversion no longer needed

# Columns and order that we're keeping for the final version of this df
df_classics <-
  df_classics |>
  select(c(
    "title",          #Name of the book
    "author.name",    #Name of the author
    "author.birth",   #Birth year of the author (0 if unknown)
    "author.death",   #Death year of the author (0 if unknown)
    "class",          #Congress Classification
    "subjects",       #Subject string (not for analysis)
    "downloads",      #The number of times the text has been downloaded
    "rank",           #The ranking of the title (based on download count)
    "characters",          #Total number of characters in the book (letters & symbols)
    "words",               #Total number of words in the book
    "sentences",           #Total number of sentences in the book
    "syllables",           #number of syllables? (not always an int?)
    "polysyllables",       #Number of words with 3 or more syllables
    "avg.letter/word",     #Average letters/word (rounded to 2 decimals?)
    "avg.word/sentence",   #Average number of words/sentence (seems floor rounded)
    "avg.sentence/word",   #Average sentence per word (inverse of above)
    "automated.readability.index",  #difficulty rating (U.S. grade level)
    "coleman.liau.index",           #difficulty rating (U.S. grade level)
    "dale.chall.readability.score", #difficulty rating (U.S. grade level)
    "flesch.kincaid.grade",         #difficulty rating (U.S. grade level)
    "gunning.fog",                  #difficulty rating ("years of formal education")
    "linsear.write.formula",        #difficulty rating (U.S. grade level)
    "smog.index",                   #difficulty rating (U.S. grade level)
    "polarity",                #"How positive or negative the author is towards the content"
    "subjectivity"             #"whether the text is opinionated or attempts to stay factual"
  ))

print("--------------------------------------------")
print("----> DATA HAS BEEN IMPORTED & CLEANED <----")
print("--------------------------------------------")
  
