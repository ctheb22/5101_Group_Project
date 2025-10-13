# Authors       : Chance Beachy, Clayton Stuhrenberg
# Creation Date : 10/8/2025
# Purpose       : Exploration of Q3: When considering difficulty metrics,
# do any significantly differ in score?
#-------------------------------------------------------------------------------

#check if we've already imported/cleaned, and do so if we haven't.
if(!exists("import_complete", mode="function")) source("./R/import_and_clean.R")

# pull only needed info for the question,
df_difficulty = df_classics |> select(title,author.name,
                                      automated.readability.index:smog.index)

#convert to a long format
df_long_diff = df_difficulty |>
  pivot_longer(cols=automated.readability.index:smog.index,names_to="index",values_to = "rating")

# make a dot and box plot
diff_gg = ggplot(df_long_diff, aes(x=index,y=rating)) 

diff_gg + geom_point(mapping = aes(color = index), position=position_jitter()) + 
  labs(
    title = "Difficulty ratings",
    y = "Rating",
    x = "Difficulty Metric",
    color = "Difficulty Metric"
  ) +
  theme(axis.text = element_text(angle = 45, hjust = 1))

diff_gg + geom_boxplot(mapping = aes(fill=index)) + 
  labs(
    title = "Difficulty ratings",
    y = "Rating",
    x = "Difficulty Metric",
    fill = "Difficulty Metric"
  ) +
  theme(axis.text = element_text(angle = 45, hjust = 1))

df_long_diff_log = df_long_diff |> mutate(rating = log(rating))

# make a dot and box plot
diff_gg_log = ggplot(df_long_diff_log, aes(x=index,y=rating)) 

diff_gg_log + geom_point(mapping = aes(color = index), position=position_jitter()) + 
  labs(
    title = "Difficulty ratings (Log transformed)",
    y = "Rating (Log transformed)",
    x = "Difficulty Metric",
    color = "Difficulty Metric"
  ) +
  theme(axis.text = element_text(angle = 45, hjust = 1))

diff_gg_log + geom_boxplot(mapping = aes(fill=index)) + 
  labs(
    title = "Difficulty ratings (Log transformed)",
    y = "Rating (Log transformed)",
    x = "Difficulty Metric",
    fill = "Difficulty Metric"
  ) +
  theme(axis.text = element_text(angle = 45, hjust = 1))
