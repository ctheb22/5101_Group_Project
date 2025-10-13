# Authors       : Chance Beachy, Clayton Stuhrenberg
# Creation Date : 10/11/2025
# Purpose       : Exploration of Q1: Does book difficulty affect book popularity?
#-------------------------------------------------------------------------------

#check if we've already imported/cleaned, and do so if we haven't.
if(!exists("import_complete", mode="function")) source("./R/import_and_clean.R")

ggplot(
  data = df_classics[sample(nrow(df_classics), 225),] |>
    pivot_longer(
    cols = automated.readability.index:smog.index, 
    names_to = "difficulty.type", 
    values_to = "rating")
  ) + 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1),
        legend.position="bottom") +
  geom_point(mapping=aes(
    x = rank,
    y = rating,
    color = difficulty.type
  ))+
  labs(
    x = "Book Ranking",
    y = "Grade Level Difficulty Rating",
    title = "Difficulty Rating VS Rank",
    subtitle = "Random sample of 225 observations"
  )

df_cg_long <- df_classics |> 
  group_by(rank.bin) |> 
  summarize(across(17:22,mean),.groups="drop") |> 
  pivot_longer(
    cols = 2:7, 
    names_to = "difficulty.type", 
    values_to = "rating")

ggplot(data = df_cg_long) +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1),
        legend.position="bottom") +
  geom_line(mapping=aes(
    x = rank.bin,
    y = rating,
    group = difficulty.type,
    color = difficulty.type
  ), linewidth = 1)+
  geom_point(mapping=aes(
    x = rank.bin,
    y = rating,
    color = difficulty.type
  ), size = 2)+
  labs(
    x = "Binned Rank",
    y = "Grade Level Difficulty Rating",
    title = "Mean Difficulty Rating VS Binned Rank",
    subtitle = "bin width = 100 rankings"
  )





