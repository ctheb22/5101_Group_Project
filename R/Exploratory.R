# Authors       : Chance Beachy, Clayton Stuhrenberg
# Creation Date : 9/16/25
# Purpose       : Initial/experimental exploration of the data
#-------------------------------------------------------------------------------

#check if we've already imported/cleaned, and do so if we haven't.
if(!exists("import_complete", mode="function")) source("./R/import_and_clean.R")

#how common are different classifications
ggplot(data=df_classics, 
       mapping=aes(x=fct_infreq(class))) +
  geom_bar() + 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))

#Numbers of authors that appear x number of times
auth_n <- df_classics |> 
  group_by(author.name) |> 
  summarize(n = n())
ggplot(data=df_classics |> group_by(author.name) |> summarize(n = n()), 
       mapping=aes(y=n)) +
  geom_histogram() + 
  labs(y="# of books in dataset", x="# of authors")

#There are few huge outliers, which also doesn't make sense given the number is
# supposed to represent grade level. Also filtering down to a specific congress
# classification
cp1 <- ggplot(data=df_classics |> 
                filter(flesch.kincaid.grade < 25, flesch.kincaid.grade > 0), 
              mapping = aes(x = rank))

cp1 + 
  geom_point(mapping=aes(
    y = automated.readability.index
  ))

cp1 + 
  geom_point(mapping=aes(
    y = coleman.liau.index
  ))

cp1 + 
  geom_point(mapping=aes(
    y = dale.chall.readability.score
  ))

cp1 + 
  geom_point(mapping=aes(
    y = difficult.words
  ))

cp1 + 
  geom_point(
    mapping = aes(
      y = flesch.kincaid.grade,
  )) 

cp1 +
  geom_point(
    mapping = aes(
      y = flesch.reading.ease,
  ))

cp1 + 
  geom_point(
    mapping = aes(
      y = gunning.fog,
    )) 

cp1 +
  geom_point(
    mapping = aes(
      y = linsear.write.formula,
    ))

cp1 + 
  geom_point(mapping=aes(
    y = smog.index
  ))

cp1 +
  geom_point(mapping=aes(
   y = polarity
  ))

#one difficulty metric vs another
cp2 <- ggplot(data=df_classics, mapping = aes(x = dale.chall.readability.score))
cp2 + 
  geom_point(
    mapping = aes(
      y = flesch.kincaid.grade
    ))

#Polarity vs subjectivity
ggplot(data = df_classics) +
  geom_point(mapping = aes(
    x = subjectivity,
    y = polarity
  ))
