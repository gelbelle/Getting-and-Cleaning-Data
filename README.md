All the analysis of this dataset was performed in the run_analysis.R script file. Any transformations performed are documented throughout the code.

First the data was imported into R and examined using str(). After this time the training and test data were combined into one dataframe.

The resulting dataframe had the subjects and the activities added to it.

A summary dataframe was subset from that dataframe. The new, smaller dataframe kept the subject and activity identifiers, but only kept the variables pertaining to the mean and standard deviation of the original test.

Finally this dataframe was summarized in a tidy dataframe that contains one entry for each subject for each activity. These data a the average result of all the measurements on all subjects for each activity.