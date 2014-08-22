# download data and save each file to a data frame (takes a few minutes)

temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp, method = "curl",mode="wb")

trainSet <- read.table(unz(temp,"UCI HAR Dataset/train/X_train.txt"))
trainLabels <- read.table(unz(temp,"UCI HAR Dataset/train/y_train.txt"))
trainSub <- read.table(unz(temp,"UCI HAR Dataset/train/subject_train.txt"))
testSet <- read.table(unz(temp,"UCI HAR Dataset/test/X_test.txt"))
testLabels <- read.table(unz(temp,"UCI HAR Dataset/test/y_test.txt"))
testSub <- read.table(unz(temp,"UCI HAR Dataset/test/subject_test.txt"))
actLabels <- read.table(unz(temp,"UCI HAR Dataset/activity_labels.txt"))
featLabels <- read.table(unz(temp,"UCI HAR Dataset/features.txt"))
unlink(temp)

# kludge to read data from manually downloaded and unzipped folder

#trainSet <- read.table("./UCI HAR Dataset/train/X_train.txt")
#trainSub <- read.table("./UCI HAR Dataset/train/subject_train.txt")
#trainLabels <- read.table("./UCI HAR Dataset/train/y_train.txt")
#testSet <- read.table("./UCI HAR Dataset/test/X_test.txt")
#testSub <- read.table("./UCI HAR Dataset/test/subject_test.txt")
#testLabels <- read.table("./UCI HAR Dataset/test/y_test.txt")
#actLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
#featLabels <- read.table("./UCI HAR Dataset/features.txt")

# assign column names to data frames (question 4)

names(trainSet) <- featLabels[,2]
names(testSet) <- featLabels[,2]
names(trainSub) <- "Subject"
names(testSub) <- "Subject"
names(trainLabels) <- "Activity"
names(testLabels) <- "Activity"

# merge data (question 1)
Data <- rbind(cbind(trainSub,trainLabels,trainSet),cbind(testSub,testLabels,testSet))

# convert activity to factor variable and assign activity names to levels (question 3)
Data$Activity <- factor(Data$Activity, labels = actLabels$V2)
Data$Subject <- factor(Data$Subject)

# Take subset of data that only includes mean/std measurements (question 2)

mCols <- grep("mean()",names(Data))
sCols <- grep("std()",names(Data))
allCols <- sort(c(1,2,mCols,sCols))
Data <- Data[,allCols]

# Create new dataset with average of each measurement for each subject and each activity (question 5)
require(reshape2)
require(plyr)
mdata <- melt(Data, id.vars = c("Subject","Activity"))
newData <- ddply(mdata, .(Subject,Activity,variable), summarize, mean = mean(value))
write.table(newData,file = "TidyDataSet.txt", row.names=F)


