#################################################################
##  
##  Coursera:   Getting and Cleaning Data class
##  Project:    Final course project
##  CourseID:   get-data007
##  Author:     Alejandro Gutierrez
##  Created:    09/11/2014
##
##  Notes: this script assumes the working folder is "UCI HAR Dataset"
##         and contains features.txt, activity_labels.txt and folders
##         for train and test data
##
#################################################################

# this script requires the dplyr 2.1 library
library("dplyr", quietly=TRUE, warn.conflicts = FALSE)

# load the feature feature names and activity names into variables
featureNames <- read.table("features.txt", col.names = c("FeatureId","FeatureName"))
activityLabels <- read.table("activity_labels.txt", col.names = c("ActivityId","ActivityName"))

# read train and test labels and then merge
trainLabels <- read.table("./train/y_train.txt", col.names = c("ActivityId"))
testLabels <- read.table("./test/y_test.txt", col.names = c("ActivityId"))
labels <- rbind(trainLabels,testLabels)

# free memory
rm(trainLabels,testLabels)

# read train and test subjects and then merge
trainSubjects <- read.table("./train/subject_train.txt", col.names = c("SubjectId"))
testSubjects <- read.table("./test/subject_test.txt", col.names = c("SubjectId"))
subjects <- rbind(trainSubjects,testSubjects)

# free memory
rm(trainSubjects,testSubjects)

# read train and test feature vectors and then merge
trainFeatures <- read.table("./train/X_train.txt", col.names = featureNames$FeatureName)
testFeatures <- read.table("./test/X_test.txt", col.names = featureNames$FeatureName)
features <- rbind(trainFeatures,testFeatures)

# free memory
rm(trainFeatures,testFeatures)

# column bind Labels, Subjects, and Features into single table and create dplyr dataframe
df <- tbl_df(cbind(labels,subjects,features))

# free memory
rm(labels,subjects,features)

# Generate the final clean full set by keeping only mean() and std() columns for each value
# and replace ActivityIds by their name
cleanFullSet <- df %>% 
  select(SubjectId,ActivityId,contains("\\.(std|mean)\\.")) %>%   # select only std and mean values
  inner_join(activityLabels, by = "ActivityId") %>%   # get the ActivityName based on id
  select(-ActivityId) # remove ActivityId no longer used

# free memory
rm(df,activityLabels,featureNames)

# From the cleaned data set create a second, independent tidy data set with the average 
# of each variable for each activity and each subject.
allAveragesPerSubjectAndActivity <- cleanFullSet %>% 
                                    group_by(SubjectId,ActivityName) %>% 
                                    summarise_each(funs(mean))

# write to file 
write.table(allAveragesPerSubjectAndActivity,file="allAveragesPerSubjectAndActivity.txt",row.name=FALSE)
