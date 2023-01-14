
## Remove all variables from the environment.
rm(list = ls())

#clean Console  as command (CTRL + L)
cat("\014") 

## Get the path of the script from where it is being executed.
Working_dir_path <- getwd()

## Set Working Directory
setwd(Working_dir_path)


#************************ Question 1 ***************************
#* Load the dataset

# The data captured has been placed in the folder called "Data"
# We will load the data files present in this folder to a separate data frame.
# For this we will use a for loop to loop through the files.


#getting the file names under "Data" folder of captured data
filenames <- list.files(path = "Data", pattern = ".csv", full.names = TRUE)
filenames


# For loop to read through all the csv files present in the data folder
# and store them in a separate data frames
for(file_index in 1:length(filenames)){
  file_name <- filenames[file_index]
  assign(sub(".csv","",sub("Data/","",filenames[file_index])), 
         read.csv(file_name, header = FALSE, blank.lines.skip = TRUE))
}

# Store all the data frames in the list so it is easily accessible.
df_in_list <- list(subj1_act1, subj1_act2, subj1_act3,
                   subj1_act4, subj2_act1, subj2_act2,
                   subj2_act3, subj2_act4, subj3_act1,
                   subj3_act2, subj3_act3, subj3_act4)

#************************ Question 2 ***************************
#* Using computational methods, find the data markers which determine the actual data (human activity)
#* Obtain the indexes for the start and end markers.

# vector for row names in a matrix
r_names <- c("df1","df2","df3","df4","df5","df6","df7","df8","df9","df10",
             "df11","df12")

# vector for column names in a matrix
c_names <- c("starting_index","ending_index")

# create an empty matrix of 12 rows and 2 columns
# since we have 12 data frames and we only require the starting index and
# ending index
marker_mtrx <- matrix(data = NA, nrow = 12, ncol = 2,
                      dimnames = list(r_names,c_names))

# We will use the for loop to loop through the data frames in the list
for(indx in 1:length(df_in_list)){
  # get the marker indexes of all the lines present in the data frames
  # that matches with the keyword "Sample" in column V1
  get_marker_indexes <- which(df_in_list[[indx]]$V1=="Sample")
  
  # To get the starting marker index 
  marker_starting_index <- as.numeric(get_marker_indexes[2])
  
  # To get the ending marker index
  marker_ending_index <- as.numeric(get_marker_indexes[3]) - 1
  
  # Add the starting marker and the ending marker in the matrix
  # that we have created above
  marker_mtrx[indx,1] <- marker_starting_index
  marker_mtrx[indx,2] <- marker_ending_index
}

# Call the matrix to view the inserted data
marker_mtrx


#************************ Question 3 ***************************
#* Obtain the desire data. Using computational methods, use the markers obtained in point 2, 
#* get the data between these markers only. Save the new data in separate data frames.

# For loop to obtain the desired data
for(indx in 1:length(df_in_list)){
  # Subset the data frames in the list based on the markers that we obtained
  # from question 2 above.
  df_in_list[[indx]] = df_in_list[[indx]][marker_mtrx[indx,"starting_index"]:marker_mtrx[indx,"ending_index"],]
}

# for loop to write the new data from the list of data frames into separate 
# data frames
for(file_index in 1:length(filenames)){
  # get the file name
  file_name <- filenames[file_index]
  
  # create a data frame and assign the value
  assign(paste0("df_",file_index,
                sub(".csv","",sub("Data/","_",filenames[file_index]))),
         as.data.frame(df_in_list[[file_index]]))
}

#######
# We will create a new list and add all the newly created data frames
# in it so that it easier to perform the various operations and we will be
# using this list for the questions below.
df_list = list(df_1_subj1_act1, df_2_subj1_act2, df_3_subj1_act3,
               df_4_subj1_act4, df_5_subj2_act1, df_6_subj2_act2,
               df_7_subj2_act3, df_8_subj2_act4, df_9_subj3_act1,
               df_10_subj3_act2, df_11_subj3_act3, df_12_subj3_act4)
######


#************************ Question 4 ***************************
#* Name each variable in the data frames using the data marker

# for loop to loop through the data frames in the list.
for(list_indx in 1:length(df_list)){
  
  # To rename the columns names in the data frames.
  names(df_list[[list_indx]]) <- df_list[[list_indx]][1,]
  
  # remove the first row of data from the data frames, 
  # since our first row of data is the same as the column headers
  df_list[[list_indx]] = df_list[[list_indx]][-1,]
}


#************************ Question 5 ***************************
#* To get the columns containing the number of samples and the gyroscope data

# for loop to loop through the data frames in the list.
for(lstindx in 1:length(df_list)){
  
  # Subset to remove unwanted columns aX, aY, az and Temp
  df_list[[lstindx]] <- subset(df_list[[lstindx]], select = c(Sample,gX,gY,gz))
}


#************************ Question 6 ***************************
# Removing the variables that we now don't need.

# We will only remove the data frames whose names contains the string "subj".
rm(list = ls(pattern = "subj"))

# Removing only the variables that we do not require
rm(list = c("df_in_list","marker_mtrx","c_names","r_names","get_marker_indexes",
            "indx","marker_starting_index","marker_ending_index","file_name",
            "list_indx","lstindx", "Working_dir_path","file_index"))


#************************ Question 7 ***************************
#* Remove empty cells or NAs. Make sure that there are not empty cells or NAs in your variables. 
#* If so, remove the whole row that contains an empty cell or a NA;

# for loop to loop through the data frames in the list.
for(list_index in 1:length(df_list)){
  
  # Select only the rows that does not have a blank column in gX, gY and gz
  df_list[[list_index]] = subset(df_list[[list_index]], gX != "" & gY != "" & gz != "")
  
  # omit all the rows that have NAs
  df_list[[list_index]] = na.omit(df_list[[list_index]])
}

#************************ Question 8 ***************************
#* Check data Structure. Make sure that the variables in the data frame are numeric, 
#* if not, convert the variables into a numeric data type;

# for loop to loop through list of data frames.
for(index in 1:length(df_list)){
  
  df_list[[index]]$Sample <- as.numeric(df_list[[index]]$Sample)
  
  df_list[[index]]$gX <- as.numeric(df_list[[index]]$gX)
  
  df_list[[index]]$gY <- as.numeric(df_list[[index]]$gY)
  
  df_list[[index]]$gz <- as.numeric(df_list[[index]]$gz)
}

#************************ Question 9 ***************************
#* Signal Calibration.

activity_time <- 50

# for loop to loop through list of data frames.
for(indx in 1:length(df_list)){
  
  # get the sample rate
  sample_rate <- nrow(df_list[[indx]]) %/% activity_time
  
  # for first 10 seconds data
  first_ten_seconds_data <- df_list[[indx]][1:(sample_rate*10),]
  
  df_list[[indx]]$gX <- df_list[[indx]]$gX - mean(first_ten_seconds_data$gX)
  
  df_list[[indx]]$gY <- df_list[[indx]]$gY - mean(first_ten_seconds_data$gY)
  
  df_list[[indx]]$gz <- df_list[[indx]]$gX - mean(first_ten_seconds_data$gz)
}

####
# for loop to convert the data frames in the list to individual data frames
for(fileindex in 1:length(filenames)){
  # get the file name
  file_name <- filenames[fileindex]

  # create a data frame and assign the value
  assign(paste0("df_",fileindex,
                sub(".csv","",sub("Data/","_",filenames[fileindex]))),
         as.data.frame(df_list[[fileindex]]))
}
####

####
# we will remove the variables to free up the memory
rm(list = c("first_ten_seconds_data", "file_name", 
            "fileindex","index","indx","list_index"))
####

#************************ Question 10 ***************************

# function to plot the line graph
# Parameters:
#     df_act1 - data frame
#     df_act2 - data frame
#     df_act3 - data frame
#     df_act4 - data frame
#     graph_title - string
#
# Description:
#     This function will take the four data frames and the graph title as input
#     1. It will calculate the lines that are to be added in the graph to separate
#        the four activities.
#     2. Then it will combine all the four data frames into a single data frame 
#        using "rbind".
#     3. Then it will calculate the the mean_value for placing the label for
#        each activity in the plot.
#     4. Then plot the graph.
plot_data <- function(df_act1, df_act2, df_act3, df_act4, graph_title){
  # Calculate the lines to be added to the plot
  first_line <- nrow(df_act1)
  second_line <- first_line + nrow(df_act2)
  third_line <- second_line + nrow(df_act3)
  
  # Combining all the data frames into a single data frame using rbind
  combined_activity_data <- rbind(df_act1, df_act2, df_act3, df_act4)
  
  # Calculate the mean value for placing the label
  mean_value <- mean(c(min(combined_activity_data$gX, combined_activity_data$gY, 
                           combined_activity_data$gz)))
  
  # To plot the data
  plot(combined_activity_data$gX, 
       col = "red", 
       type = "l", 
       xlab = "Sample",
       ylab = "Rotational velocity (degree/sec)",
       main = graph_title)
  lines(combined_activity_data$gY, col = "green")
  lines(combined_activity_data$gz, col = "blue")
  abline(v=c(first_line,second_line,third_line), lwd = 2, col="grey", lty = 3)  # for placing the vertical line
  text(first_line/2, mean_value, "Activity 1", cex = .8)
  text(first_line + nrow(df_act2)/2, mean_value, "Activity 2", cex = .8)
  text(second_line + nrow(df_act3)/2, mean_value, "Activity 3", cex = .8)
  text(third_line + nrow(df_act4)/2, mean_value, "Activity 4", cex = .8)
  legend("topleft", c("gX", "gY", "gz"), col = c("red", "green", "blue"),
         text.col = c("red", "green", "blue"), lty = 1,
         bg = "white")
}

# Pass the four activities data (i.e. data frames) of the first subject (i.e. Subject 1) to the
# plot_data function to plot the graph.
plot_data(df_1_subj1_act1, df_2_subj1_act2, df_3_subj1_act3, df_4_subj1_act4, 
          "Subject 1 - All activities")

# Pass the four activities data (i.e. data frames) of the first subject (i.e. Subject 2) to the
# plot_data function to plot the graph.
plot_data(df_5_subj2_act1, df_6_subj2_act2, df_7_subj2_act3, df_8_subj2_act4, 
          "Subject 2 - All activities")

# Pass the four activities data (i.e. data frames) of the first subject (i.e. Subject 3) to the
# plot_data function to plot the graph.
plot_data(df_9_subj3_act1, df_10_subj3_act2, df_11_subj3_act3, df_12_subj3_act4, 
          "Subject 3 - All activities")


#************************ Question 11 ***************************
#* To get the 30 seconds of activity we use the data frames in the list 
#* (i.e. df_list) and store them as a separate data frames.

for(list_index in 1:length(df_list)){
  
  # get the sample rate
  sampl_rate <- nrow(df_list[[list_index]]) %/% activity_time
  
  first_resting_period_time <- 10 * sampl_rate

  final_resting_period_time <- 40 * sampl_rate
  
  final_resting_period_end_time <- 50 * sampl_rate

  # Get the 30 seconds experiment data
  experiment_period <- df_list[[list_index]][(first_resting_period_time+1): final_resting_period_time,]
  
  # create a data frame and assign the value
  assign(paste0("df_30sec_",list_index,
                sub(".csv","",sub("Data/","_",filenames[list_index]))),
         as.data.frame(experiment_period))
}


#************************ Question 12 ***************************
#* Compute the mean and standard deviation for each activity and 
#* for each participant.

# Add the 30 sec data frames in the list
df_30sec_data_in_list <- list(df_30sec_1_subj1_act1, df_30sec_2_subj1_act2,
                              df_30sec_3_subj1_act3, df_30sec_4_subj1_act4,
                              df_30sec_5_subj2_act1, df_30sec_6_subj2_act2,
                              df_30sec_7_subj2_act3, df_30sec_8_subj2_act4,
                              df_30sec_9_subj3_act1, df_30sec_10_subj3_act2,
                              df_30sec_11_subj3_act3, df_30sec_12_subj3_act4)

# create an empty data frame for storing the mean and standard deviation for
# each activity and each participant
df_stat_metrics <- data.frame()

# for loop to loop through the data frames present in the list (df_30sec_data_in_list)
# that we created above.
for(indx_list in 1:length(df_30sec_data_in_list)){
  
  # Calculate mean of gX, gY and gz
  mean_gX <- mean(df_30sec_data_in_list[[indx_list]]$gX)
  mean_gY <- mean(df_30sec_data_in_list[[indx_list]]$gY)
  mean_gz <- mean(df_30sec_data_in_list[[indx_list]]$gz)
  
  # Calculate standard deviation of gX, gY and gz
  sd_gX <- sd(df_30sec_data_in_list[[indx_list]]$gX)
  sd_gY <- sd(df_30sec_data_in_list[[indx_list]]$gY)
  sd_gz <- sd(df_30sec_data_in_list[[indx_list]]$gz)
  
  # create a vector for Gyroscope
  gyro <- c("gX","gY","gz")
  
  # create a vector for storing mean gyroscope data of gX, gY and gz
  mean_gyro <- c(mean_gX, mean_gY, mean_gz)
  
  # create a vector for storing standard deviation gyroscope data of gX, gY and gz
  sd_gyro <- c(sd_gX, sd_gY, sd_gz)
  
  # for loop loop through the 
  for(index in 1:3){
    
    temp <- c(substr(filenames[indx_list], 10, 10), # get the subject number from the "filenames" variable
              substr(filenames[indx_list], 15, 15), # get the activity number from the "filenames" variable
              gyro[index],        # get the gyroscope data from the gyro vector
              mean_gyro[index],   # get the mean gyro data from the mean_gyro vector
              sd_gyro[index]      # get the standard deviation data from the sd_gyro vector
              )
    
    # add the data to data frame
    df_stat_metrics <- rbind(df_stat_metrics, temp)
  }
  
}

# Change column names of the data frame (df_stat_metrics)
colnames(df_stat_metrics) <- c("Subject","Activity","Gyroscope","Mean","Standard_Deviation")

# to view the data that has been inserted in the data frame
df_stat_metrics

# view the structure of the data frame
str(df_stat_metrics)

# convert the columns "Mean" and "Standard Deviation" to numeric so that
# it becomes easier for us to plot the box plots in the next question.
df_stat_metrics$Mean = as.numeric(df_stat_metrics$Mean)
df_stat_metrics$Standard_Deviation = as.numeric(df_stat_metrics$Standard_Deviation)

#************************ Question 13 ***************************
#* Plotting box plot

# function to plot the box plot
# Parameters:
#     Y_var - column to be used as Y axis (i.e. data frame column)
#     X_lab - (string) label to be displayed on X axis
#     title - (string) title for the graph
#     data_frame - (data frame) data to be used for plotting
#
# Description:
#     This function will take the four parameters as input and will plot the 
#     box plot.
plot_boxplot <- function(Y_var, X_lab, title, data_frame){
  # box plot
  boxplot(Y_var ~ Gyroscope : Activity,
          data = data_frame,
          main = title,
          ylab = "Rotational velocity",
          xlab = X_lab,
          col = c("pink","lightgreen","lightblue"),
          at = c(1:12),
          names = c("","Activity 1-Sitting","",
                    "","Activity 2-Typing","",
                    "","Activity 3-Stand & Look","",
                    "","Activity 4-Stand & Walk",""))
  # Add a legend
  legend("topleft", legend = c("x","y","z"), # Position and title
         fill = c("pink","lightgreen","lightblue"),  # Color
         horiz = 1, # set it to 1 to display the legend in horizontal position
         bg = "white") # Legend background color
}

# plotting box plot for mean values
plot_boxplot(df_stat_metrics$Mean, "Mean values", "Boxplot of mean values of all activities of each subject",
             df_stat_metrics)

# plotting box plot for standard deviation values
plot_boxplot(df_stat_metrics$Standard_Deviation, "Standard deviation values", 
             "Boxplot of standard deviation values of all activities of each subject",
             df_stat_metrics)

#####
# Remove the variables that we do not need.
rm(list = c("temp","sd_gz","sd_gyro","sd_gY","sd_gX","sample_rate","sampl_rate",
            "mean_gyro","mean_gz","mean_gY","mean_gX","list_index","index",
            "gyro","first_resting_period_time","final_resting_period_time",
            "final_resting_period_end_time","filenames","activity_time",
            "experiment_period","indx_list"))
#####

#************************ Question 14 ***************************
#*
#* On comparing the line plots of all the activities we do see the differences
#* between activities for each subject. On comparing the four activities of subject 1
#* we see that there are more spikes in activity 3 and activity 4 in the graph 
#* indicating that those activities involved some kind of physical activity 
#* compared to activity 2 and activity 1. We can see a similar kind of trend
#* in the activities of subject 2 and subject 3 but there seems to be a minor
#* error in the data collected for activity 1 and activity 2 or indicating that
#* the subjects were not idle while performing the experiment.  
#* 
#* On comparing the activities among each subject, for the first activity (sitting),
#* each subject has similar kind of trend but with few spikes. For the second 
#* activity (typing) subject 2 has more oscillation compared to subject 1 and 
#* subject 3. In the third activity (Stand and Look around), subject 1 was more 
#* active when compared to subject 2 and subject 3. And for the fourth activity 
#* (Stand and walk on the spot) subject 3 was more active then subject 1 and subject 2.
#* 
#* The box plot of mean values show that for all the activities the distribution is left
#* skewed. For the first activity mean is closer to zero. 
#* 
#* The box plot of standard deviation values shows the trend of the activities.
#* For activity 1 the rotational velocity is zero since the activity was of just
#* sitting idle. For activity 4 (stand and walk on spot), the median value is closer to the 
#* lower bound of the box, and the upper whisker is longer than the lower one,
#* indicating that the distribution is right skewed (the skewness is positive).
#* The similar trend can be seen from the box plots of activity 2 and activity 3 i.e.
#* they are right skewed.
#* 
#* The box and whiskers plot provides a cleaner representation of the general 
#* trend of the data, compared to the equivalent line charts.

