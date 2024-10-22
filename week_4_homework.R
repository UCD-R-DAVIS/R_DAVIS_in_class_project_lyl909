install.packages("tidyverse")
library(tidyverse) # load tidyverse package

surveys <- read_csv("data/portal_data_joined.csv") #read survey data
class(surveys)
#"spec_tbl_df" "tbl_df"      "tbl"         "data.frame" 

surveys_30_60 <- surveys %>%
  filter(weight >=30 & weight <= 60) #keep rows with weight between 30 and 60
head(surveys_30_60) # the first 6 rows
#A tibble: 6 × 13
#record_id month   day  year plot_id species_id sex   hindfoot_length weight
#<dbl> <dbl> <dbl> <dbl>   <dbl> <chr>      <chr>           <dbl>  <dbl>
# 1      5966     5    22  1982       2 NL         F                  32     40
#2       226     9    13  1977       2 DM         M                  37     51
#3       233     9    13  1977       2 DM         M                  25     44
#4       245    10    16  1977       2 DM         M                  37     39
#5       251    10    16  1977       2 DM         M                  36     49
#6       257    10    16  1977       2 DM         M                  37     47
# ℹ 4 more variables: genus <chr>, species <chr>, taxa <chr>, plot_type <chr>


#Create a new tibble 
#showing the maximum weight for each species + sex combination
#and name it biggest_critters
biggest_critters <- surveys %>%
  filter(!is.na(weight)) %>% #remove weight
  group_by(species, sex) %>% #group by species & sex
  summarise(max_weight = max(weight)) # count the max weight of each species & sex

biggest_critters %>% arrange(max_weight) # from lightest to heaviest
## A tibble: 59 × 3
## Groups:   species [22]
#species      sex   max_weight
#<chr>        <chr>      <dbl>
#1 flavus       NA             8
#2 taylori      M              9
#3 montanus     M             11
#4 montanus     F             13
#5 fulvescens   M             15
#6 megalotis    NA            16
#7 eremicus     NA            18
#8 intermedius  NA            18
#9 penicillatus NA            18
#10 taylori      F             18
# ℹ 49 more rows

biggest_critters %>%
  arrange(desc(max_weight)) #from heaviest to lightest  
## A tibble: 59 × 3
##Groups:   species [22]
#species     sex   max_weight
#<chr>       <chr>      <dbl>
#1 albigula    M            280
#2 albigula    F            274
#3 albigula    NA           243
#4 fulviventer F            199
#5 spectabilis F            190
#6 spectabilis M            170
#7 spectabilis NA           152
#8 hispidus    F            140
#9 hispidus    NA           130
#10 spilosoma   M            130
# ℹ 49 more rows

surveys %>% 
  filter(is.na(weight)) %>% #select the NA value in weight
  group_by(species) %>% #chose species group
  tally() %>%
  arrange(desc(n))
## A tibble: 37 × 2
# species          n
#<chr>        <int>
#1 harrisi        437
#2 merriami       334
#3 bilineata      303
#4 spilosoma      246
#5 spectabilis    160
#6 ordii          123
#7 albigula       100
#8 penicillatus    99
#9 torridus        89
#10 baileyi         81
# ℹ 27 more rows

surveys %>% 
  filter(is.na(weight)) %>% 
  group_by(plot_id) %>% #chose plot_id group
  tally() %>% 
  arrange(desc(n))
## A tibble: 24 × 2
#     plot_id     n
#<dbl> <int>
#1      13   160
#2      15   155
#3      14   152
#4      20   152
#5      12   144
#6      17   144
#7      11   119
#8       9   118
#9       2   117
#10      21   106
# ℹ 14 more rows

surveys %>% 
  filter(is.na(weight)) %>% 
  group_by(year) %>% #chose year group
  tally() %>% 
  arrange(desc(n))
# A tibble: 26 × 2
    #year     n
#<dbl> <int>
#1  1977   221
#2  1998   195
#3  1987   151
#4  1988   130
#5  1978   124
#6  1982   123
#7  1989   123
#8  1991   108
#9  2002   108
#10  1992   106
# ℹ 16 more rows

surveys %>% 
  filter(is.na(weight)) %>% 
  group_by(month) %>% #chose month group
  tally() %>% 
  arrange(desc(n))
# A tibble: 12 × 2
#       month     n
#      <dbl> <int>
# 1     3   311
# 2     7   265
# 3     9   245
# 4     4   217
# 5     8   216
# 6     5   198
# 7     6   193
# 8    10   193
# 9     1   188
# 10     2   180
# 11    12   161
# 12    11   136

#Take surveys, remove the rows where weight is NA 
#and add a column that contains the average weight of each species+sex combination 
#Then get rid of all the columns except for species, sex, weight, and your new average weight column. 
#Save this tibble as surveys_avg_weight.

surveys_avg_weight <- surveys %>% #create surveys_avg_weight tibble
  filter(!is.na(weight)) %>% #remove the rows where weight is NA 
  group_by(species_id, sex) %>% #select each species+sex combination 
  mutate(aveg_weight = mean (weight)) %>%  #calculate the average of selection weight
  select(species_id,sex,weight,aveg_weight)
surveys_avg_weight

## A tibble: 32,283 × 4
## Groups:   species_id, sex [64]
#species_id sex   weight aveg_weight
#<chr>      <chr>  <dbl>       <dbl>
#1 NL         M        218        166.
#2 NL         M        204        166.
#3 NL         M        200        166.
#4 NL         M        199        166.
#5 NL         M        197        166.
#6 NL         M        218        166.
#7 NL         M        166        166.
#8 NL         M        184        166.
#9 NL         M        206        166.
#10 NL         F        274        154.
# ℹ 32,273 more rows


#add a new column called above_average
#contains logical values stating whether or not a row’s weight is above average for its species+sex combination
#recall the new column we made for this tibble
surveys_avg_weight <- surveys_avg_weight %>%
  mutate(above_average = weight >aveg_weight)
surveys_avg_weight
## A tibble: 32,283 × 5
## Groups:   species_id, sex [64]
#species_id sex   weight aveg_weight above_average
#<chr>      <chr>  <dbl>       <dbl> <lgl>        
#1 NL         M        218        166. TRUE         
#2 NL         M        204        166. TRUE         
#3 NL         M        200        166. TRUE         
#4 NL         M        199        166. TRUE         
#5 NL         M        197        166. TRUE         
#6 NL         M        218        166. TRUE         
#7 NL         M        166        166. TRUE         
#8 NL         M        184        166. TRUE         
#9 NL         M        206        166. TRUE         
#10 NL         F        274        154. TRUE         
# ℹ 32,273 more rows





