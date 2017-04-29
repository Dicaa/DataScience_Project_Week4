# README
This repo contains the R script for the week4 project of the 3rd course of the Data Science specialization.
It is intended to load the Samsung data and prepare them as a tidy data set for further analysis.
The script to run is called "run_analysis.R" and should be placed in the same folder as the the Samsung data (at the same level as the "UCI HAR Dataset" folder) to run correctly. The R script is documented with comments for each important step.
The script will end by writing out the tidy data set as a text file.
This text file can be read with the following command:
	data <- read.table("average_dataset.txt", header = TRUE)

This repo also contains a code book describing the variables of the resulting tidy data set.
