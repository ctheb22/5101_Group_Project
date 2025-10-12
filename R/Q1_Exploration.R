# Authors       : Chance Beachy, Clayton Stuhrenberg
# Creation Date : 10/11/2025
# Purpose       : Exploration of Q1: Does book difficulty affect book popularity?
#-------------------------------------------------------------------------------

#check if we've already imported/cleaned, and do so if we haven't.
if(!exists("import_complete", mode="function")) source("./R/import_and_clean.R")

ggplot(
  data = df_classics[sample(nrow(df_classics), 150),] |>
    pivot_longer(
    cols = 17:22, 
    names_to = "difficulty.type", 
    values_to = "rating")
  ) + 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1),
        legend.position="bottom") +
  geom_point(mapping=aes(
    x = rank,
    y = rating,
    color = difficulty.type
  ))

df_cg_long <- df_classics |> 
  group_by(rank.bin) |> 
  summarize(across(17:22,mean)) |> 
  pivot_longer(
    cols = 2:7, 
    names_to = "difficulty.type", 
    values_to = "rating")

ggplot(data = df_cg_long) +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1),
        legend.position="bottom") +
  geom_point(mapping=aes(
    x = rank.bin,
    y = rating,
    color = difficulty.type
  ), size = 3)





