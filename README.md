# Course Project for Data Science 3 - Getting and Cleaning Data 

## A Desciption of How Script run_ analysis.R Works for  

### 0. Read in Data
   First read in common data from files activity_labels.txt and features.txt,
   then read in training data from file ./train/X_train.txt, ./train/y_train.txt, ./train/subject_train.txt
   and ombine train data with its labels and subjects. Perform the same for test data. 
   We have two data frames at this point, one for training set and one for test set.

### 1. Merges the training and the test sets to create one data set
   The two data sets have the same columns, we can merge them into one data set with rbind().

### 2. Extracts only the measurements on the mean and standard deviation for each measurement
   The mean and standard deviation measurements are found by searching the feature names that has either mean() or std().
   The grep function returns column indexes that is used for subsetting except that we need to adjust by 2 because we
   inserted labels and subjects as first and second columns in the data set.

### 3. Uses descriptive activity names to name the activities in the data set
   This can be achieved by merging the data set with activity_labels on activity_code. 
   (The activity_code column can be dropped afterward, but I keep it in the data frame since it seems to provide a link to the original)

### 4. Appropriately labels the data set with descriptive variable names
   At this step, most efforts are to get rid of parenthesis and others characters in the feature names. Filter through make.names(), 
   then replace multiple dots with one and remove the dot if it is the last character. Finally, replace dot with underscore '_' 
   to make variable more readable.

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
   This is achieved by invoking function aggregate() on . ~ activity_name + subject_code + activity_code. 
   Finally write out tidy data set into file tidy_data.txt by invoking write.table().

### 6. Code Book
   Optionally, I added R code to prepare code book entries and write them out to file CodeBook.txt, which lists each variable in the format of 
Column #, Variable Name, Definition.
