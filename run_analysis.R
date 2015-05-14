setwd("~/Desktop/Cousera/Getting and Cleaning Data/UCI HAR Dataset");

activity_labels <- read.table('activity_labels.txt');
features <- read.table('features.txt');

#read data and assign each column with the appropriate name
subject_test <- read.table('./test/subject_test.txt');
colnames(subject_test) <- c("subject_id");
x_test <- read.table('./test/X_test.txt');
colnames(x_test) <- features[,2];
y_test <- read.table('./test/y_test.txt');
colnames(y_test) <- c("activity_name");

subject_train <- read.table('./train/subject_train.txt');
colnames(subject_train) <- c("subject_id");
x_train <- read.table('./train/X_train.txt');
colnames(x_train) <- features[,2];
y_train <- read.table('./train/y_train.txt');
colnames(y_train) <- c("activity_name");

test <- cbind(subject_test, y_test, x_test);
train <- cbind(subject_train, y_train, x_train);

#Merge the test abd training data set
merge_data <- rbind(test, train);

#Extract only the means and std deviation for each measurements together with subject and activity ID
extracted_data <- merge_data[, c(1, 2, 2+grep("-(mean|std)\\(\\)", features[, 2]))];

#Use descriptive activity names to name the activities in the data set
for (i in 1:6) {
  extracted_data$activity_name <- gsub(i, activity_labels[i, 2], extracted_data$activity_name);
}

#Appropriately labels the data set with descriptive variable names.

names(extracted_data)<-gsub("^t", "time", names(extracted_data));
names(extracted_data)<-gsub("^f", "frequency", names(extracted_data));
names(extracted_data)<-gsub("Acc", "Accelerometre", names(extracted_data));
names(extracted_data)<-gsub("Gyro", "Gyroscope", names(extracted_data));
names(extracted_data)<-gsub("Mag", "Magnitude", names(extracted_data));
names(extracted_data)<-gsub("BodyBody", "Body", names(extracted_data));


#creates an independent tidy data set with the average of each variable for each activity and each subject.
tidy_data <- aggregate(extracted_data[, 3:ncol(extracted_data)], list(subject = extracted_data$subject_id, activity = extracted_data$activity_name), mean);

write.table(tidy_data, "tidy_data.txt", row.name=FALSE);
  



