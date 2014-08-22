---
title: "README"
author: "DAC"
date: "August 21, 2014"
output: html_document
---

This readme file describes how the run_analysis.R script works to take data from Samsung and create a clean and tidy data set for future analysis.

The analysis script downloads the zip file from a url and reads in all the relevant text files into data frames in R. Then variable names are assigned using the features.txt file for the actual data set. Variable names are used as originally provided and explained further in the codebook. The test and training set are merged, adding in the subjects and type of activity for each record. Activity and Subject variables were transformed to factor variables and activity levels were labelled appropriately. 

Next, the data was subsetted to keep only the variables that were the mean or standard deviation of a measurement. This includes any variable name with mean() or std(), but not meanFreq() as that is a weighted mean (see codebook). The new data set was condensed with the melt function to have only 4 columns, the subject, the activity, the variable, and the value. ddply was used to loop over the dataset and calculate means, subsetting by subject and activity, storing the result in the newData data frame. Finally, this data frame was written to a text file using write.table() with row names  = False and all other variables keeping default values.

