surveys <- read.csv("data/portal_data_joined.csv") #reading data in 
# create a new data frame "surveys_base" with only the "species_id", "weight", "plot_type" columns
surveys_base <- surveys[c("species_id", "weight", "plot_type" )] #selecting three columns
str(surveys_base) #test it

# only available first 5000 rows
surveys_base5000 <- surveys_base[1:5000,]
dim(surveys_base5000) #[1] 5000    3
head(surveys_base5000)
tail(surveys_base5000)
str(surveys_base5000) #'data.frame':	5000 obs. of  3 variables:$ species_id: chr; weight: int; plot_type : chr
summary(surveys_base5000)
data.frame(surveys_base5000) # turn data frame to column
surveys_base <- surveys_base5000
surveys_base

# convert both "species_id" and "plot_type" to factors
surveys_base$species_id <- as.factor(surveys_base$species_id) # $ <- database$continent
surveys_base$plot_type <- as.factor(surveys_base$plot_type)
str(surveys_base)
#'data.frame':	5000 obs. of  3 variables:
# $ species_id: Factor w/ 36 levels "AB","AH","BA",..: 12 12 12 12 12 12 12 12 12 12 ...
# $ weight    : Factor w/ 228 levels "4","5","6","7",..: NA NA NA NA NA NA NA NA 200 NA ...
# $ plot_type : Factor w/ 2 levels "Control","Long-term Krat Exclosure": 1 1 1 1 1 1 1 1 1 1 ...

#remove NA in weight column
surveys_base$weight[!is.na(surveys_base$weight)]
!is.na(surveys_base$weight) 
surveys_base[!is.na(surveys_base$weight),] # remove NA
surveys_base <- surveys_base[!is.na(surveys_base$weight),]
surveys_base
summary(surveys_base)
#summary(surveys_base)--times
# species_id       weight                        plot_type   
# PP     : 729   22     : 144   Control                 :2074  
# DM     : 720   24     : 135   Long-term Krat Exclosure:2558  
# PB     : 563   18     : 130                                  
# OT     : 421   17     : 128                                  
# RM     : 392   8      : 124                                  
# DO     : 387   23     : 122                                  
# (Other):1420   (Other):3849     
str(surveys_base)
#'data.frame':	4632 obs. of  3 variables:
# $ species_id: Factor w/ 36 levels "AB","AH","BA",..: 12 12 12 12 12 12 12 12 12 12 ...
# $ weight    : Factor w/ 228 levels "4","5","6","7",..: 200 191 188 187 185 200 157 174 192 227 ...
# $ plot_type : Factor w/ 2 levels "Control","Long-term Krat Exclosure": 1 1 1 1 1 1 1 1 1 1 ...


# Explore these variables and try to explain why a factor is different from a character
# Character is used to be textual data without a set of data, while factor is used to be categorical data. 
# The factor data can be assembled by groups. It can be easily counted or summary with other data in a same or different group.
# Example: 
gender_chr <-(c("Male", "Female", "Female", "Female", "Other"))
str(gender_chr)
#chr [1:5] "Male" "Female" "Female" "Female" "Other"
gender <- factor(c("Male", "Female", "Female", "Female", "Other"))
str(gender)
#Factor w/ 3 levels "Female","Male",..: 2 1 1 1 3

#create a second data frame "challenge_base" that only consists of individuals from surveys_base data frame with weight > 150g
str(surveys_base) # test the original database
surveys_base[surveys_base[ ,2] > 150, ]
summary(challenge_base)            
             
             
challenge_base <- surveys_base[surveys_base$weight > 150,] #set up the greater  
challenge_base
summary(challenge_base)
#summary(challenge_base)
#species_id      weight                         plot_type  
#NL     :193   Min.   :151.0   Control                 :131  
#DS     : 16   1st Qu.:166.0   Long-term Krat Exclosure: 78  
#AB     :  0   Median :184.0                                 
#AH     :  0   Mean   :189.8                                 
#BA     :  0   3rd Qu.:204.0                                 
#CB     :  0   Max.   :278.0                                 
#(Other):  0                