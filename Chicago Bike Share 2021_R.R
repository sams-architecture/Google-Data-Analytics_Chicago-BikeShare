### Cyclistic Bike-Share Analysis Case Study ###

# # # # # # # # # # # # # # # # # # # # # # # 
# Install required packages
# tidyverse for data import and wrangling
# lubridate for date functions
# ggplot for visualization
# # # # # # # # # # # # # # # # # # # # # # #  

install.packages("tidyverse")

library(tidyverse)  #data wrangling
# # # # # # # # # # # # # # # # # # # # # # # 
# Revised 09.25.25 - Following lines no longer needed - Included with Tidyverse
#library(lubridate)  #importing and wrangling date attributes
#library(ggplot2)  #visualizing the data
# # # # # # # # # # # # # # # # # # # # # # # 

getwd() #display my working directory
# # # # # # # # # # # # # # # # # # # # # # # 
# Revised 09.25.25 - Updated for new computer
#setwd("C:/Users/SMorimune/Desktop/Google_Data_Analytics_Capstone_BikeShare/Capstone_BikeShare_Datasets_CSV") 
# # # # # # # # # # # # # # # # # # # # # # # 

setwd("/Users/smorimune/Desktop/Google_Data_Analytics_Capstone_BikeShare/Capstone_BikeShare_Datasets_CSV") 
#connect with my working directory

#=====================
# STEP 1: COLLECT DATA
#=====================
# Upload 2021 Divvy tripdata datasets, one per month, provided by Divvy at https://ride.divvybikes.com/system-data -> Download Divvy trip history data.
M01_2021 <- read_csv("202101-divvy-tripdata.csv")
M02_2021 <- read_csv("202102-divvy-tripdata.csv")
M03_2021 <- read_csv("202103-divvy-tripdata.csv")
M04_2021 <- read_csv("202104-divvy-tripdata.csv")
M05_2021 <- read_csv("202105-divvy-tripdata.csv")
M06_2021 <- read_csv("202106-divvy-tripdata.csv")
M07_2021 <- read_csv("202107-divvy-tripdata.csv")
M08_2021 <- read_csv("202108-divvy-tripdata.csv")
M09_2021 <- read_csv("202109-divvy-tripdata.csv")
M10_2021 <- read_csv("202110-divvy-tripdata.csv")
M11_2021 <- read_csv("202111-divvy-tripdata.csv")
M12_2021 <- read_csv("202112-divvy-tripdata.csv")

#====================================================
# STEP 2: WRANGLE DATA AND COMBINE INTO A SINGLE FILE
#====================================================
# Compare column names of each of the files
# Although column names do not have to be in the same order, they do need to match perfectly before we can append them together as one dataframe.
colnames(M01_2021)
colnames(M02_2021)
colnames(M03_2021)
colnames(M04_2021)
colnames(M05_2021)
colnames(M06_2021)
colnames(M07_2021)
colnames(M08_2021)
colnames(M09_2021)
colnames(M10_2021)
colnames(M11_2021)
colnames(M12_2021)

# Review the dataframes and look for inconsistent, irrelevant, and inappropriate data.
str(M01_2021)
str(M02_2021) 
str(M03_2021) 
str(M04_2021) 
str(M05_2021) 
str(M06_2021) 
str(M07_2021) 
str(M08_2021) 
str(M09_2021) 
str(M10_2021) 
str(M11_2021) 
str(M12_2021)

# Append individual month's dataframes into one comprehensive dataframe
all_trips <- bind_rows(M01_2021, M02_2021, M03_2021, M04_2021, M05_2021, M06_2021, M07_2021, M08_2021,M09_2021, M10_2021, M11_2021, M12_2021)

#======================================================
# STEP 3: CLEAN AND ADD DATA TO PREPARE FOR ANALYSIS
#======================================================
# Review the new dataframe that has been created
colnames(all_trips)  #List of column names
nrow(all_trips)  #How many rows are in data frame?
dim(all_trips)  #Dimensions of the data frame?
head(all_trips)  #See the first 6 rows of data frame.  
tail(all_trips)  #See the last 6 rows of data frame. 
str(all_trips)  #See list of columns and data types (numeric, character, etc)
summary(all_trips)  #Statistical summary of data.

# Data quality issues:
# (1) Data can only be aggregated at the ride-level, which is too granular. We will want to add some additional columns of data -- such as day, month, year -- that provide additional opportunities to aggregate the data.
# (2) Add a calculated field for "ride_length" (trip duration).
# (3) Some rides have negative ride_length values, including several hundred rides where Divvy took bikes out of service for Quality Control reasons. Delete these rides to minimize skewing the analysis results.

# Add columns with date, month, day, and year values for each ride to aggregate trip data.
# https://www.statmethods.net/input/dates.html more on date formats in R found at that link
all_trips$date <- as.Date(all_trips$started_at) #The default format is yyyy-mm-dd
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")

# Add a "ride_length" calculation to all_trips (in seconds)
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/difftime.html
all_trips$ride_length <- difftime(all_trips$ended_at,all_trips$started_at)

# Review the structure of the columns
str(all_trips)

# Convert "ride_length" from Factor to numeric so we can run calculations on the data
is.factor(all_trips$ride_length)
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length)

# Remove "bad" data
# The dataframe includes a few hundred entries when bikes were taken out of docks and checked for quality by Divvy or ride_length was negative
# Create a new version of the dataframe (v2) for modified dataframe.
# https://www.datasciencemadesimple.com/delete-or-drop-rows-in-r-with-conditions-2/
all_trips_v2 <- all_trips[!(all_trips$start_station_name == "Base - 2132 W Hubbard Warehouse" | all_trips$ride_length<0),]

#=====================================
# STEP 4: CONDUCT DESCRIPTIVE ANALYSIS
#=====================================
# Descriptive analysis on ride_length (all results in seconds)
mean(all_trips_v2$ride_length) #average (total ride length / rides)
median(all_trips_v2$ride_length) #midpoint number of ride lengths
max(all_trips_v2$ride_length) #longest ride
min(all_trips_v2$ride_length) #shortest ride

# Condense all four lines above into one line using summary() on the specific attribute
summary(all_trips_v2$ride_length)

# Compare members and casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)

# Average ride time by day for members vs. casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

# Organize the days of the week order, starting with Sunday.
all_trips_v2$day_of_week <- ordered(all_trips_v2$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

# Average ride time by each day for members vs casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

# Analyze trip data by type and weekday
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  #creates weekday field using wday()
  group_by(member_casual, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n()                            #calculates the number of rides and average duration 
            ,average_duration = mean(ride_length)) %>%         # calculates the average duration
  arrange(member_casual, weekday)                                # sorts

# Visualization of number of rides by rider type
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

# Visualization of average duration
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")

#=================================================
# STEP 5: EXPORT SUMMARY FILE FOR FURTHER ANALYSIS
#=================================================
# Create a csv file that we will visualize in Excel, Tableau, or my presentation software

counts <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

print(counts)

# # # # # # # # # # # # # # # # # # # # # # # 
# Revised 09.25.25 - Updated for new computer
#write.csv(counts, file = "C:\\Users\\smorimune\\Desktop\\Google_Data_Analytics_Capstone_BikeShare\\Capstone_BikeShare_Datasets_CSV_Clean.csv") 
# # # # # # # # # # # # # # # # # # # # # # # 

write.csv(counts, file = "\\Users\\smorimune\\Desktop\\Google_Data_Analytics_Capstone_BikeShare\\Capstone_BikeShare_Datasets_CSV_Clean.csv")


#You're done! Congratulations!


