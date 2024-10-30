library("tidyverse")
library(dplyr)
data <- read.csv('https://raw.githubusercontent.com/ucd-cepb/R-DAVIS/refs/heads/main/data/tyler_activity_laps_10-24.csv')
str(data)

class(data)

summary(data)

## Filter out any non-running activities
str(data$sport)
data$sport <- as.factor(data$sport)

## Filter out the running lap data
data <- data %>%
  filter(sport == "running")
## only select running option and remove other activities
data
# minutes_per_mile, rm > 10 minutes_per_mile & < 5 minutes_per_mile; & total_elapsed_time_s < 60
data <- data %>%
  filter(minutes_per_mile > 5 & minutes_per_mile < 10) %>% ## the pace between 5 and 10 would be the running real pace
  filter(total_elapsed_time_s > 60)## only pick up the elapsed time over 60 s
data
summary(data)

## Create a new categorical variable, pace
data <- data %>%
  mutate (laps_by_pace = case_when(minutes_per_mile < 6 ~"fast",##“fast” (< 6 minutes-per-mile), “medium” (6:00 to 8:00), and “slow” ( > 8:00)
                                 minutes_per_mile >= 6 & minutes_per_mile <=8 ~"medium",minutes_per_mile > 8 ~"slow" ))
data <- data %>%
   mutate(years= case_when(year == 2024 ~"new", TRUE ~ "old")) ##form that distinguishes between laps run in the year 2024 (“new”, as Tyler started his rehab in January 2024) and all prior years (“old”)
 
str(data)
data$years <- as.factor(data$years) ##change character to factor
data$laps_by_pace <- as.factor(data$laps_by_pace)
str(data)
summary(data)
## sport           year          month             day         timestamp         total_distance_m  
## cycling          :   0   Min.   :2020   Min.   : 1.000   Min.   : 1.00   Length:6927        Min.   :   95.71  
## fitness_equipment:   0   1st Qu.:2021   1st Qu.: 3.000   1st Qu.: 8.00   Class :character   1st Qu.:  804.67  
## floor_climbing   :   0   Median :2021   Median : 5.000   Median :16.00   Mode  :character   Median : 1000.00  
## running          :6927   Mean   :2022   Mean   : 5.907   Mean   :16.07                      Mean   : 1151.38  
## swimming         :   0   3rd Qu.:2022   3rd Qu.: 9.000   3rd Qu.:24.00                      3rd Qu.: 1609.34  
## training         :   0   Max.   :2024   Max.   :12.000   Max.   :31.00                      Max.   :13032.17  
## walking          :   0                                                                                        
## minutes_per_mile total_elapsed_time_s avg_heart_rate_bpm steps_per_minute total_ascent_m    total_descent_m   laps_by_pace 
## Min.   :5.006    Min.   :  60.04      Min.   :105.0      Min.   :  2.0    Min.   :  0.000   Min.   :  0.000   fast  : 433  
## 1st Qu.:7.230    1st Qu.: 230.45      1st Qu.:139.0      1st Qu.:146.0    1st Qu.:  0.000   1st Qu.:  0.000   medium:3453  
## Median :7.859    Median : 325.16      Median :149.0      Median :150.0    Median :  3.000   Median :  2.000   slow  :3041  
## Mean   :7.829    Mean   : 349.13      Mean   :149.9      Mean   :149.9    Mean   :  8.856   Mean   :  8.478                
## 3rd Qu.:8.488    3rd Qu.: 473.80      3rd Qu.:160.0      3rd Qu.:152.0    3rd Qu.: 12.000   3rd Qu.: 11.000                
## Max.   :9.997    Max.   :3569.56      Max.   :196.0      Max.   :182.0    Max.   :155.000   Max.   :141.000                

## years     
## new: 392  
## old:6535  

avg_steps_per_minutes <- data %>%
  group_by(years,laps_by_pace) %>% ##group by form and pace
  summarize(avg_steps_per_minutes= mean(steps_per_minute, na.rm=TRUE)) %>%
  pivot_wider(names_from = laps_by_pace, values_from = avg_steps_per_minutes ) %>% 
  select(years,slow,medium,fast)
avg_steps_per_minutes
##years  slow medium  fast
##<fct> <dbl>  <dbl> <dbl>
##  1 new    163.   166.  172.
##  2 old    147.   149.  162.

##Summarize the minimum, mean, median, and maximum steps per minute results for all laps (regardless of pace category) 
##run between January - June 2024 and July - October 2024 for comparison.

data_2024 <- data %>%
  filter(years == 'new') %>%
  mutate(time= case_when(month>= 1 & month <=6 ~ "Jan_Jun" ,
                         month >=7 & month <=10 ~ "Jul_Oct"))
summary_steps <- data_2024 %>%
  group_by(time) %>%  # Assuming "time_period" is your time group (Jan-Jun, Jul-Oct)
  summarize(
    min_steps = min(steps_per_minute),
    mean_steps = mean(steps_per_minute),
    median_steps = median(steps_per_minute),
    max_steps = max(steps_per_minute)
  )

summary_steps
##A tibble: 2 × 5
##time    min_steps mean_steps median_steps max_steps
##<chr>       <int>      <dbl>        <int>     <int>
##1 Jan_Jun       148       162.          162       174
##2 Jul_Oct       156       171.          170       182