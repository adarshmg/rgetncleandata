# Download data and save
filenm <- "wearable_computing_data.zip"
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile= filenm)

activity_labels <- read.table("activity_labels.txt")
names(activity_labels) = c("activity_id","activity")
features <- read.table("features.txt")

train_x_data <- read.table("train//X_train.txt")
train_y_data <- read.table("train//Y_train.txt")
train_subject <- read.table("train//subject_train.txt")
names(train_subject) <- c("subject_id")
names(train_x_data) <- features$V2
names(train_y_data) <- c("activity_id")
train_data <- cbind(train_x_data,train_subject["subject_id"])
train_data <- cbind(train_data,train_y_data["activity_id"])
train_data[,"data_type"] <- "TRAIN"




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
mergedDescriptiveSet<-select(mergedDescriptiveSet,-activity_id)

library(plyr)
tidyData <- ddply(mergedDescriptiveSet,groupcols, function(x) colMeans(x[datacols],na.rm = TRUE))
tidyData



#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject