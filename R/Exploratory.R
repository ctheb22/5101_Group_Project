# Authors       : Chance Beachy, Clayton Stuhrenberg
# Creation Date : 9/16/25
# Purpose       : Initial/experimental exploration of the data
#-------------------------------------------------------------------------------

#check if we've already imported/cleaned, and do so if we haven't.
if(!exists("import_complete", mode="function")) source("./R/import_and_clean.R")

#how common are different classifications
congress_n <- df_classics |> group_by(`bibliography.congress classifications`) |>
  summarize(n = n()) |> filter(n>50)
ggplot(data=congress_n, mapping=aes(x=n)) +
  geom_histogram()

#Numbers of American, English, and romantic authors that appear x number of times
auth_n <- df_classics |> 
  filter(`bibliography.congress classifications` %in% c("PR", "PS", "PQ")) |>
  group_by(`bibliography.author.name`) |> 
  summarize(n = n())
ggplot(data=auth_n, mapping=aes(x=n))+
  geom_histogram()

#There are few huge outliers, which also doesn't make sense given the number is
# supposed to represent grade level. Also filtering down to a specific congress
# classification
df1 <- df_classics |>
  filter(`metrics.difficulty.flesch kincaid grade` < 25, 
         `metrics.difficulty.flesch kincaid grade` > 0,
         `bibliography.congress classifications` == "PS")


#various difficulties vs ranking (seems random, and the color legend is jacked)
cp1 <- ggplot(data=df1, mapping = aes(x = metadata.rank))
cp1 + 
  geom_point(
    mapping = aes(
      y = `metrics.difficulty.flesch kincaid grade`,
      color = "red"
  )) +
  geom_point(
    mapping = aes(
      y = `metrics.difficulty.dale chall readability score`,
      color = "blue"
  )) +
  geom_point(
    mapping = aes(
      y = `metrics.difficulty.smog index`,
      color = "green"
  ))

#one difficulty metric vs another
cp2 <- ggplot(data=df1, mapping = aes(x = `metrics.difficulty.dale chall readability score`))
cp2 + 
  geom_point(
    mapping = aes(
      y = `metrics.difficulty.flesch kincaid grade`,
      color = "red"
    ))
