# Peer Assessments / Getting and Cleaning Data Course Project
#
# This is a repository which contains an R script used to tidy Human Activity
# Recognition Using Smartphones Data Set and to make some analysis on it.

library(data.table)

# -- UTILs --------------------------------------------------------------------

dataTableInfo <- function(dt) {
        paste0(deparse(substitute(dt)),
               "; size: ", round(object.size(dt)/(2^20), 2),
               " [Mb]; dim{", nrow(dt), ", ",
                ncol(dt), "}")
}

# -- Load Data ----------------------------------------------------------------

# -- load activities ------

activityFilePath <- "./UCI HAR Dataset/activity_labels.txt"

activityDT <- fread(activityFilePath, sep = " ",
      header = FALSE,
      data.table = TRUE,
      na.strings = c(),
      nrows = -1,
      colClasses = c("numeric", "character"))

setnames(activityDT, c("activityId", "activityLabel"))

print(dataTableInfo(activityDT))


# -- load features ------

featureFilePath <- "./UCI HAR Dataset/features.txt"

featureDT <- fread(featureFilePath, sep = " ",
                         header = FALSE,
                         data.table = TRUE,
                         na.strings = c(),
                         nrows = -1,
                         colClasses = c("numeric", "character"))

setnames(featureDT, c("featureId", "featureLabel"))

print(dataTableInfo(featureDT))


# -- Load Data: TRAIN ---------------------------------------------------------

# -- load train subjects ------

subjectTrainFilePath <- "./UCI HAR Dataset/train/subject_train.txt"

subjectTrainDT <- fread(subjectTrainFilePath,
                   header = FALSE,
                   data.table = TRUE,
                   na.strings = c(),
                   nrows = -1,
                   colClasses = c("numeric"))

setnames(subjectTrainDT, c("subjectId"))

print(dataTableInfo(subjectTrainDT))


# -- load X trains ------

xTrainFilePath <- "./UCI HAR Dataset/train/X_train.txt"

# Because read.fwf seems to be too slow to load train files I decided
# to use LaF library to load the fised width files.
# It is required to install 'LaF' package -> install.packages("LaF")

library(LaF)

xTrainPointer <-
        laf_open_fwf(filename = xTrainFilePath,
                     column_types = c(rep("numeric", dim(featureDT)[1])),
                     column_names = paste0("FT.", 
                             sprintf("%03d", featureDT$featureId)),
                     column_widths = c(rep(16, dim(featureDT)[1]))
                     )

xTrainDT <- data.table(xTrainPointer[,])

print(dataTableInfo(xTrainDT))


# -- load Y trains ------

yTrainFilePath <- "./UCI HAR Dataset/train/y_train.txt"

yTrainDT <- fread(yTrainFilePath,
                        header = FALSE,
                        data.table = TRUE,
                        na.strings = c(),
                        nrows = -1,
                        colClasses = c("numeric"))

setnames(yTrainDT, c("activityId"))

print(dataTableInfo(yTrainDT))


# -- Load Data: TEST ----------------------------------------------------------

# -- load test subjects ------

subjectTestFilePath <- "./UCI HAR Dataset/test/subject_test.txt"

subjectTestDT <- fread(subjectTestFilePath,
                        header = FALSE,
                        data.table = TRUE,
                        na.strings = c(),
                        nrows = -1,
                        colClasses = c("numeric"))

setnames(subjectTestDT, c("subjectId"))

print(dataTableInfo(subjectTestDT))


# -- load X tests ------

xTestFilePath <- "./UCI HAR Dataset/test/X_test.txt"

# Because read.fwf seems to be too slow to load test files I decided
# to use LaF library to load the fised width files.
# It is required to install 'LaF' package -> install.packages("LaF")

library(LaF)

xTestPointer <-
        laf_open_fwf(filename = xTestFilePath,
                     column_types = c(rep("numeric", dim(featureDT)[1])),
                     column_names = paste0("FT.", 
                             sprintf("%03d", featureDT$featureId)),
                     column_widths = c(rep(16, dim(featureDT)[1]))
        )

xTestDT <- data.table(xTestPointer[,])

print(dataTableInfo(xTestDT))


# -- load Y tests ------

yTestFilePath <- "./UCI HAR Dataset/test/y_test.txt"

yTestDT <- fread(yTestFilePath,
                  header = FALSE,
                  data.table = TRUE,
                  na.strings = c(),
                  nrows = -1,
                  colClasses = c("numeric"))

setnames(yTestDT, c("activityId"))

print(dataTableInfo(yTestDT))


# -- tidying data -------------------------------------------------------------

# 1. Merges the training and the test sets to create one data set.

dt01Train <- cbind(subjectTrainDT, yTrainDT, xTrainDT)
rm(subjectTrainDT); rm(yTrainDT); rm(xTrainDT);
print(dataTableInfo(dt01Train))

dt01Test <- cbind(subjectTestDT, yTestDT, xTestDT)
rm(subjectTestDT); rm(yTestDT); rm(xTestDT);
print(dataTableInfo(dt01Test))

dt01 <- rbind(dt01Train, dt01Test, make.row.names = FALSE)
rm(dt01Train); rm(dt01Test);
print(dataTableInfo(dt01))


# 2. Extracts only the measurements on the mean and standard deviation for each
#    measurement. 

library(dplyr)

featureMeanAndStdVariableIndexes <- grep("mean+|std+", featureDT$featureLabel, 
                                         perl=TRUE, value=FALSE)

dt02 <- dt01 %>% select(c(1, 2, featureMeanAndStdVariableIndexes + 2))
rm(dt01)
print(dataTableInfo(dt02))


# 3. Uses descriptive activity names to name the activities in the data set

dt03 <- dt02 %>%
        mutate(activityType = factor(activityId,
                                     levels = activityDT$activityId,
                                     labels = activityDT$activityLabel)) %>%
        select(subjectId, activityType, FT.001:FT.552)
rm(dt02); rm(activityDT)
print(dataTableInfo(dt03))


# 4. Appropriately labels the data set with descriptive variable names.

dt04 <- dt03
setnames(dt04, c(names(dt03)[1:2],
                 featureDT$featureLabel[featureMeanAndStdVariableIndexes]))
rm(dt03); rm(featureDT)
print(dataTableInfo(dt04))

# 5. From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject.

library(reshape2)

dt05 <- melt(dt04, id = c(names(dt04)[1:2]),
             measure.vars = c(names(dt04)[3:ncol(dt04)]),
             variable.name = "variableType",
             value.name = "variableValue") %>%
        group_by(subjectId, activityType, variableType) %>%
        summarize(variableAverageValue = mean(variableValue, na.rm = TRUE)) %>%
        arrange(subjectId, activityType, variableType)
rm(dt04)
print(dataTableInfo(dt05))


# -- persist the tidy data set to a file --------------------------------------

tidyDataSetFilePath <- "./tidyDataSet.txt"

write.table(dt05, file = tidyDataSetFilePath, row.names = FALSE)
