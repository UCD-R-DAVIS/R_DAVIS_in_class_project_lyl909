set.seed(15)
hw2 <- runif(50, 4, 50)
hw2 <- replace(hw2, c(4,12,22,27), NA)
hw2

# remove all the NAs from hw2
prob1 <- na.omit(hw2)
# choose the scale from 14 to 38
prob1 <-prob1[prob1>= 14 & prob1<=38]
prob1

# Mutiply each number in the "prob1" vector by 3 to create a new vector, "times 3"
times3 <- prob1 * 3
times3

# Add 10 to each number in "times3" vector to create "plus10"

plus10 <- times3 + 10
plus10

# Select every other number in "plus10" by selecting first number, not the second number, the third, not the fourth, etc
final_vector <- plus10[c(TRUE, FALSE)]
final_vector
