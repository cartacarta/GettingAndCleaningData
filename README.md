## Coursera:   Getting and Cleaning Data class
* Project:    Final course project
* CourseID:   get-data007
* Author:     Alejandro Gutierrez
* Created:    09/11/2014

### Notes: 
* The script assumes the working folder is "UCI HAR Dataset" and contains features.txt, activity_labels.txt and folders for train and test data
* The script requires the dplyr 2.1 library

The general logic for the script is:

1. Load the feature feature names and activity names into variables
2. Read train and test labels and then merge
3. Read train and test subjects and then merge
4. Read train and test feature vectors and then merge
5. Create a dplyr table by column bind Labels, Subjects, and Features into single table
6. Generate the final clean full set by:
   6a. Select only mean() and std() columns for each value using "contains"
   6b. Map ActivityIds to the ActivityNames using inner_join
   6c. Remove the ActivityId field that is no longer used as it was replaced by the ActivityName
7. From the cleaned data set create a second, independent tidy data set with the average of each variable for each activity and each subject:
   7a. Create a group_by by SubjectId and ActivityName
   7b. Use summarise_each function wich allows to apply the same function to all columns, in this case mean()
8. Write to file as specified in project (row.name=FALSE)


