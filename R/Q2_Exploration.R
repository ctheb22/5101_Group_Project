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


# -------------------- Generate Milestone 1 Plots ------------------------------
class_plot <- ggplot(data=dfc) +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))

class_plot +
  geom_boxplot(mapping = aes(
    x = class,
    y = subjectivity,
    fill = class
  )) +
  labs(
    x = "Library of Congress Classification",
    y = "Subjectivity Index",
    title = "Subjectivity Index VS Library of Congress Classification",
    subtitle = "For top ranked literature titles from the Gutenberg Project, 2016"
  )


df_avg_class <- dfc |> 
  group_by(class) |> 
  summarize(
    Mean = mean(subjectivity),
    Median  = median(subjectivity),
    s_sd   = sd(subjectivity),
    n = n()
  )

print(n=100, df_avg_class)

df_avg_class <- df_avg_class |> 
  pivot_longer(cols = Mean:Median,
               values_to = "subjectivity", 
               names_to = "stat")

c_avg_plot <- ggplot(data=df_avg_class) +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))

c_avg_plot + 
  geom_point(mapping = aes(
   x = class,
   y = subjectivity,
   color = stat,
   shape = stat
  ), size = 4)+ 
  labs(
    title = "Mean & Median Subjectivity VS Library of Congress Classification",
    subtitle = "For top ranked literature titles from the Gutenberg Project, 2016",
    x = "Library of Congress Classification",
    y = "Subjectivity Index"
  )

#--------------------- Assess assumptions for ANOVA ----------------------------
dfc$class <- factor(dfc$class)
dfc$log_sub <- log(dfc$subjectivity)
dfc.lm <- lm(subjectivity ~ class, data=dfc)
dfc.lm.ls <- lm(log_sub ~ class, data=dfc)

#----------------- Assess Equal Variance ---------------------------------------
#Fig 2.1 - Trumpet Shaped Residual vs Predicted
ggplot(data=dfc) + 
  geom_point(mapping = aes(
    x = predict(dfc.lm),
    y = resid(dfc.lm)
  )) + 
  labs(
    title = "Fig 2.1 Subjectivity Residual vs Predicted",
    subtitle = "by Library of Congress Classification",
    x = "Predicted Subjectivity",
    y = "Residual Subjectivity"
  )

#Fig 2.2 - Same Trumpet shape despite log transformed data
ggplot(data=dfc) + 
  geom_point(mapping = aes(
    x = predict(dfc.lm.ls),
    y = resid(dfc.lm.ls)
  )) + 
  labs(
    title = "Fig 2.2 Log(Subjectivity) Residual vs Predicted",
    subtitle = "by Library of Congress Classification",
    x = "Predicted Log(Subjectivity)",
    y = "Residual Log(Subjectivity)"
  )

#Check the standard deviations of each classification
# Non log best sd ratio for PT
sub_sd <- by(dfc$subjectivity, dfc$class, sd)
sub_sd[5]/sub_sd[2]
# log best sd ratio for PT
lsub_sd <- by(dfc$log_sub, dfc$class, sd)
lsub_sd[5]/lsub_sd[2]

# --------------- Asses Normality of Residuals ---------------------------------
#Check for normality of errors
ggplot(data=dfc, mapping=aes(sample=resid(dfc.lm))) +
  stat_qq() +
  stat_qq_line(linetype="dashed", color="blue") + 
  labs(
    title = "Fig 2.3 QQ Plot For Normality of Errors",
    subtitle = "for Subjectivity",
    x = "Theoretical Quantiles",
    y = "Sample Quantiles"
  )

# -------------- View the ANOVA Result -----------------------------------------
# We're sticking with the non-log version since there's so little difference
# between the two
anova(dfc.lm)


#--------------------- Redo the test without PT --------------------------------
dfcf <- dfc |> filter(class != "PT")
#Remove PT from the factor list in this dataframe. Because it bothers me.
dfcf$class <- factor(dfcf$class)

dfcf.lm <- lm(subjectivity ~ class, data=dfcf)

ggplot(data=dfcf) + geom_point(mapping = aes(
  x = predict(dfcf.lm),
  y = resid(dfcf.lm)
))

#Check for normality of errors
ggplot(data=dfcf, mapping=aes(sample=resid(dfcf.lm))) +
  stat_qq() +
  stat_qq_line(linetype="dashed", color="blue")

anova(dfcf.lm)

#------------------ Linear Contrast (PR, PS) vs (PQ, PA) -----------------------
levels(dfcf$class)
#PA, PQ, PR, PS
dfcf.emm <- emmeans(dfcf.lm, 'class')
coef = list(english=c(-.5, -.5, .5, .5))
dfcf.cont.emm <- contrast(dfcf.emm, coef)

summary(dfcf.cont.emm)
