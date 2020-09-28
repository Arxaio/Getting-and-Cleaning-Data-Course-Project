### Run Analysis 
# Loading dplyr package
library(dplyr)

# Reading train data
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# Reading test data
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Reading feature names
features <- read.table("./UCI HAR Dataset/features.txt")

# Merging data
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# Naming data
names(subject_data) <- c("subject")
names(x_data) <- features$V2
names(y_data) <- c("activities")

# Step 1: Combining data
data <- cbind(subject_data, y_data, x_data)

# Step 2: Extracting data with only mean and standard deviation of each measurement
data_names <- names(data)
data_names_filtered <- grep("std|mean|activities|subject", data_names, value=TRUE)
filtered_data <- data[ , data_names_filtered]

# Step 3: Label activities
filtered_data$activities <- gsub("1", "Walking", filtered_data$activities)
filtered_data$activities <- gsub("2", "Walking Upstaires", filtered_data$activities)
filtered_data$activities <- gsub("3", "Walking Downstaires", filtered_data$activities)
filtered_data$activities <- gsub("4", "Sitting", filtered_data$activities)
filtered_data$activities <- gsub("5", "Standing", filtered_data$activities)
filtered_data$activities <- gsub("6", "Laying", filtered_data$activities)

# Step 4: Label data set with descriptive variable names
names(filtered_data) <- gsub("^t", "Time", names(filtered_data))
names(filtered_data) <- gsub("Acc", "Acceleration", names(filtered_data))
names(filtered_data) <- gsub("Gyro", "Gyroscope", names(filtered_data))
names(filtered_data) <- gsub("Mag", "Magnitude", names(filtered_data))
names(filtered_data) <- gsub("Freq", "Frequency", names(filtered_data))
names(filtered_data) <- gsub("^f", "Frequency", names(filtered_data))

# Step 5: tidy data set with the average of each variable for each activity and each subject
Tidydata <- filtered_data %>% group_by(subject, activities) %>% summarise_all(mean)
write.table(Tidydata, "Tidydata.txt")