library(tidyverse)
library(dplyr)
library(purrr)

surveys <- read.csv("data/portal_data_joined.csv")

colnames(surveys)
str(surveys)


#taxa # pUsing a for loop, print to the console the longest species name of each taxon. 
for(i in unique(surveys$taxa)){ 
  tax = surveys[surveys$taxa == i,] 
  longestnames = tax[nchar(tax$species) == max(nchar(tax$species)),] %>% select(species)
  print(paste0(i, "="))
  print(unique(longestnames$species)) 
}
  ## Use the map function from purrr to print the max of each of the following columns
  mloa <- read_csv("https://raw.githubusercontent.com/ucd-cepb/R-DAVIS/master/data/mauna_loa_met_2001_minute.csv")
  maxi <-mloa %>% select(all_of(c("windDir","windSpeed_m_s",
                           "baro_hPa",
                           "temp_C_2m",
                           "temp_C_10m",
                           "temp_C_towertop",
                           "rel_humid",
                           "precip_intens_mm_hr")))
  
  
  max_values <- maxi %>% map(~ max(.x, na.rm = TRUE))
  print(max_values)
  
  
  ## converts Celsius to Fahrenhei

C_to_F <- function(x){
  x*1.8+32
}

mloa$temp_F_2m <- C_to_F(mloa$temp_C_2m)
mloa$temp_F_10m <- C_to_F(mloa$temp_C_10m)
mloa$temp_F_towertop <- C_to_F(mloa$temp_C_towertop)
View(mloa)              

##Bounce

newmloa <- mloa %>% select("temp_C_2m",
                           "temp_C_10m",
                           "temp_C_towertop") %>%
  map_df(.,C_to_F)%>% rename("temp_F_2m"="temp_C_2m",
                             "temp_F_10m"= "temp_C_10m",
                             "temp_F_towertop"= "temp_C_towertop")
bind_cols(mloa,)
head(newmloa)

##Challenge
surveys %>% mutate(genusspencies = lapply(
  1:nrow(surveys),function(i){
    paste0(surveys$genus[i], " ", surveys$species[i])}
  ))

