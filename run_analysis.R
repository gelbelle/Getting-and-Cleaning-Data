library(dplyr)
library(reshape2)

if(!file.exists("./data")) {
   dir.create("./data")
}

#Download dataset
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "./data/dataset.zip")
unzip("./data/dataset.zip", exdir="./data")

#Read in testing data
xTest <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header=F)
str(xTest)
yTest <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header= F)
str(yTest)
testSub <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header=F)
str(testSub)

#Read in training data
xTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header=F)
str(xTrain)
yTrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header=F)
str(yTrain)
trainSub <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header=F)
str(trainSub)

#Read in features
features <- read.table("./data/UCI HAR Dataset/features.txt", header=F)
features <- features[,2]
str(features)

#Combine Test and Train
xData <- rbind(xTrain, xTest)
colnames(xData) <- features
str(xData)
subjects <- rbind(trainSub, testSub)

#Label the activity data
labels <- rbind(yTrain, yTest)
str(labels)
labels[labels == 1] <- "WALKING"
labels[labels == 2] <- "WALKING_UPSTAIRS"
labels[labels == 3] <- "WALKING_DOWNSTAIRS"
labels[labels == 4] <- "SITTING"
labels[labels == 5] <- "STANDING"
labels[labels == 6] <- "LAYING"

#Combine everything into one big dataframe
allData <- cbind(subjects, labels, xData)
colnames(allData)[1] <- "Subject"
colnames(allData)[2] <- "Activity"

str(allData)

#Create a dataframe containing just the mean and standard deviation information
summarized <- allData %>% select(Subject, Activity, contains("mean"), contains("std"))
str(summarized)

#Provide readable names for all the variables
names(summarized) <- names(summarized) %>% gsub("^t", "Time", .) %>% gsub("[[:punct:]]", "", .) %>% gsub("Acc", "Accelerometer", .) %>% gsub("mean", "Mean", .) %>% gsub("Gyro", "Gyroscope", .) %>% gsub("Mag", "Magnitude", .) %>% gsub("^f|Freq", "Frequency", .) %>% gsub("BodyBody", "Body", .) %>% gsub("gravity", "Gravity", .) %>% gsub("std", "StandardDeviation", .) %>% gsub("angle", "Angle", .) %>% gsub("tBody", "TimeBody",.)

#Set subject and activity as factors of the data
summarized$Subject <- as.factor(summarized$Subject)
summarized$Activity <- as.factor(summarized$Activity)

#Tidy the data to just show the average amount for each variable for each activity
melted <- melt(summarized, id = c("Subject", "Activity"))
tidy <- dcast(melted, Subject + Activity ~ variable, mean)
tidy
