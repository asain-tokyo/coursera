README
================

## Description

The experiments have been carried out with a group of 30 volunteers
within an age bracket of 19-48 years. Each person performed six
activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING,
STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the
waist. Using its embedded accelerometer and gyroscope, we captured
3-axial linear acceleration and 3-axial angular velocity at a constant
rate of 50Hz. The experiments have been video-recorded to label the data
manually. The obtained dataset has been randomly partitioned into two
sets, where 70% of the volunteers was selected for generating the
training data and 30% the test data.

**run\_analysis.R** merges the training data and test data with proper
column names, and adds an index for a volunteers (performer) and
activity (one of 6 activities). Then, creates a second, independent tidy
data set (mean\_dataset) with the average of each variable for each
activity and each performer.

Original data source: [Human Activity Recognition Using Smartphones Data
Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

Target data for this script: [Corsera
Project](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

## Data cleansing process

1.  reads the training data and the test data which include sampled data
    (X\_train.txt/X\_test.txt) and an activity (1:WALKING,
    2:WALKING\_UPSTAIRS, 3:WALKING\_DOWNSTAIRS, 4:SITTING, 5:STANDING,
    6:LAYING in Y\_train.txt/Y\_test.txt), and related information as
    follows.

<!-- end list -->

  - train\_x/test\_x : Triaxial acceleration, Triaxial angular velocity,
    … (561 feature vector)
  - train\_y/test\_y : Activty label for each window sample. (1-6:
    described in “activity\_labels.txt”)
  - train\_s/test\_s : Subject who performed the activity for each
    window sample. (1-30: volunteers to capture data)
  - features : colunm names for the feature vector e.g.
    (tBodyAcc-mean()-X, tBodyAcc-mean()\_Y, ..)
  - activities : list of activities (1:WALKING, 2:WALKING\_UPSTAIRS,
    3:WALKING\_DOWNSTAIRS, 4:SITTING, 5:STANDING, 6:LAYING)

<!-- end list -->

    train_x <- read.table("UCI HAR Dataset/train/X_train.txt")
    train_y <- read.table("UCI HAR Dataset/train/Y_train.txt")
    train_s <- read.table("UCI HAR Dataset/train/subject_train.txt")
    test_x <- read.table("UCI HAR Dataset/test/X_test.txt")
    test_y <- read.table("UCI HAR Dataset/test/Y_test.txt")
    test_s <- read.table("UCI HAR Dataset/test/subject_test.txt")
    features <- read.table("UCI HAR Dataset/features.txt")
    activities <- read.table("UCI HAR Dataset/activity_labels.txt")

2.  merges the training and the test sets for creating a single data
    set.

<!-- end list -->

  - total\_x : train\_x + test\_x (add column names - the feature list
    includes the feature vector)
  - total\_y : train\_y + test\_y
  - total\_s : train\_s + test\_s

<!-- end list -->

    total_x <- rbind(train_x, test_x)
    total_y <- rbind(train_y, test_y)
    total_s <- rbind(train_s, test_s)

3.  extracts labels from a feature vector file (features.txt), and
    labels the data set with descriptive variable names.

<!-- end list -->

    labels <-as.character(features[,2])
    colnames(total_x) = labels
    colnames(total_s) = c("Performer")

4.  extracts only the measurements on the mean (mean()) and standard
    deviation (std()) for each measurement.

<!-- end list -->

  - extract\_x : filtered table (only includes mean()/std() in a column
    name)

<!-- end list -->

    filters <-grep('mean\\(|std\\(', features[,2])
    extract_x <- total_x[, c(filters)]

5.  uses descriptive activity names
    (WALKING/WALKING\_UPSTAIRS/WALKING\_DOWNSTAIRS/SITTING/STANDING/LAYING
    instead of the number) to name the activities in the data
    set.

<!-- end list -->

    labeled_activities <- as.data.frame(factor(total_y[,1], labels=as.character(activities[,2])))
    colnames(labeled_activities) <- c("Activity")

5.  merges all tables and sorts by performers (subject) and activities
    for readability

<!-- end list -->

    cleansed_dataset <- cbind(labeled_activities, total_s, extract_x) 
    cleansed_dataset <- cleansed_dataset[order(cleansed_dataset$Activity, cleansed_dataset$Performer),]

6.  creates a second, independent tidy data set with the average of each
    variable

<!-- end list -->

    mean_dataset <- cleansed_dataset %>% group_by(Activity, Performer) %>% summarize_each(funs(mean))

## Dependency

library(dplyr)

## References

\[1\] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and
Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a
Multiclass Hardware-Friendly Support Vector Machine. International
Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz,
Spain. Dec 2012
