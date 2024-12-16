install.packages("dplyr")
library(dplyr)
library(tidyverse)
install.packages("ggplot2")
library(ggplot2)


default <- read.csv(url("https://raw.githubusercontent.com/UCD-R-DAVIS/R-DAVIS/refs/heads/main/data/tyler_activity_laps_12-6.csv"))
head(default)
summary(default)

#2 Filter out any non-running activities
default$sport <- as.factor(default$sport) #from character to factor
running_data <- default %>% #select "running"
  filter(sport == "running")
print(running_data)

#3 Remove walking laps "over 10 minutes_per_mile"; abnormally fast laps "< 5 minute_per_mile pace"
#Remove abnormally short records where the total elapsed time is one minute or less
#4 Group by three periods
running_data <- running_data %>%
  filter(minutes_per_mile > 5 & minutes_per_mile < 10) %>%
  filter(total_elapsed_time_s > 60) %>%
  mutate(date = as.Date(paste(year, month, day, sep = "-"))) %>%
  mutate(
    time_period = case_when( ##Pre-2024; January to June 2024: July till now
      date < as.Date("2024-01-01") ~ "Pre-2024",
      date >= as.Date("2024-01-01") & date <= as.Date("2024-06-30") ~ "Jan-Jun 2024",
      date >= as.Date("2024-07-01") ~ "July 2024 to the present",
      TRUE ~ "Unknown"  
    )
  )
summary(running_data)
print(running_data)

#5 Make a scatter plot that graphs SPM over speed by lap
running_data <- running_data %>% 
  mutate(speed = total_distance_m / total_elapsed_time_s) 
ggplot(running_data, aes(x = speed, y = steps_per_minute, color = as.factor(sport))) +
  geom_point() + 
  labs(
    title = "Scatter Plot of Steps Per Minute vs Speed",
    x = "Speed (m/s)",  
    y = "Steps Per Minute (SPM)",
    color = "Sport"  
  ) +
  theme_bw()

#6 Make 5 aesthetic changes to the plot to improve the visual.

ggplot(running_data, aes(x = speed, y = steps_per_minute, color = as.factor(sport))) +
  geom_point(size = 3, shape = 21, fill = "pink", stroke = 1) + 
  labs(
    title = "Scatter Plot of Steps Per Minute vs Speed",
    subtitle = "(Tyler’s running data)",
    tag = "Figure 1",
    x = "Speed (m/s)",  
    y = "Steps Per Minute (SPM)",
    color = "Laps"  
  ) +
  theme_bw() + 
  theme(
    plot.title = element_text(hjust = 1, size = 20, face = "bold"), 
    plot.subtitle = element_text(hjust = 1, size = 15, face = "italic"),
    panel.grid.major.x = element_blank(),  
    panel.grid.major.y = element_line(color = "gray80", linetype = "dashed"), 
    legend.position = "top",  
    legend.title = element_text(size = 12, face = "bold"),
    legend.text = element_text(size = 10),
    legend.key.size = unit(1, "cm")
  )

#7 Add linear (i.e., straight) trendlines to the plot to show the relationship between speed and SPM for each of the three time periods
#(hint: you might want to check out the options for geom_smooth())
ggplot(running_data, aes(x = speed, y = steps_per_minute, color = as.factor(sport))) +
  geom_point(size = 3, shape = 21, fill = "pink", stroke = 1) + 
  geom_smooth(method = "lm", se = FALSE, aes(color = as.factor(time_period)), linetype = "solid") +
  labs(
    title = "Scatter Plot of Steps Per Minute vs Speed in Three Time Period",
    subtitle = "(Tyler’s running data)",
    tag = "Figure 2",
    x = "Speed (m/s)",  
    y = "Steps Per Minute (SPM)",
    color = "Laps"  
  ) +
  theme_bw() + 
  theme(
    plot.title = element_text(hjust = 1, size = 20, face = "bold"), 
    plot.subtitle = element_text(hjust = 1, size = 15, face = "italic"),
    panel.grid.major.x = element_blank(),  
    panel.grid.major.y = element_line(color = "gray80", linetype = "dashed"), 
    legend.position = "top",  
    legend.title = element_text(size = 12, face = "bold"),
    legend.text = element_text(size = 10),
    legend.key.size = unit(1, "cm")
  ) +
  facet_wrap(~ time_period)


#8 Focus just on post-intervention runs (after July 1, 2024). Make a plot (of your choosing) that shows SPM vs. speed by lap. 
# Use the timestamp indicator to assign lap numbers, assuming that all laps on a given day correspond to the same run (hint: check out the rank() function).
# Select only laps 1-3 (Tyler never runs more than three miles these days). 
# Make a plot that shows SPM, speed, and lap number (pick a visualization that you think best shows these three variables).

running_data$time_period <- as.factor(running_data$time_period) 
post_intervention <-  running_data %>%
  filter(time_period == "July 2024 to the present")

ggplot(post_intervention, aes(x = speed, y = steps_per_minute, color = as.factor(time_period))) +
  geom_point(size = 3, shape = 21, fill = "pink", stroke = 1) + 
  labs(
    title = "Scatter Plot of Steps Per Minute vs Speed during  (July-Present)",
    subtitle = "(Tyler’s running data)",
    tag = "Figure 3",
    x = "Speed (m/s)",  
    y = "Steps Per Minute (SPM)",
    color = "Laps"  
  ) +
  theme_bw()

post_intervention <- post_intervention %>% # assign lap number
  arrange(timestamp) %>%  
  group_by(date) %>%  
  mutate(lap_number = row_number()) %>%  
  ungroup()

post_intervention <- post_intervention %>% 
  filter(lap_number <= 3)

summary(post_intervention$lap_number) # check

ggplot(post_intervention, aes(x = speed, y = steps_per_minute, color = as.factor(lap_number))) +
  geom_point(size = 3, shape = 21, fill = "pink", stroke = 1) + 
  labs(
    title = "Scatter Plot of Steps Per Minute vs Speed during July-Present within 3 laps",
    subtitle = "(Tyler’s running data)",
    tag = "Figure 4",
    x = "Speed (m/s)",  
    y = "Steps Per Minute (SPM)",
    color = "Lap Number"
  ) +
  theme_bw() + 
  theme(
    plot.title = element_text(hjust = 1, size = 20, face = "bold"),
    plot.subtitle = element_text(hjust = 1, size = 15, face = "italic"),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "gray80", linetype = "dashed"),
    legend.position = "top",
    legend.title = element_text(size = 12, face = "bold"),
    legend.text = element_text(size = 10),
    legend.key.size = unit(1, "cm")
  )
