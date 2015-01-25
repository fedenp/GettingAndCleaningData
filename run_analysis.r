###TEST FILES
setwd("./UCI HAR Dataset/test")
Xtest <- read.table("X_test.txt",header=F,sep="")
Ytest <- read.table("y_test.txt",header=F,sep="")
activity <- read.table("activity_labels.txt",header=F,sep="")
act_data <- merge(Ytest,activity,by.x="V1",by.y="V1")
names(act_data) <- c("Codigo","Activity")
act_data <- data.frame(Activity=act_data[2])
features <- read.table("features.txt",header=F,sep="")
test_subs <- read.table("subject_test.txt",header=F)
names(test_subs) <- c("Subject")
a <- t(features$V2)
names(Xtest) <- a
b <- data.frame(var=grep("mean()",a,))
c <- data.frame(var=grep("std()",a,))
d <- data.frame(var=grep("Mean()",a,))
e <- rbind(b,c,d)
e <- sort(e$var)
Xtest_filt <- Xtest[,e]
Xtest_filt <- cbind(test_subs,act_data,Xtest_filt)


###TRAIN FILES
setwd("./UCI HAR Dataset/train")
Xtrain <- read.table("X_train.txt",header=F,sep="")
Ytrain <- read.table("y_train.txt",header=F,sep="")
act_data1 <- merge(Ytrain,activity,by.x="V1",by.y="V1")
names(act_data1) <- c("Codigo","Activity")
act_data1 <- data.frame(Activity=act_data1[2])
train_subs <- read.table("subject_train.txt",header=F)
names(train_subs) <- c("Subject")
trfeatures <- read.table("features.txt",header=F,sep="")
trheaders <- t(features$V2)
names(Xtrain) <- trheaders
gmean <- data.frame(var=grep("mean()",trheaders,))
gstd <- data.frame(var=grep("std()",trheaders,))
gMean <- data.frame(var=grep("Mean()",trheaders,))
cols <- rbind(b,c,d)
cols <- sort(cols$var)
Xtrain_filt <- Xtrain[,cols]
Xtrain_filt <- cbind(train_subs,act_data1,Xtrain_filt)

##Merging Both Files
final <- rbind(Xtest_filt,Xtrain_filt)

##CorrectingVariableNames
coln <- names(final)
coln1 <- gsub("()-"," ",coln,fixed=TRUE)
coln2 <- gsub("()"," ",coln1,fixed=TRUE)
coln2 <- gsub("-"," ",coln2,fixed=TRUE)
coln2 <- gsub("std","Standard_Deviation",coln2,fixed=TRUE)
coln2 <- gsub("mean","Mean",coln2,fixed=TRUE)
coln2 <- gsub("tBodyAcc","Time_Body_Accelaration",coln2,fixed=TRUE)
coln2 <- gsub("tGravityAcc","Time_Gravity_Accelaration",coln2,fixed=TRUE)
coln2 <- gsub("tBodyGyro","Time_Body_Gyrometer",coln2,fixed=TRUE)
coln2 <- gsub("Body_GyroJerk","Time_Body_Gyrometer_Jerk",coln2,fixed=TRUE)
coln2 <- gsub("fBodyAcc","Frequency_Body_Accelaration",coln2,fixed=TRUE)
coln2 <- gsub("fBodyGyro","Frequency_Body_Gyrometer",coln2,fixed=TRUE)
coln2 <- gsub("fBodyBodyAccJerkMag","Frequency_Body_Accelaration_Jerk_Magnitude",coln2,fixed=TRUE)
coln2 <- gsub("fBodyBodyGyroMag","Frequency_Body_Gyrometer_Magnitude",coln2,fixed=TRUE)
coln2 <- gsub("fBodyBodyGyroJerkMag","Frequency_Body_Gyrometer_Jerk_Magnitude",coln2,fixed=TRUE)
coln2 <- gsub("angle(Time_Body_AccelarationMean,gravity)","Time_Body_Accelaration_Gravity_Mean",coln2,fixed=TRUE)
coln2 <- gsub("angle(Time_Body_GyroMean,gravityMean)","Time_Body_Gyrometer_Gravity_Mean",coln2,fixed=TRUE)
coln2 <- gsub("angle(X,gravityMean)","X_Gravity_Mean",coln2,fixed=TRUE)
coln2 <- gsub("angle(Z,gravityMean)","Z_Gravity_Mean",coln2,fixed=TRUE)
coln2 <- gsub("angle(Time_Body_AccelarationJerkMean),gravityMean)","Time_Body_Accelaration_Jerk_Gravity_Mean",coln2,fixed=TRUE)
coln2 <- gsub("angle(Time_Time_Body_Gyro_JerkMean,gravityMean)","Time_Body_Gyrometer_Jerk_Gravity_Mean",coln2,fixed=TRUE)
coln2 <- gsub("angle(Y,gravityMean)","Y_Gravity_Mean",coln2,fixed=TRUE)
coln2 <- gsub("Time_Body_Accelaration Mag Mean ","Time_Body_Accelaration_Magnitude_Mean",coln2,fixed=TRUE)
coln2 <- gsub("Time_Gravity_Accelaration Mag Mean ","Time_Gravity_Accelaration_Magnitude_Mean",coln2,fixed=TRUE)
coln2 <- gsub("Time_Body_Accelaration JerkMag Mean ","Time_Body_Accelaration_Jerk_Magnitude_Mean",coln2,fixed=TRUE)
coln2 <- gsub("Time_Body_Gyro Mag Mean ","Time_Body_Gyrometer_Magnitude_Mean",coln2,fixed=TRUE)
coln2 <- gsub("Time_Body_Gyro JerkMag Mean ","Time_Body_Gyrometer_Magnitude_Mean",coln2,fixed=TRUE)
coln2 <- gsub("Frequency_Body_Accelaration Mag Standard_Deviation ","Frequency_Body_Accelaration_Magnitude_Standard_Deviation",coln2,fixed=TRUE)
coln2 <- gsub(" ","_",coln2,fixed=TRUE)

##ChangingNamesToFinalDataSet
names(final) <- coln2

##CreatingTidySummarizedDataSet
library(reshape2)
library(dplyr)
tidy <- final
grouped <- group_by(tidy, Subject,Activity)
tidy_print <- summarise_each(grouped,funs(mean))
names(tidy_print)[3:4] <- c("Variable","Mean")

##ExportingData
write.table(tidy_print,file="TidyDataSetSummary.txt",row.name=F	,sep=";")
