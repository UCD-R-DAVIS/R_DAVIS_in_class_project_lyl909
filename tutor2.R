install
library(tidyverse)
install.packages("tidyverse")
install.packages("dplyr")
surveys <- read_csv("data/portal_data_joined.csv")

library(dplyr)
library(tidyverse)
str(surveys)
surveys %>% filter(month == 1)

#select columns
month_day_year <- select(surveys,month,day,year)

year_1981 <-filter(surveys, year==1981)
year_1981_baser <- surveys[surveys$year == 1981,]


identical(year_1981,year_1981_baser)
          
sum(year_1981$year !=1981, na.rm=T). #what's wrong?


#filtering by range
surveys <- surveys[surveys$year %in% 1981:1983,]
str(surveys)
the80s <- surveys[surveys$year %in% 1981:1983,]
the80stidy <- filter(surveys, year %in% 1981:1983)
str(the80stidy)


#filtering by multiple conditions
# & in the middle-and.  
bigfoot_with_weight<-filter(
  surveys,hindfoot_length >40 & !is.na(weight)
)


#multi-step process
small_animal <- filter(surveys, weight <5)

# this is slightly dangerous because you have to remember
# to select from small_anmials, not surveys in the next step


#same process,using nested functions

#Cmd Shift M
#%>%
#|>
#note our select function no longer explicitly calls the tibble
  #as its first element
small_animal_ids <- surveys %>% filter(.,weight < 5) %>%
  select(.,record_id, plot_id, species_id)

#good:
surveys %>%
  filter(month==1)


str(small_animal_ids)




table(mini$species_id)
#how many rows have a species ID that's either DM or NL?
nrow(mini)
mini %>% 



small_animal_ids <- select(filter(surveys, weight <5)
                           record_id,
                           plot_id,species_id)




the80stidy <- filter(surveys,year == c(1981:1983)). # wrong
