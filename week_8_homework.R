library(tidyverse)
library(lubridate)
library(dplyr)
library(ggplot2)

## read Doc from Github
mloa <- read_csv("https://raw.githubusercontent.com/gge-ucd/R-DAVIS/master/data/mauna_loa_met_2001_minute.csv")
class(mloa)
str(mloa)
summary(mloa)


## remove NA in rel_humid, temp_C_2m, and windSpeed_m_s
mloa <- mloa %>%
  filter(rel_humid != -99) %>%
  filter(temp_C_2m != -999.9) %>%
  filter(windSpeed_m_s != -99.9) %>%
  ## create datetime by year, month, day, hour24, and min columns
  ## UTZ - original time
  mutate(datetime = ymd_hm(paste0(year,"-", month,"-", day,"-", hour24,":", min),tz="UTC") )%>%
  ## create a column called “datetimeLocal” 
  ## converts the datetime column to Pacific/Honolulu time
  mutate(datetimelocal = with_tz(datetime, tz ="Pacific/Honolulu"))

## calculate the mean hourly temperature each month 
## using the temp_C_2m column and the datetimeLocal columns
mloa <- mloa %>%
  mutate(month_loc = month(datetimelocal, label = TRUE), hour_loc = hour(datetimelocal)) %>%
  ## sort by month_loc/ hour_loc
   group_by(month_loc, hour_loc) %>%
  ## take meantemp from same hour in dif rows
  summarize(meantemp = mean(temp_C_2m, na.rm = TRUE))
head(mloa)

  ## generate graph
  ggplot(mloa, aes( x= month_loc, y= meantemp)) + 
  geom_point(aes(col = hour_loc)) +
  scale_color_viridis_c() + 
  labs(x= "Local Month", y= "Mean Temperature(degrees C)") +
    theme_classic()
