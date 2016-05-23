########
## Getting and Cleaning Data Course Project
##
## assumptions: Running in Windows OS, all packages and library's loaded, and having downloaded the test files to the ./data directory
########

library(data.table)
library(dplyr)

#filter prep
labels <- read.table("./data/activity_labels.txt")
labels <- labels[,2]

features <- read.table("./data/features.txt")
features <- features[,2]

features_mean_std_filter <- grepl("mean[^F]|std", features)

#1. Merges the training and the test sets to create one data set.

test_x <- read.table("./data/test/X_test.txt")
test_y <- read.table("./data/test/y_test.txt")
test_subject <- read.table("./data/test/subject_test.txt")

#4. Appropriately labels the data set with descriptive variable names.
names(test_x) = features

#(part of #2. Extracts only the measurements on the mean and standard deviation for each measurement.)
test_x <- test_x[,features_mean_std_filter]
 

#4. Appropriately labels the data set with descriptive variable names.
test_y[,2] = labels[test_y[,1]]

#3. Uses descriptive activity names to name the activities in the data set
names(test_y) = c("ActivityValue", "ActivityName")
names(test_subject) = "subject"

test_data <- cbind(as.data.table(test_subject), test_y, test_x)

train_x <- read.table("./data/train/X_train.txt")
train_y <- read.table("./data/train/y_train.txt")
train_subject <- read.table("./data/train/subject_train.txt")

names(train_x) = features

#(part of #2. Extracts only the measurements on the mean and standard deviation for each measurement.)
train_x <- train_x[,features_mean_std_filter]

train_y[,2] = labels[train_y[,1]]

#3. Uses descriptive activity names to name the activities in the data set
names(train_y) = c("ActivityValue", "ActivityName")
names(train_subject) = "subject"

train_data <- cbind(as.data.table(train_subject), train_y, train_x)


merged_data = rbind(test_data, train_data)

#5, From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

by_actvity_subject <- group_by(merged_data, subject, ActivityName)
tidy_data_set <- summarize_each(by_actvity_subject, funs(mean))

write.table(tidy_data_set, file = "./tidy_data_set.txt")
