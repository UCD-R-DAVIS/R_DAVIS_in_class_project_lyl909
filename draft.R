sex <- factor(c("male", "female", "female", "male"))
levels(sex)
nlevels(sex)
food <- factor(c("low", "high", "medium", "high", "low", "medium", "high"))
levels(food)
food <- factor(food, levels=c("low", "medium", "high"))
levels(food)


f <- factor(c(1, 5, 10, 2))
as.numeric(f)               ## wrong! and there is no warning...
as.numeric(as.character(f))


numeric_cols <- sapply(mydata, is.numeric)
mydata[numeric_cols] <- lapply(mydata[numeric_cols], as.factor)
str(mydata)



# test convert to factor but fail
surveys_base 
species_id <- sapply(surveys_base,is.numeric)
surveys_base[species_id] <- lapply(surveys_base[species_id], as.factor)
plot_type <- sapply(surveys_base,is.numeric)
surveys_base[plot_type] <- lapply(surveys_base[plot_type], as.factor)
str(surveys_base)

surveys_base$species_id <- as.factor(surveys_base$species_id)
surveys_base$plot_type <- as.factor(surveys_base$plot_type)

surveys <- read.csv("data/portal_data_joined.csv")
# create a new data frame "surveys_base" with only the "species_id", "weight", "plot_type" columns
surveys_base <- surveys[c("species_id", "weight", "plot_type" )]
str(surveys_base)

surveys <- read.csv("data/portal_data_joined.csv") #reading data in 
# create a new data frame "surveys_base" with only the "species_id", "weight", "plot_type" columns
surveys_base <- surveys[c("species_id", "weight", "plot_type" )] #selecting three columns
str(surveys_base) #test it

# only available first 5000 rows
surveys_base <- surveys_base[1:5000,]
surveys_base
