#Select appropriate libraries
library(plyr)
library(dplyr)
#Read in appripriate data
features <- read.table("./Dataset/features.txt", header = FALSE)
activitylabels <- read.table("./Dataset/activity_labels.txt", header = FALSE)
Xtest <- read.table("./Dataset/test/X_test.txt", header = FALSE)
subjecttest <- read.table("./Dataset/test/subject_test.txt", header = FALSE)
Ytest <- read.table("./Dataset/test/Y_test.txt", header = FALSE)
Xtrain <- read.table("./Dataset/train/X_train.txt", header = FALSE)
subjecttrain <- read.table("./Dataset/train/subject_train.txt", header = FALSE)
Ytrain <- read.table("./Dataset/train/Y_train.txt", header = FALSE)
#Add headers to all the tables
names(Xtrain) <- features[,2]
names(Ytrain) <- "Activity"
names(subjecttrain) <- "Subject"
names(Xtest) <- features[,2]
names(Ytest) <- "Activity"
names(subjecttest) <- "Subject"
#Combine tables
traintable <- cbind(Ytrain,subjecttrain,Xtrain)
testtable <- cbind(Ytest,subjecttest,Xtest)
combtable <- rbind(traintable,testtable)
#Remove duplicates
temptable <- combtable[!duplicated(names(combtable))]
#Filters out the Activity, Subject, Group, and Mean/Std headers
filteredtable <- select(temptable, matches("Activity"),matches("Subject"),matches("Group"),contains("mean()"), contains("std()"))
#Merges the descriptive activity names based on activity #
penulttable <- merge(activitylabels,filteredtable,by.x = "V1",by.y = "Activity")
#Rename activity columns
colnames(penulttable)[1] <- "ActivityNum"
colnames(penulttable)[2] <- "Activity"
#Averages across all the readings for both mean and std dev
finaltable <- ddply(penulttable, .(Subject, Activity), numcolwise(mean))
#Puts out final table
write.table(finaltable,"./Finaltable.txt", row.names = FALSE)