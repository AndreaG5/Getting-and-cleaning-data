filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}
###creating datasets

features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("n", "activity"))
activity <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("code", "functions"))
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$activity)
y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt", col.names = "code")
subj_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$activity)
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt", col.names = "code")
subj_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

###Merge training and test sets

X <- rbind(x_test, x_train)
Y <- rbind(y_test, y_train)
subject <- rbind(subj_test, subj_train)
mergedata <- cbind(X, Y, subject)

###extract mean, sd, for each measurement

tidy_data <- mergedata %>% select(subject, code, contains("mean"), contains("std"))

### uses descriptive activity names to name the activities (my features) in the data set

tidy_data$code <- activity[tidy_data$code , 2]

###appropriately labels the data set with descriptive variable names
names(tidy_data) <- gsub("Acc", "Acceletometer", names(tidy_data))
names(tidy_data) <- gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data) <- gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data) <- gsub("^t", "Time", names(tidy_data))
names(tidy_data) <- gsub("^f", "Frequency", names(tidy_data))
names(tidy_data) <- gsub(".mean()", "Mean", names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub(".std()", "STD", names(tidy_data), ignore.case = TRUE)
names(tidy_data) <- gsub(".angle()", "Angle", names(tidy_data), ignore.case = TRUE)

###create a second data set with the average of each variable for each activity and each subject

new_tidy <- melt(tidy_data, id = c("subject", "code"))
new_tidy_mean <- dcast(new_tidy, subject + code ~ variable, mean)
