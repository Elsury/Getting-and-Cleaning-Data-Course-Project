# 1. Merge the training and the test sets to create one data set.

temp_HAR <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp_HAR)
unzip(temp_HAR)

setwd("//hermes/video/Coursera/Data Science/Getting and Cleaning Data/Quiz/Project/UCI HAR Dataset")

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

colnames(x_train)        = "features[,2]"; 
colnames(y_train)        = "activityId";
colnames(subject_train)  = "subjectId";

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

colnames(x_test)       = "features[,2]"; 
colnames(y_test)       = "activityId";
colnames(subject_test) = "subjectId";

x_data = rbind (x_train,x_test)
y_data = rbind(y_train,y_test)               
subjects = rbind(subject_train, subject_test)
final_data = cbind (x_data,y_data,subjects,header = TRUE)

# 2. Extract only the measurements on the mean and standard deviation for each measurement

features <- read.table ("features.txt")
meansd_data <- grep ("(mean|std)\\(\\)",features[,2],2)
x_data <- final_data[,meansd_data]
names(x_data) <- features[meansd_data, 2]

# 3.Uses descriptive activity names to name the activities in the data set

activities <- read.table ("activity_labels.txt")
y_data [,1] <- activities[y_data [,1],2]
names(y_data) <- "activity"

# 4. Appropriately label the data set with descriptive variable names
names(subjects) <- "subject"

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
# for each activity and each subject.

overage_subs <- ddply (final_data, c("subject", "activity"), function (x) colMeans(x[1:66],na.rm=TRUE))
write.table (overage_subs, "cleandata.txt") 
