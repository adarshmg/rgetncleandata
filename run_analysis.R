##
# The various steps involved in arriving at the data is discussed below.
# 

# Download data and save
filenm <- "wearable_computing_data.zip"
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile= filenm)
unzip(filenm)
setwd("UCI HAR Dataset")

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

# Add a column to the train data data frame identifying the partition
# from which the data was taken.
train_data[,"data_type"] <- "TRAIN"

# Read the files in the test directory and load them to data frames.
test_x_data <- read.table("test//X_test.txt")
test_y_data <- read.table("test//Y_test.txt")
test_subject <- read.table("test//subject_test.txt")

# name the column in test subject data frame as subject and similarly
# for activity file.
names(test_subject) <- c("subject_id")
names(test_x_data) <- features$V2
names(test_y_data) <- c("activity_id")

# column bind the activity and subject ids to the test_x_data dataframe
# and 
test_data <- cbind(test_x_data,test_subject["subject_id"])
test_data <- cbind(test_data,test_y_data["activity_id"])

# Add a column to the test data data frame identifying the partition
# from which the data was taken.
test_data[,"data_type"] <- "TEST"



library(dplyr)
# row bind the test and train data frames.
## 1. Merges the training and the test sets to create one data set.
mergedDataSet <- rbind(train_data,test_data)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# select columns from the merged data frame containing columns for mean, standard deviation, the ids and
# data types.
mergedSubSet <- select(mergedDataSet,contains("mean()"),contains("std()"),contains("_id"),data_type)

## 3. Uses descriptive activity names to name the activities in the data set
##
# merge the subset with activity labels to make the activity more descriptive.
mergedDescriptiveSet <- merge(mergedSubSet,activity_labels,by="activity_id")

## 4. Appropriately labels the data set with descriptive variable names, labelling part has already been covered in the above sets.

# Remove the activity id column from the descriptive set 
mergedDescriptiveSet<-select(mergedDescriptiveSet,-activity_id)

## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr)

# Define the group and data columns for teh ddply statement to work.
groupcols <- c("subject_id", "activity", "data_type")

# Take the first 66 columns which correspond to mean and std dev, as
# in the current structure, keys are at the end.
datacols <- colnames(mergedDescriptiveSet)[1:66]
# Use ddply command using colMeans to calculate the means of the numeric colums exclude the NA cells.
tidyData <- ddply(mergedDescriptiveSet,groupcols, function(x) colMeans(x[datacols],na.rm = TRUE))

# Print the tidy data.
tidyData