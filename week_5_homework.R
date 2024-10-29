library(tidyverse)
install.packages("tidyverse")
install.packages("dplyr")
surveys <- read_csv("data/portal_data_joined.csv") ##create a tibble
str(surveys)

## Question1
surveys_wide <- surveys %>%
  group_by(genus, plot_type) %>% ##with a column for genus and a column named after every plot type
  summarize(mean_hindfoot_length = mean(hindfoot_length, na.rm = TRUE)) %>% ##each columns contain the mean hindfoot length 
  pivot_wider(names_from = "plot_type", values_from = "mean_hindfoot_length" ) %>% ##a mean hindfoot length value for every plot type
  arrange(Control)

## Question2 
summary(surveys$weight)
## Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
## 4.00   20.00   37.00   42.67   48.00  280.00    2503 

surveys %>%
  mutate(weight_cat = case_when(weight <= 20.00 ~ "small",
                                weight > 20.00 & weight < 48.00 ~"medium",
                                TRUE ~ "large")) ##when weight shows NA, the weight_cat will be assigned as TRUE ~ large 
surveys %>%
  mutate(weight_cat = case_when(weight <= 20.00 ~ "small",
                                weight > 20.00 & weight < 48.00 ~"medium",
                                weight >= 48.00 ~ "large")) ##more accurate, when weight shows NA, the weight_cat will be NA, too
surveys %>%
  mutate(weight_cat = ifelse(weight <= 20.00, "small",
                             ifelse( weight > 20.00 & weight < 48.00, "medium", "large"))) ##when weight shows NA,the weight_cat will be NA, too

## Bonus
 summary_Q <- summary(surveys$weight)
summary_Q  
## summary_Q  
## Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
## 4.00   20.00   37.00   42.67   48.00  280.00    2503 

summary_Q[2]
summary_Q[5]
surveys %>%
  mutate(weight_cat = case_when(weight <= summary_Q[2] ~ "small",
                                weight > summary_Q[2] & weight < summary_Q[5] ~"medium",
                                weight >= summary_Q[5] ~ "large")) ##when weight shows NA,the weight_cat will be NA, too
