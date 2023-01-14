# Data-Capture-using-Sensors

## Project: Human Activity Data Collection

### Introduction
Human Activity Recognition (HAR) is the field of research concerned with identifying specific physical activities of a person using sensor data. Examples of human activities are: walking, running, sitting, sleeping, driving, etc. HAR has been applied to keep track of elderly people, in the design of smart home environments, in human-computer interaction, and smart driving assistants.
As a data scientist/analyst, you are required to collect sensor data from a group of subjects and to store the data in a structured way, so it can be used for further analysis. Knowing the data capture process and how to use sensors to collect data are skills that help the data scientist to understand the data, identify possible sources of errors, and to determine an appropriate data preparation procedure.

### Collecting Data using Sensors
- In this task, you are required to use an Arduino Uno development board to collect sensor data and to measure different human activities. You will use a gyroscope (MPU-6050) to obtain orientation information (x,y,z) and the Arduino Uno to read that information from the gyroscope.
- The MPU-6050 has a 3-Axis accelerometer, a 3-Axis gyroscope, and a temperature sensor integrated on a single chip. However, for this assignment, we will use the 3-Axis gyroscope data only.
- The gyroscope measures rotational velocity or rate of change of the angular position over time, along the X, Y, Z axis. The outputs of the gyroscope are in degrees per second, to obtain the angular position we need to integrate the angular velocity. In this assignment, we do not need to compute the angular velocity, we only need to record the raw data.
- You need to record the 3-Axis data produced by the gyroscope, these data will be used for further analysis in R. The gyroscope’s data will be read by the Arduino and then transmitted over the USB port. We will capture the data using the terminal emulator Tera Term and save it as .CSV or .txt file.
- Each activity should be done for 30 seconds, with a 10 seconds rest period before and after each activity. Use the reset button to start and finish each activity. The activities are:
  1. Sitting (act1). The participants will be in a sitting position on a chair, try to maintain a still position (do not move your feet and arms) as much as you can.
  2. Sitting while working at a computer (act2). The participant will be typing and using the mouse in this task. Open a word document and type a few of lines for 30 seconds (s). For example, type your name and describe the reasons why you are studying a Master’s degree. After the activity is finished, close the word document and do not save the file.
  3. Standing and look around (act3). The participant will stand up from a sitting position and will remain in standing position while looking to the right, front, and left (repeatedly).
  4. Standing and walking on the spot (act4). The participant will stand up from a sitting position and will simulate walking on the same place. Orientation of axes of sensitivity and polarity of rotation.

------------------
Folder Description:
------------------
Data => This folder contains the 12 csv files that are to be used in the R code.
(additional) Output => contains the graphs (i.e. plots) for question 10 and question 13 in pdf format.

------------------
Files Description:
------------------
Data_Visualisation.R => R code file for running the data visualisations.

------
Notes:
------
Please keep the R script (code) and the Data folder in the same folder.
