# read in common data
labl_actv <- read.table("activity_labels.txt")
var_names <- read.table("features.txt")
variables <- as.character(var_names[,2])

# read in training data
train_data <- read.table("./train/X_train.txt")
train_labl <- read.table("./train/y_train.txt")
train_subj <- read.table("./train/subject_train.txt")

test_data <- read.table("./test/X_test.txt")
test_labl <- read.table("./test/y_test.txt")
test_subj <- read.table("./test/subject_test.txt")

# combine train data with its labels and subjects 
train_data <- cbind(train_labl, train_subj, train_data)

# combine test data with its labels and subjects
test_data <- cbind(test_labl, test_subj, test_data)

# 1. Merges the training and the test sets to create one data set
data_set <- rbind(test_data, train_data)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement
# find all the variable names that has either mean or std - case-insensitive
tmp_idx <- grep("mean\\(\\)|std\\(\\)", variables, ignore.case=TRUE)
# column indexes to be extracted
column_idx <- c(1, 2, tmp_idx+2)
data_set <- data_set[column_idx]

# 3. Uses descriptive activity names to name the activities in the data set
data_set <- merge(labl_actv, data_set, by.x=1, by.y=1) 

# 4. Appropriately labels the data set with descriptive variable names
# get rid of parenthesis and others
var_names <- make.names(variables[tmp_idx])
var_names <- gsub("[\\.]+", "\\.", var_names)
var_names <- gsub("\\.$", "", var_names)
var_names <- gsub("\\.", "_", var_names)
names(data_set) <- c("activity_code", "activity_name", "subject_code", var_names)

# 5. From the data set in step 4, creates a second, independent tidy data set 
#         with the average of each variable for each activity and each subject
tidy_data <- aggregate(. ~ activity_name + subject_code + activity_code, data=data_set, mean) 

# write out data set
write.table(tidy_data, file="tidy_data.txt", row.name=FALSE)

# prepare and write out code book
cb_names <- names(tidy_data)
cb_descs <- gsub("_", " ",cb_names)
cb_descs <- gsub("([a-z])([A-Z])", "\\1 \\2",cb_descs)
cb_descs <- gsub("^t ", "Time ",cb_descs)
cb_descs <- gsub("^f ", "Frequency ",cb_descs)
cb_descs <- gsub("^(.*) mean *(.*)$", "Average Mean Value of \\1 \\2", cb_descs)
cb_descs <- gsub("^(.*) std *(.*)$", "Average Standard Deviation of \\1 \\2", cb_descs)
cb_descs <- gsub(" X$", " on the x-axis",cb_descs)
cb_descs <- gsub(" Y$", " on the y-axis",cb_descs)
cb_descs <- gsub(" Z$", " on the z-axis",cb_descs)
cb_descs <- gsub(" Acc", " Acceleration",cb_descs)
cb_descs <- gsub(" Mag", " Magnitude",cb_descs)
cb_descs <- gsub(" Gyro", " Gyroscope Velocity",cb_descs)
cb_descs <- gsub("(^|[[:space:]])([[:alpha:]])", "\\1\\U\\2", cb_descs, perl=TRUE)
len1 <- max(nchar(cb_names))+1
len2 <- max(nchar(cb_descs))
cbframe <- cbind(as.data.frame(cb_names), as.data.frame(cb_descs))
tt <- row.names(cbframe)
row.names(cbframe) <- gsub("^([1-9])$", "0\\1", row.names(cbframe))
cbframe <- format(cbframe, justify="left", width=c(3, len1, len2))
write.table(cbframe, "CodeBook.txt", quote=FALSE, col.names=FALSE)


