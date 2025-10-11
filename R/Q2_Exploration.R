# Authors       : Chance Beachy, Clayton Stuhrenberg
# Creation Date : 10/11/2025
# Purpose       : Exploration of Q2: Do certain congress classifications get ranked as 
# more subjective than others? 
#-------------------------------------------------------------------------------

#check if we've already imported/cleaned, and do so if we haven't.
if(!exists("import_complete", mode="function")) source("./R/import_and_clean.R")

# get all values for each class.
# This includes works with dual classes. Those values should be counted
# for both individual classes.
dfc <- create_single_class_sorted_df(df_classics, "subjectivity")

df_avg_class <- dfc |> 
  group_by(class) |> 
  summarize(
    s_mean = mean(subjectivity),
    s_med  = median(subjectivity),
    s_sd   = sd(subjectivity),
    n = n()
  )

dfprint(n=100, df_avg_class)

class_plot <- ggplot(data=dfc)+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))

class_plot +
  geom_boxplot(mapping = aes(
   x = class,
   y = subjectivity
  ))

c_avg_plot <- ggplot(data=df_avg_class)+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))

c_avg_plot + 
  geom_col(mapping = aes(
   x = class,
   y = s_med
  ),
  fill = "azure3") +
  geom_point(mapping = aes(
   x = class,
   y = s_mean
  ),
  color = "darkgreen",
  size = 4,
  shape = 3
  )
