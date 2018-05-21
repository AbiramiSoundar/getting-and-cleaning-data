fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("project_dataset")){
download.file(fileUrl, "project_dataset.zip", mode = "wb")
}
if(!file.exists("project_dataset")){
  unzip(zipfile = "project_dataset.zip")
}

#List the files 
path <- file.path("C:\\project-4\\project_dataset")
files <- list.files(path, recursive = TRUE)

#Read data from the files
#Read the Activity files
ActivityTest <- read.table(file.path(path, "test", "y_test.txt"), header = FALSE)
ActivityTrain <- read.table(file.path(path, "train", "y_train.txt"), header = FALSE)

#Read the Subject files
SubjectTest <- read.table(file.path(path, "test", "subject_test.txt"), header = FALSE)
SubjectTrain <- read.table(file.path(path, "train", "subject_train.txt"), header = FALSE)

#Read the Features files
FeaturesTest <- read.table(file.path(path, "test", "X_test.txt"), header = FALSE)
FeaturesTrain <- read.table(file.path(path, "train", "X_train.txt"), header = FALSE)

#Merging the test and train sets by rows
dataActivity <- rbind(ActivityTrain, ActivityTest)
dataSubject <- rbind(SubjectTrain, SubjectTest)
dataFeatures <- rbind(FeaturesTrain, FeaturesTest)

#Naming the variables 
names(dataActivity) <- c("activity")
names(dataSubject) <- c("subject")
dataFeaturesNames <- read.table(file.path(path, "features.txt"), header = FALSE)
names(dataFeatures) <- dataFeaturesNames$V2

#Merging columns to get the data frame
dataCombine <- cbind(dataSubject, dataActivity)
data <- cbind(dataFeatures, dataCombine)

#Extracts only the measurements on the mean and standard deviation for each measurement
subdataFeaturesNames <- dataFeatures[grep("mean\\(//) | std\\(//)", dataFeatures)]
selectedNames <- c(as.character(subdataFeaturesNames), "subject", "activity")
data <- subset(data, select = selectedNames)

#Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table(file.path(path, "activity_labels.txt"), header = FALSE)
data$activity <- factor(data$activity, labels = activityLabels[,2])
head(data$activity,35)

#Appropriately labels the data set with descriptive variable names
data <- gsub("^t", "time", data)
data <- gsub("^f", "frequency", data)
data <- gsub("Acc", "Accelerometer", data)
data <- gsub("Gyro", "Gyroscope", data)
data <- gsub("Mag", "Magnitude", data)
data <- gsub("BodyBody", "Body", data)
data


#Independent tidy data
newdata <- aggregate(.~subject + activity, data, mean)
newdata <- newdata[order(newdata$subject, newdata$activity),]
write.table(newdata, file = "tidydata.txt", row.names = FALSE, quote = FALSE, sep = '\t')

