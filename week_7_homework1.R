library(tidyverse)
library(ggplot2)
gapminder
str(gapminder)

#get 2002 and 2007 pop for each country, row for country, column for pop, add continent 
gapminder_pop <- gapminder %>%
  filter(year %in% c(2002,2007 )) %>%
  select(country,year,continent,pop) %>%
  pivot_wider(names_from = year, values_from = pop,names_prefix = "year_") %>% 
  mutate(pop_dif = year_2007 - year_2002)
head(gapminder_pop)
# A tibble: 6 × 5
#country     continent year_2002 year_2007 pop_dif
#<chr>       <chr>         <dbl>     <dbl>   <dbl>
#1 Afghanistan Asia       25268405  31889923 6621518
#2 Albania     Europe      3508512   3600523   92011
#3 Algeria     Africa     31287142  33333216 2046074
#4 Angola      Africa     10866106  12420476 1554370
#5 Argentina   Americas   38331121  40301927 1970806
#6 Australia   Oceania    19546792  20434176  887384


#ggplot, sort by continent, (x= country, y= pop_dif)
gapminder_pop <- gapminder_pop %>%
  filter(continent != "Oceania") %>%  #Oceania value is lower,so remove it
  mutate(country = fct_reorder(country, pop_dif)) #organize value from low to high


ggplot(gapminder_pop,aes(x= country, y= pop_dif)) +
  geom_col(aes(fill=continent)) +
  facet_wrap(~continent, scales = "free") + #group by continent
  theme_bw() +
  scale_fill_viridis_d() +
  theme(axis.text.x = element_text(angle=45,hjust=1), legend.position = "none") +
  labs(x ="Country", y="Change in Population Between 2002 and 2007")
