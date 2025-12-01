# Authors       : Chance Beachy, Clayton Stuhrenberg
# Creation Date : 10/11/2025
# Purpose       : Exploration of Q1: Does book difficulty affect book popularity?
#-------------------------------------------------------------------------------

#check if we've already imported/cleaned, and do so if we haven't.
if(!exists("import_complete", mode="function")) source("./R/import_and_clean.R")

#------------------------ Generate Plots for Milestone 1 -----------------------
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
  summarize(across(17:23,mean),.groups="drop") |> 
  pivot_longer(
    cols = 2:8, 
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

#------------------- Fitting Linear Models -------------------------------------
#Get only the ratings we care about, which are the:
# dale.chall.readability.score, gunning.fog, and coleman.liau.index
dff <- df_classics |> select(-automated.readability.index, -smog.index,
                    -flesch.kincaid.grade, -linsear.write.formula,)

#fit linear models for each of the difficulties
dc.lm <- lm(dale.chall.readability.score ~ rank, data=dff)
gf.lm <- lm(gunning.fog ~ rank, data=dff)
cl.lm <- lm(coleman.liau.index ~ rank, data=dff)

# ------------------------ Check for Normality of Errors -----------------------
#QQ for Dale Chall
ggplot(data=dff, mapping=aes(sample=resid(dc.lm))) +
  stat_qq() +
  stat_qq_line(linetype="dashed", color="blue") + 
  labs(
    title = "Fig 1.1 QQ Plot For Normality of Errors",
    subtitle = "Dale Chall",
    x = "Theoretical Quantiles",
    y = "Sample Quantiles"
  )

#QQ for Gunning Fog
ggplot(data=dff, mapping=aes(sample=resid(gf.lm))) +
  stat_qq() +
  stat_qq_line(linetype="dashed", color="blue") + 
  labs(
    title = "Fig 1.2 QQ Plot For Normality of Errors",
    subtitle = "Gunning Fog",
    x = "Theoretical Quantiles",
    y = "Sample Quantiles"
  )

#QQ for Coleman Liau
ggplot(data=dff, mapping=aes(sample=resid(cl.lm))) +
  stat_qq() +
  stat_qq_line(linetype="dashed", color="blue") + 
  labs(
    title = "Fig 1.3 QQ Plot For Normality of Errors",
    subtitle = "Coleman Liau",
    x = "Theoretical Quantiles",
    y = "Sample Quantiles"
  )

# --------------------- Check for Constant Variance ----------------------------
# Dale Chall 
ggplot(data=dff) + 
  geom_point(mapping = aes(
    x = predict(dc.lm),
    y = resid(dc.lm)
  )) + 
  labs(
    title = "Fig 1.4 Ranking Residual vs Predicted",
    subtitle = "Dale Chall Difficulty",
    x = "Predicted rating",
    y = "Residual rating"
  )

#Gunning Fog
ggplot(data=dff) + 
  geom_point(mapping = aes(
    x = predict(gf.lm),
    y = resid(gf.lm)
  )) + 
  labs(
    title = "Fig 1.5 Ranking Residual vs Predicted",
    subtitle = "Gunning Fog Difficulty",
    x = "Predicted rating",
    y = "Residual rating"
  )

#Coleman Liau
ggplot(data=dff) + 
  geom_point(mapping = aes(
    x = predict(cl.lm),
    y = resid(cl.lm)
  )) + 
  labs(
    title = "Fig 1.6 Ranking Residual vs Predicted",
    subtitle = "Coleman Liau Difficulty",
    x = "Predicted rating",
    y = "Residual rating"
  )

# ------------------ Check For Linear Fit --------------------------------------
#Get the residuals for each lm
dff$dc_resid <- residuals(dc.lm)
dff$gf_resid <- residuals(gf.lm)
dff$cl_resid <- residuals(cl.lm)

#Plot the residuals for each lm
#Dale Chall
ggplot(data = dff) +
  geom_point(mapping = aes(
    x = rank,
    y = dc_resid
  )) + 
  labs(
    title = "Fig 1.7 Residual Plot",
    subtitle = "Dale Chall Difficulty",
    x = "Ranking",
    y = "Rating Residual"
  )

#Gunning Fog
ggplot(data = dff) +
  geom_point(mapping = aes(
    x = rank,
    y = gf_resid
  )) + 
  labs(
    title = "Fig 1.8 Residual Plot",
    subtitle = "Gunning Fog Difficulty",
    x = "Ranking",
    y = "Rating Residual"
  )

#Coleman Liau
ggplot(data = dff) +
  geom_point(mapping = aes(
    x = rank,
    y = cl_resid
  )) + 
  labs(
    title = "Fig 1.9 Residual Plot",
    subtitle = "Coleman Liau Difficulty",
    x = "Ranking",
    y = "Rating Residual"
  )

#------------- Actually look at the generated regression -----------------------
anova(dc.lm)
anova(gf.lm)
anova(cl.lm)

summary(dc.lm)
summary(gf.lm)
summary(cl.lm)

dff_sample <- dff[sample(nrow(dff), 200),]

#Dale Chall
ggplot(data = dff_sample) +
  geom_point(mapping = aes(
    x = rank,
    y = dale.chall.readability.score,
  ), color = "goldenrod3") + 
  geom_line(mapping = aes(
    x = rank,
    y = predict(dc.lm, newdata=dff_sample),
  ), color = "red", size = 1.33) +
  labs(
    title = "Fig 1.1 Dale Chall Vs Ranking",
    subtitle = "Sample of 200 datapoints",
    x = "Ranking",
    y = "Dale Chall Rating"
  )

#Gunning Fog
ggplot(data = dff_sample) +
  geom_point(mapping = aes(
    x = rank,
    y = gunning.fog,
  ), color = "royalblue3") + 
  geom_line(mapping = aes(
    x = rank,
    y = predict(gf.lm, newdata=dff_sample),
  ), color = "red", size = 1.33) +
  labs(
    title = "Fig 1.2 Gunning Fog Vs Ranking",
    subtitle = "Sample of 200 datapoints",
    x = "Ranking",
    y = "Gunning Fog Rating"
  )

ggplot(data = dff_sample) +
  geom_point(mapping = aes(
    x = rank,
    y = coleman.liau.index,
  ), color = "seagreen4") + 
  geom_line(mapping = aes(
    x = rank,
    y = predict(cl.lm, newdata=dff_sample),
  ), color = "red", size = 1.33) +
  labs(
    title = "Fig 1.3 Coleman Liau Vs Ranking",
    subtitle = "Sample of 200 datapoints",
    x = "Ranking",
    y = "Coleman Liau Rating"
  )

