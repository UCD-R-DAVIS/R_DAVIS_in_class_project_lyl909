library(tidyverse)

tail <- read_csv('data/tail_length.csv')
surveys <- read_csv("data/portal_data_joined.csv")

dim(tail)
dim(surveys)
head(tail)

surveys_inner <- inner_join(x=surveys, y=tail)

surveys_left <- left_join(x= surveys, y=tail)

dim(surveys_left)
###[1] 34786    14


surveys_right <- right_join(x= surveys, y=tail)

dim(surveys_right) ##[1] 34786    14



surveys_full <- full_join(surveys,tail)
dim(surveys_full)
##[1] 34786    14

tail %>% select(-record_id)




dim(surveys_inner)
head(surveys_inner)




surveys_mz<- surveys%>%
  filter(!is.na(weight)) %>%
  group_by(genus, plot_id) %>%
  summarize(mean_wight = mean(weight))
surveys_mz
surveys_mz %>% pivot_wider(id_cols='genus',
              names_from= 'plot_id',
              values_from='mean_weight')

all(surveys$record_id %in% tail$record_id)
all(tail$record_id %in% surveys$record_id)
