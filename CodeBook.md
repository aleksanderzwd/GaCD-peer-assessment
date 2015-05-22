# The Code Book

This document describes the variables, the data, and any transformations or work performed on the Human Activity Recognition Using Smartphones Data Set by the R script **run_analysis.R**.

## Input data

The input data project [UCI HAR Dataset zip file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) downloaded and unpacked into working directory consists of the following files:

- ./UCI HAR Dataset/activity_labels.txt
- ./UCI HAR Dataset/features.txt
- ./UCI HAR Dataset/train/subject_train.txt
- ./UCI HAR Dataset/test/subject_test.txt
- ./UCI HAR Dataset/train/X_train.txt
- ./UCI HAR Dataset/test/X_test.txt
- ./UCI HAR Dataset/train/y_train.txt
- ./UCI HAR Dataset/test/y_test.txt

The whole input dataset is described in details in the following files:

- ./UCI HAR Dataset/README.txt
- ./UCI HAR Dataset/features_info.txt -> input variables description

Features with a word 'Acc' in their names are in standard gravity units 'g'.

Features with a word 'Gyro' in their names are in radians/second units.

## Output data

The output data is a long form of a tidy data set. All feature names are in one column named 'variableType' and all feature values (mean) are in a second column named 'variableAverageValue'.

The list of the output data set columns:

- **subjectId** -> type: numeric, represents the subject id from 'train/subject_train.txt' and 'test/subject_test.txt' input data
- **activityType** -> type: Factor, represents the activity labels from 'activity_labels.txt' input data
- **variableType** -> type: Factor, represents the features from 'features.txt' input data
- **variableAverageValue** -> type: numeric, represents the average value of each variable (variableType column) for each activity (activityType column) and each subject (subjectId column). The column values are bounded within [-1,1] as they base on the input data feature values that are normalized and bounded within [-1,1].

variableTypes (features) with a word 'Acc' in their names are in standard gravity units 'g'.

variableTypes (eatures) with a word 'Gyro' in their names are in radians/second units.

The output data consists of 4 columns and 14220 rows.

## Data transformations: Input data >> Output data

This section describes all transformations and work performed on the data form downloading the source data to saving the tidy dataset to the 'tidyDataSet.txt' text file. Steps 1 and 2 should be made manually, steps from 3 to 11 are made by the R script 'run_analysis.R'.

**1.** Download the source data: [UCI HAR Dataset zip file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

**2.** Unzip the file to the working directory. The source data is in the 'UCI HAR Dataset' subdirectory.

**3.** Loads the following source data into R as data.table objects:

- activities: './UCI HAR Dataset/activity_labels.txt' -> size: 0 [Mb]; dim{6, 2}
- features: './UCI HAR Dataset/features.txt' -> size: 0.04 [Mb]; dim{561, 2}
- train subjects: './UCI HAR Dataset/train/subject_train.txt' -> size: 0.06 [Mb]; dim{7352, 1}
- X trains: './UCI HAR Dataset/train/X_train.txt' -> size: 31.55 [Mb]; dim{7352, 561}
- Y trains: './UCI HAR Dataset/train/y_train.txt' -> size: 0.06 [Mb]; dim{7352, 1}
- test subjects: './UCI HAR Dataset/test/subject_test.txt' -> size: 0.02 [Mb]; dim{2947, 1}
- X tests: './UCI HAR Dataset/test/X_test.txt' -> size: 12.7 [Mb]; dim{2947, 561}
- Y tests: './UCI HAR Dataset/test/y_test.txt' -> size: 0.02 [Mb]; dim{2947, 1}

**4.** Merges train subjects, X trains and Y trains by binding their columns -> data.table: dt01Train -> size: 31.67 [Mb]; dim{7352, 563}

**5.** Merges train subjects, X trains and Y trains by binding their columns -> data.table: dt01Test -> size: 12.75 [Mb]; dim{2947, 563}

**6.** Merges dt01Train and dt01Test data sets by binding their rows -> data.table: dt01 -> size: 44.32 [Mb]; dim{10299, 563}

**7.** Extracts only the measurements on the mean and standard deviation (assumed all measurements with 'mean' or 'std' in their names) -> data.table: dt02 -> size: 6.38 [Mb]; dim{10299, 81}

**8.** Uses descriptive activity names instead of the activity IDs (activity labels from 'activity_labels.txt' input data file were used as descriptive activity names) -> data.table: dt03 -> size: 6.34 [Mb]; dim{10299, 81}

**9.** Labels the data set with descriptive variable names (feature names from 'features.txt' input data file were used as variable names) -> data.table: dt04 -> size: 6.34 [Mb]; dim{10299, 81}

**10.** Creates a new tidy data set with the average of each variable for each activity and each subject (features melted from feature columns to one column with its name and second with its value, then the data set is grouped by subject, activity and feature and then the average feature value is calculated) -> data.table: dt05 -> size: 0.33 [Mb]; dim{14220, 4}

**11.** Saves the tidy data set (dt05) to the file 'tidyDataSet.txt' in the working directory

