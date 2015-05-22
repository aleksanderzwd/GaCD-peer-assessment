# Peer Assessments / Getting and Cleaning Data Course Project

This is a repository which contains an R script used to tidy [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) and to make some analysis on it.

## What is included in this repository

- **run_analysis.R** - the R script to tidy and analyze the data (requires data.table, LaF, dplyr and reshape2 packages installed)
- **README.md**  - a markdown file that includes instructions on how to use the R script
- **CodeBook.md** - a markdown file that describes the variables, the data, and any transformations or work performed on the data

## How to use the R script

To use the run_analysis.R script:

- **1.** Download the project [UCI HAR Dataset zip file](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
- **2.** Unzip it to your working directory (the content should be in a 'UCI HAR Dataset' subdirectory)
- **3.** Execute the script 'run_analysis.R' from your working directory

The script can be run either from command line or from the R Console.
An example of running it from the R Console:

`> source("run_analysis.R")`

The effect of running the script should be a tidy dataset file named 'tidyDataSet.txt'.

## How to load the tidy dataset into R

To load the tidy dataset from the file 'tidyDataSet.txt' into R for further analysis use the following instruction:

`tidyDataSet <- read.table("tidyDataSet.txt", header = TRUE, sep = " ")`

