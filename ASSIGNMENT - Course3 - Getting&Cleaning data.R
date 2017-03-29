# Downloading and unzipping dataset
if(!file.exists("/Users/marinaz/Desktop/R STUDIO FILES/Getting_Cleaning_data/assignment_getandcleandatacourse"))
        {dir.create("/Users/marinaz/Desktop/R STUDIO FILES/Getting_Cleaning_data/assignment_getandcleandatacourse")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# When you are naming your file:
# You have to put the extension: .zip beacuse you are downloading the zip file
download.file(fileUrl,destfile="/Users/marinaz/Desktop/R STUDIO FILES/Getting_Cleaning_data/assignment_getandcleandatacourse.zip")

# Unzip dataSet to your /data directory
unzip(zipfile="/Users/marinaz/Desktop/R STUDIO FILES/Getting_Cleaning_data/assignment_getandcleandatacourse.zip",
exdir="/Users/marinaz/Desktop/R STUDIO FILES/Getting_Cleaning_data/assignment_getandcleandatacourse")

# 1) Merging the training and the test sets to create one data set

# Reading trainings tables:
x_train <- read.table("/Users/marinaz/Desktop/R STUDIO FILES/Getting_Cleaning_data/assignment_getandcleandatacourse/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("/Users/marinaz/Desktop/R STUDIO FILES/Getting_Cleaning_data/assignment_getandcleandatacourse/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("/Users/marinaz/Desktop/R STUDIO FILES/Getting_Cleaning_data/assignment_getandcleandatacourse/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("/Users/marinaz/Desktop/R STUDIO FILES/Getting_Cleaning_data/assignment_getandcleandatacourse/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("/Users/marinaz/Desktop/R STUDIO FILES/Getting_Cleaning_data/assignment_getandcleandatacourse/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("/Users/marinaz/Desktop/R STUDIO FILES/Getting_Cleaning_data/assignment_getandcleandatacourse/UCI HAR Dataset/test/subject_test.txt")

# Reading the "features" vector:
features <- read.table('/Users/marinaz/Desktop/R STUDIO FILES/Getting_Cleaning_data/assignment_getandcleandatacourse/UCI HAR Dataset/features.txt')


# Merging all data into a single set:
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

mrg_train <- cbind(y_train, subject_train, x_train)
nrow(mrg_train)
mrg_test <- cbind(y_test, subject_test, x_test)
nrow(mrg_test)
setAllInOne <- rbind(mrg_train, mrg_test)

# Verify that the number of rows is the sum of the above 2 sets
nrow(setAllInOne)
# Verify
head(colnames(setAllInOne),3)


# 2) Extracting only the measurements of the mean and standard deviation 
# for each measurement

# Reading the column names:
colNames <- colnames(setAllInOne)

# Create the vector for extracting ID, mean and the standard deviation:
mean_and_std <- (grepl("activityId" , colNames) | 
                         grepl("subjectId" , colNames) | 
                         grepl("mean.." , colNames) | 
                         grepl("std.." , colNames) 
)

# Making the subset from: setAllInOne:
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]


# 3) Using descriptive activity names to name the activities in the data set:
# Reading activity labels:
activityLabels = read.table('/Users/marinaz/Desktop/R STUDIO FILES/Getting_Cleaning_data/assignment_getandcleandatacourse/UCI HAR Dataset/activity_labels.txt')
colnames(activityLabels)

# Hence,you have to assign the NEW column names:
colnames(activityLabels) <- c('activityId','activityType')
colnames(activityLabels)

# 4) Appropriately label the data set with descriptive variable names
Data <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)
head(colnames(Data,3))
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

head(colnames(Data,3))

# Creating a second, independent tidy data set with the average of each variable 
# for each activity and each subject

# Making second tidy data set
library(plyr)
secTidySet <- aggregate(. ~subjectId + activityId, Data, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
head(colnames(secTidySet),8)

# Export the tidyData set into the text file
write.table(secTidySet, '/Users/marinaz/Desktop/R STUDIO FILES/Getting_Cleaning_data/assignment_getandcleandatacourse/tidyData.txt',row.names=TRUE,sep='\t')
