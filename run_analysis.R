

"Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject."

"Course Project: Getting and Cleaning Data"

#Load data sets from working directory
testX <- read.table("test/X_test.txt", header = FALSE)
testY <- read.table("test/Y_test.txt", header = FALSE)
trainX <- read.table("train/X_train.txt", header = FALSE)
trainY <- read.table("train/Y_train.txt", header = FALSE)
subjectTest <- read.table("test/subject_test.txt", header = FALSE)
subjectTrain <- read.table("train/subject_train.txt", header = FALSE)

#Merge Training and Test sets to create one dataset
activity <- rbind(testY, trainY)
features <- rbind(testX, trainX)
subject <- rbind(subjectTest, subjectTrain)


#Load activity labels
labels <- read.table("activity_labels.txt", header = FALSE)

#Match the appropriate activity label to corresponding factors
activity$V1 <- factor(activity$V1, levels = as.integer(labels$V1), labels = labels$V2)

#create appropriate names for activity and subject datasets
names(activity) <-c("activity")
names(subject)<-c("subject")

#create appropriate names for feature datasets
featurestxt <- read.table("features.txt", head=FALSE)
names(features) <- featurestxt$V2

#select columns that have mean and standard deviation data
columns <- c(as.character(featurestxt$V2[grep("mean\\(\\)|std\\(\\)", featurestxt$V2)]))

#subset mean and std dev columns
subdata <- subset(features,select=columns)

#combine like data with activity names and labels
subjectandactivity <- cbind(subject, activity)
final <- cbind(subdata, subjectandactivity)

#Appropriately label the dataset with descriptive variable names using gsub
names(final) <- gsub("^t", "time", names(final))
names(final) <- gsub("^f", "frequency", names(final))

#Finally, create the tidy dataset with subject and activity means
suppressWarnings(cleandata <- aggregate(final, by = list(final$subject, final$activity), FUN = mean))
colnames(cleandata)[1] <- "Subject"
names(cleandata)[2] <- "Activity"

#remove avergae and stdev for non-aggregated columns
cleandata <- cleandata[1:68]

#create a text file for tidydata.txt
write.table(cleandata, file = "tidydata.txt", row.name = FALSE)




