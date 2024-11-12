# Homework 3 Review -----
#Load your survey data frame with the read.csv() function. Create a new data frame called surveys_base with only the species_id, the weight, and the plot_type columns. Have this data frame only be the first 5,000 rows. 
surveys <- read.csv("data/portal_data_joined.csv")

surveys_base <- surveys[,c(6,9,13)]
surveys_base <- surveys[,c("species_id","weight","plot_type")]

surveys_base <- surveys[1:5000,c("species_id","weight","plot_type")]

#Convert both species_id and plot_type to factors. Remove all rows where there is an NA in the weight column. 
surveys_base$species_id <- factor(surveys_base$species_id) #$ tell R, we replace species_id in survey_base
str(surveys_base)


#Explore these variables and try to explain why a factor is different from a character. Why might we want to use factors? Can you think of any examples?




#CHALLENGE: Create a second data frame called challenge_base that only consists of individuals from your surveys_base data frame with weights greater than 150g.




#---------------------------------------------


# Data Manipulation Part 1b ----
# Goals: learn about mutate, group_by, and summarize
library(tidyverse)
surveys <- read_csv("data/portal_data_joined.csv")
str(surveys)


# Adding a new column
# mutate: adds a new column
surveys <- surveys %>%
  mutate(.,weight_kg = weight/1000)
head(surveys)
str(surveys)





# Add other columns
surveys <- surveys %>%
  mutate(.,
         weight_kg = weight/1000,
         weight_kg2 = weight_kg*2)
str(surveys)

surveys$weight_kg2 = as.characher(surveys$weight_kg2). #wrong
str(surveys)





# Filter out the NA's
ave_weight <- surveys %>%
  filter(!is.na(weight)) %>%
  mutate(mean_weight= mean(weight))


str(ave_weight)
nrow(ave_weight) #32283
ave_weight$mean_weight

ave_weight <- surveys %>%
  filter(complete.cases(.))
nrow(ave_weight) #30676




# Group_by and summarize ----
# A lot of data manipulation requires us to split the data into groups, apply some analysis to each group, and then combine the results
# group_by and summarize functions are often used together to do this
# group_by works for columns with categorical variables 
# we can calculate mean by certain groups
df <-surveys %>%
  group_by(sex) %>%
  mutate(mean_weight = mean(weight, na.rm = TRUE)) 
table(df$mean_weight)

# multiple groups

df <- surveys %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight, na.rm = TRUE))


summary(df)



# remove na's
surveys %>%
  group_by(sex, species_id) %>%
  filter(sex !="")%>%
  summarize(mean_weight = mean(weight, na.rm = TRUE)) %>%
  arrange(-mean_weight) #descending


# sort/arrange order a certain way


# Challenge
#What was the weight of the heaviest animal measured in each year? Return a table with three columns: year, weight of the heaviest animal in grams, and weight in kilograms, arranged (arrange()) in descending order, from heaviest to lightest. (This table should have 26 rows, one for each year)
d <- surveys %>%
  select(year, record_id,weight) %>%
  group_by(year) %>%
  filter(!is.na(weight)) %>%
  mutate(weight_kg=weight/1000)
nrow(d) #32283

d <- surveys %>%
  select(year, record_id,weight) %>%
  filter(!is.na(weight)) %>%
  mutate(weight_kg=weight/1000) %>%
  group_by(year) %>%
  summarize(max_weight_g=max(weight),
            max_weight_kg = max(weight)) %>%
  arrange()

nrow(d) 


#Try out a new function, count(). Group the data by sex and pipe the grouped data into the count() function. How could you get the same result using group_by() and summarize()? Hint: see ?n.