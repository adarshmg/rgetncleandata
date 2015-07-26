# Download data and save
filenm <- "wearable_computing_data.zip"
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile= filenm)

# Read activity labels file and name the columns
activity_labels <- read.table("activity_labels.txt")
names(activity_labels) = c("activity_id","activity")
features <- read.table("features.txt")

# Read the files in the train directory and load them to data frames.
train_x_data <- read.table("train//X_train.txt")
train_y_data <- read.table("train//Y_train.txt")
train_subject <- read.table("train//subject_train.txt")
# name the column in train subject dataframe as subject id
names(train_subject) <- c("subject_id")
names(train_x_data) <- features$V2
names(train_y_data) <- c("activity_id")
# Add the train subject and activity files to train data 
train_data <- cbind(train_x_data,train_subject["subject_id"])
train_data <- cbind(train_data,train_y_data["activity_id"])

test_x_data <- read.table("test//X_test.txt")
test_y_data <- read.table("test//Y_test.txt")
test_subject <- read.table("test//subject_test.txt")
names(test_subject) <- c("subject_id")
names(test_x_data) <- features$V2
names(test_y_data) <- c("activity_id")
test_data <- cbind(test_x_data,test_subject["subject_id"])
test_data <- cbind(test_data,test_y_data["activity_id"])
test_data[,"data_type"] <- "TEST"



library(dplyr)
mergedDataSet <- rbind(train_data,test_data)
mergedSubSet <- select(mergedDataSet,contains("mean()"),contains("std()"),contains("_id"),data_type)
mergedDescriptiveSet <- merge(mergedSubSet,activity_labels,by="activity_id")

library(plyr)
tidyData <- ddply(mergedDescriptiveSet,groupcols, function(x) colMeans(x[datacols],na.rm = TRUE))
tidyData