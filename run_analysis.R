## This R script is written to create a tidy data set from a given dataset(the Samsung dataset)

## read in all the required data
train = read.table("X_train.txt")
test = read.table("X_test.txt")
actrain = read.table("y_train.txt")
actest = read.table("y_test.txt")
subtrain = read.table("subject_train.txt")
subtest = read.table("subject_test.txt")
features = read.table("features.txt", stringsAsFactors = FALSE)

## Merging the train and test data and naming the columns 
var_names = features[,2]                        #the variable names subsetted from "features"
colnames(train) = var_names                     #naming the columns with the variable names from "var_names"
colnames(test) = var_names
train2 = cbind(actrain, subtrain, train)        #cbinding the activity and subject for train
test2 = cbind(actest, subtest, test)            #cbinding the activity and subject for test
merged = rbind(train2, test2)                   #merging the train and test data
colnames(merged)[1] = "activity"                #naming the activity column descriptively
colnames(merged)[2] = "subject"                 #naming the subject column descriptively

## Extracting mean and standard deviation measurements
meanCols = merged[, grep("mean", names(merged))] #using grepl to attract columns with the word "mean" in it
stdCols = merged[, grep("std", names(merged))]   #using grepl to attract columns with the word "std" in it
activity = merged$activity
subject = merged$subject

## Merging the mean and standard deviation measurements data
meanStd = cbind(activity, subject, meanCols, stdCols)

## Naming the "activity" column by its descriptive labels i.e. walking, sitting etc.
meanStd[meanStd$activity==1, 1] = "WALKING"
meanStd[meanStd$activity==2, 1] = "WALKING_UPSTAIRS"
meanStd[meanStd$activity==3, 1] = "WALKING_DOWNSTAIRS"
meanStd[meanStd$activity==4, 1] = "SITTING"
meanStd[meanStd$activity==5, 1] = "STANDING"
meanStd[meanStd$activity==6, 1] = "LAYING"

## The final step to create a 2nd, independent tidy data set with the average of each variable
## for each "activity" and "subject"
library(reshape2)
msMelt = melt(meanStd, id=c("activity", "subject"))             #use melt to create a 'skinny' dataframe
tidyData = dcast(msMelt, activity + subject ~ variable, mean)   #use dcast to create the final, tidy, data set.







