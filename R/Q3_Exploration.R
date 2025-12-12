# Authors       : Chance Beachy, Clayton Stuhrenberg
# Creation Date : 10/8/2025
# Purpose       : Exploration of Q3: When considering difficulty metrics,
# do any significantly differ in score?
#-------------------------------------------------------------------------------

#check if we've already imported/cleaned, and do so if we haven't.
if(!exists("import_complete", mode="function")) source("./R/import_and_clean.R")

# pull only needed info for the question,
df_difficulty = df_classics |> select(title,author.name,
                                      automated.readability.index:smog.index, characters:polysyllables)

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

df_long_diff_log = df_long_diff |> mutate(rating = log(rating),
                                          words = (words),
                                          sentences = (sentences),
                                          syllables = (syllables),
                                          polysyllables = (polysyllables),
                                          index = as.factor(index)
                                          )

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
    subtitle = "Fig 3.1",
    y = "Rating (Log transformed)",
    x = "Difficulty Metric",
    fill = "Difficulty Metric"
  ) +
  theme(axis.text = element_text(angle = 45, hjust = 1))

model = lm(rating ~ index, data = df_long_diff_log)
summary(model)

#qq
qqnorm(residuals(model), main = "Fig 3.2 QQ Plot of Residuals")
qqline(residuals(model), col = "blue", lwd = 2)

# Residuals vs. Predicted Plot
plot(fitted(model), residuals(model),
     xlab = "Predicted Values",
     ylab = "Residuals",
     main = "Fig 3.3 Residuals vs. Predicted",
     pch = 19, col = "darkgreen")
abline(h = 0, col = "red", lwd = 2)

#find max sd ratio
rating_sd  = tapply(df_long_diff_log$rating, df_long_diff_log$index, sd)

max_sd_ratio = 0
max_sd_ratio_str = ""

for (i in 1:length(rating_sd)) {
  for (k in i+1:length(rating_sd)) {
    if (k > length(rating_sd)) next
    
    # Always take the larger over the smaller
    ratio <- max(rating_sd[i], rating_sd[k]) / min(rating_sd[i], rating_sd[k])
    
    if (ratio > max_sd_ratio) {
      max_sd_ratio <- ratio
      max_sd_ratio_str <- paste0("Group ", i, " vs Group ", k)
    }
  }
}
max_sd_ratio
max_sd_ratio_str

anova_m = aov(rating ~ index,data = df_long_diff_log )

#get anova
summary(anova_m)

# Run Tukey's Honest Significant Difference test
tukey_result <- TukeyHSD(anova_m)

# View results
tukey_result

#plot(tukey_result)

mr = lm(rating ~ 0 + index  , data = df_long_diff_log)

# see linear reg results
summary(mr)

#df_long_diff_log$resid <- residuals(mr)
#ggplot(df_long_diff_log, aes(x = index, y = resid)) +
#  geom_boxplot()

#qqnorm(residuals(mr), main = "QQ Plot of Residuals")
#qqline(residuals(mr), col = "blue", lwd = 2)
