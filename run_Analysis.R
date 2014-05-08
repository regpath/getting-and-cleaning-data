# Setting working directory
setwd("C:\\Users\\Jeongyong Kim\\Dropbox\\1_Coursera\\UCI HAR Dataset")

# Reading the data sets
Xtrain = read.table("./train/X_train.txt")
ytrain = read.table("./train/y_train.txt")
subtrain = read.table("./train/subject_train.txt") 
Xtest = read.table("./test/X_test.txt")
ytest = read.table("./test/y_test.txt")
subtest = read.table("./test/subject_test.txt")

activity = read.table("./activity_labels.txt")
activity = activity[,2]

features = read.table("./features.txt")
features = features[,2]


# Replace activity numbers by labels
ytrain = unlist(ytrain)
ytest = unlist(ytest)
ymerged = c(ytrain,ytest)
ymerged = activity[ymerged]

# Merge the data sets (Xtrain,Xtest,Ytrain,Ytest)
Xmerged = rbind(Xtrain,Xtest)
submerged = rbind(subtrain,subtest)
merged = cbind(submerged,ymerged,Xmerged)
colnames(merged) = c("Subject","Activity",as.character(features))

# Select features that are 'mean' or 'standard deviation'
library(stringr)
ifmean = mapply(str_sub,features,-8,-5) == "mean"
ifstd = mapply(str_sub,features,-7,-5) == "std"
ifmeanorstd = ifmean | ifstd
ifmeanorstd = c(TRUE,TRUE,ifmeanorstd)

selected = merged[,ifmeanorstd]
write.table(selected,"first_tidy_data.txt")

library(data.table)
dat = data.table(selected)
summ = dat[,lapply(.SD,mean),by=c("Subject","Activity")]
write.table(summ,"second_tidy_data.txt")

