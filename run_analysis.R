#
# Cleansing data from Smartphone
# 
# Data Source : https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 

library(dplyr)
# read training/test data

# train_x/test_x : Triaxial acceleration, Triaxial angular velocity, ... (561 feature vector)
# train_y/test_y : Activty label for each window sample. (1-6: described in "activity_labels.txt")
# train_s/test_s : Subject who performed the activity for each window sample.  (1-30: volunteers to capture data)

train_x <- read.table("UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_s <- read.table("UCI HAR Dataset/train/subject_train.txt")
test_x <- read.table("UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_s <- read.table("UCI HAR Dataset/test/subject_test.txt")

# read additional information
# features : colunm names for the feature vector e.g. (tBodyAcc-mean()-X, tBodyAcc-mean()_Y, ..)
# activities : list of activities (1:WALKING, 2:WALKING_UPSTAIRS, 3:WALKING_DOWNSTAIRS, 4:SITTING, 5:STANDING, 6:LAYING)

features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

# 1. merges the training and the test sets for creating a single data set. (step 1 in the assignment)
# total_x : train_x + test_x  (add column names - the feature list includes the feature vector)
# total_y : train_y + test_y
# total_s : train_s + test_s

total_x <- rbind(train_x, test_x)
total_y <- rbind(train_y, test_y)
total_s <- rbind(train_s, test_s)

# 2. appropriately labels the data set with descriptive variable names. (step 4 in the assignment)

labels <-as.character(features[,2])
colnames(total_x) = labels
colnames(total_s) = c("Performer")

# 3. extracts only the measurements on the mean (mean()) and standard deviation (std()) for each measurement.
# (step 4 in the assignment)
# extract_x : filtered table (only includes mean()/std() in a column name)

filters <-grep('mean\\(|std\\(', features[,2])
extract_x <- total_x[, c(filters)]

# 4. uses descriptive activity names to name the activities in the data set. (step 3 in the assignment)
labeled_activities <- as.data.frame(factor(total_y[,1], labels=as.character(activities[,2])))
colnames(labeled_activities) <- c("Activity")

# merge all tables and sorts by performers (subject) and activities for readability
cleansed_dataset <- cbind(labeled_activities, total_s, extract_x) 
cleansed_dataset <- cleansed_dataset[order(cleansed_dataset$Activity, cleansed_dataset$Performer),]

# 5. from the data set in step 4, creates a second, independent tidy data set with the average of each variable
# for each activity and each subject. (step 5 in the assignment)

mean_dataset <- cleansed_dataset %>% group_by(Activity, Performer) %>% summarize_each(funs(mean))


