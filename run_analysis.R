## 1. Merges the training and the test sets to create one data set

# Load the two measurement datasets (training and test) as well as their associated activites
test_data_x <- read.csv("UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
test_data_y <- read.csv("UCI HAR Dataset/test/y_test.txt", sep = "", header = FALSE)
test_subject <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE)
test_features <- cbind(test_data_x, test_data_y, test_subject)

train_data_x <- read.csv("UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
train_data_y <- read.csv("UCI HAR Dataset/train/y_train.txt", sep = "", header = FALSE)
train_subject <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE)
train_features <- cbind(train_data_x, train_data_y, train_subject)

# Merge the 2 datasets
all_features <- rbind(test_features, train_features)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

# Load the feature names
feature_names <- read.csv("UCI HAR Dataset/features.txt", sep = "", header = FALSE, as.is = TRUE)
feature_names <- feature_names[,2]

# Add the names for "activity" and "subject"
feature_names <- c(feature_names,"activityid", "subjectid")

# Associate the names in the dataframe
names(all_features) <- feature_names

# Define a mask to select only the measurements on mean and standard deviation, and also the associated activity and subject
name_mask <- grepl(pattern = "mean\\(\\)|std\\(\\)|activityid|subjectid", x = names(all_features))

# Apply the mask to keep only the features of interest
selected_features <- all_features[name_mask]

## 3. Uses descriptive activity names to name the activities in the data set

# Load the activity labels
activity_labels <- read.csv("UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE, as.is = TRUE)
names(activity_labels) <- c("id", "activitylabel")

# Merge the feature dataset with the activity label
features_activity_labeled <- merge(selected_features, activity_labels, by.x = "activityid", by.y = "id")

# Remove the activity_id column
features_activity_labeled <- features_activity_labeled[,names(features_activity_labeled) != "activityid"]

## 4. Appropriately labels the data set with descriptive variable names.

# Transform all the column names to lower case
names_clean <- sapply(X = names(features_activity_labeled), FUN = tolower)

# Remove "-" and "()" from the column names
names_clean1 <- sapply(X = names_clean, FUN = gsub, pattern="-|\\(\\)", replacement="")

# Set the new column names on the dataframe
names(features_activity_labeled) <- names_clean1


## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Group by (subjectid, activitylabel) pairs, averaging all the values by group
average_dataset <- aggregate(x = features_activity_labeled[,!(names(features_activity_labeled) %in% c("subjectid", "activitylabel"))],
                             by = list(subjectid = features_activity_labeled$subjectid, activitylabel = features_activity_labeled$activitylabel),
                             FUN = mean)

# Order by subjectid, activitylabel
average_dataset <- average_dataset[with(average_dataset, order(subjectid, activitylabel)),]

# Export the final dataset
write.table(average_dataset, file = "average_dataset.txt", row.name=FALSE)

