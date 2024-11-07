library(tidyverse)
library(ggplot2)#install packagrs ggplot2
gapminder <- read_csv("https://ucd-r-davis.github.io/R-DAVIS/data/gapminder.csv") 
str(gapminder)
library(dplyr)

## mean life expectancy on each continent
mean_lifeExp <- gapminder %>%
  group_by(continent) %>%
  summarize(mean_lifeExp=mean(lifeExp))
mean_lifeExp
# A tibble: 5 × 2
#continent mean_lifeExp
#<chr>            <dbl>
#1 Africa            48.9
#2 Americas          64.7
#3 Asia              60.1
#4 Europe            71.9
#5 Oceania           74.3

#create a plot that shows how life expectancy has changed over time in each continent
##do this all in one step using pipes
gapminder %>%
  group_by(continent,year) %>%
  summarize(mean_lifeExp=mean(lifeExp, na.rm=TRUE)) %>%
  ggplot(mapping=aes(x=year, y=mean_lifeExp,color=continent)) + 
  geom_point(alpha = 0.5) +geom_line() + labs(
    title = "Mean Life Expectancy Over Time by Continent",
    x = "Year",
    y = "Mean Life Expectancy"
  ) +theme_bw()


ggplot(data = gapminder, aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(color = continent), size = 0.5) +   
  scale_x_log10() + # Apply log scale to x-axis
  geom_smooth() + # Add a smoothing line
  labs(method = 'lm', color = 'black', linetype = 'dashed') +
  theme_bw()


##select five countries
##the data points in the backgroud using geom_jitter. 
##Label the X and Y axis with “Country” and “Life Expectancy” and title the plot “Life Expectancy of Five Countries”.
gapminder_five_countries <- gapminder %>%
  filter(country %in% c("Brazil", "China", "El Salvador", "Niger", "United States")) %>%
  ggplot(aes(x= country, y= lifeExp)) + 
  geom_boxplot()+geom_jitter(alpha = 0.5, color = "blue") +
  labs(title = "Life Expectancy of Five Countries", x= "country", y="Life Expenctancy" ) +
  theme_bw()
gapminder_five_countries    


