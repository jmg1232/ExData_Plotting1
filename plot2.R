
setwd("C:/JHU_EDA_2014/")


############################################################################################################
# if data file already exists, use it, otherwise build it
############################################################################################################

###################################################################################
# data file already exists use it:
###################################################################################
if(file.exists("household_power_consumption.rds")){
ds1 <- readRDS("household_power_consumption.rds")
}


###################################################################################
# data file DOESn't exist, so build it 
###################################################################################
if(!file.exists("household_power_consumption.rds")){
#############################################################################################################
###  Using method from: http://www.ocf.berkeley.edu/~mikeck/?p=688 to download, unzip, and build data set
### Uses temporary file and temporary directory to store the file
#############################################################################################################
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
td = tempdir()
# create the placeholder file
tf = tempfile(tmpdir=td, fileext=".zip")
# download into the placeholder file
download.file(fileUrl, tf)
# The data has now been downloaded to a temporary file, and the full path is contained in tf.
# You’ll notice I’ve also explicitly created a temporary directory, which I’ll use for extracting the
# data from the archive. The unzip()function can be used to query the contents of a zip file
# and extract files to a specified location. In my case, the zip file will always contain a single file
# in CSV format.
# get the name of the first file in the zip archive
fname = unzip(tf, list=TRUE)$Name[1]
# unzip the file to the temporary directory
unzip(tf, files=fname, exdir=td, overwrite=TRUE)
# fpath is the full path to the extracted file
fpath <- file.path(td, fname)
ds1 <- read.table(fpath, header=TRUE, sep=";", na.strings = "?" ,  row.names=NULL, stringsAsFactors=FALSE)
# close connections to tempfiles and tempdirectories
unlink(tf)
unlink(td)
studyDates <- c("1/2/2007", "2/2/2007")
nrow(ds1)
#[1] 2075259

#################################################################################
# only keep records from Feb 01, 2007 and Feb 02, 2007
#################################################################################
ds1 <- ds1[which(ds1$Date %in% studyDates),]
nrow(ds1)
# [1] 2880
str(ds1)
# 'data.frame':  2880 obs. of  9 variables:
#  $ Date                 : chr  "1/2/2007" "1/2/2007" "1/2/2007" "1/2/2007" ...
#  $ Time                 : chr  "00:00:00" "00:01:00" "00:02:00" "00:03:00" ...
#  $ Global_active_power  : num  0.326 0.326 0.324 0.324 0.322 0.32 0.32 0.32 0.32 0.236 ...
#  $ Global_reactive_power: num  0.128 0.13 0.132 0.134 0.13 0.126 0.126 0.126 0.128 0 ...
#  $ Voltage              : num  243 243 244 244 243 ...
#  $ Global_intensity     : num  1.4 1.4 1.4 1.4 1.4 1.4 1.4 1.4 1.4 1 ...
#  $ Sub_metering_1       : num  0 0 0 0 0 0 0 0 0 0 ...
#  $ Sub_metering_2       : num  0 0 0 0 0 0 0 0 0 0 ...
#  $ Sub_metering_3       : num  0 0 0 0 0 0 0 0 0 0 ...
###################################################################################
# convert Date to date, Combine Date and Time and convert to DateTime
###################################################################################
# convert character date to date.  Dates are of the form day/month/year(4 digit)
ds1$date <- as.Date(ds1$Date, "%d/%m/%Y")
#  str(ds1$date)
#  Date[1:2880], format: "2007-02-01" "2007-02-01" "2007-02-01" "2007-02-01" "2007-02-01" "2007-02-01" "2007-02-01" "2007-02-01" "2007-02-01" ...

# Combine character date and time and convert to datetime using strptime.
# Note that need %Y since have 4 digit year.
ds1$DateTime <- strptime(paste(ds1$Date,ds1$Time), "%d/%m/%Y %H:%M:%S")
#str(ds1$DateTime )
# POSIXlt[1:2880], format: "2007-02-01 00:00:00" "2007-02-01 00:01:00" "2007-02-01 00:02:00" "2007-02-01 00:03:00"  ...
# Save data.frame since using it for all 4 graphs
write.csv(ds1, file="household_power_consumption.csv")
saveRDS(ds1, file="household_power_consumption.rds")
# to load use:  ds2 <- readRDS("household_power_consumption.rds")
}

###################################################################################################
# Start plot code
###################################################################################################


# # Plot1
# png("plot1.png", width=480, height=480, units="px")
# with(ds1, hist(Global_active_power, xlab="Global Active Power (kilowatts)", main="Global Active Power", col="red"))
# dev.off();

# Plot2
png("plot2.png", width=480, height=480, units="px")
with(ds1, plot(DateTime, Global_active_power, type='n', ylab="Global Active Power (kilowatts)", xlab=""))
with(ds1, lines(DateTime, Global_active_power))
dev.off()

# #Plot3
# png("plot3.png", width=480, height=480, units="px")
# with(ds1, plot(DateTime, Sub_metering_1, col="black", type='n', xlab="", ylab="Energy sub metering"))
# with(ds1, lines(DateTime, Sub_metering_1, col="black"))
# with(ds1, lines(DateTime, Sub_metering_2, col="red"))
# with(ds1, lines(DateTime, Sub_metering_3, col="blue"))
# legend("topright", col=c("black", "red", "blue"), lty=c(1,1,1), lwd=c(1,1,1), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
# dev.off()

#Plot 4
# Plot2
# line plot of Voltage vs DateTime (xlab="datetime")
# plot 3
# line plot of Global_reactive_power vs DateTime (xlab="datetime")

# png("plot4.png", width=480, height=480, units="px")
# par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
# #fig 1.1 repeat plot 2
# with(ds1, plot(DateTime, Global_active_power, type='n', ylab="Global Active Power", xlab=""))
# with(ds1, lines(DateTime, Global_active_power))
# # fig 1.2 line plot of Voltage vs DateTime (xlab="datetime")
# with(ds1, plot(DateTime, Voltage, type='n', ylab="Voltage", xlab="datetime"))
# with(ds1, lines(DateTime, Voltage))
# # fig 2.1 (repeat Fig 3)
# with(ds1, plot(DateTime, Sub_metering_1, col="black", type='n', xlab="", ylab="Energy sub metering"))
# with(ds1, lines(DateTime, Sub_metering_1, col="black"))
# with(ds1, lines(DateTime, Sub_metering_2, col="red"))
# with(ds1, lines(DateTime, Sub_metering_3, col="blue"))
# legend("topright", col=c("black", "red", "blue"), lty=c(1,1,1), lwd=c(1,1,1), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
# # fig 2.2 line plot of Global_reactive_power vs DateTime (xlab="datetime")
# with(ds1, plot(DateTime, Global_reactive_power, type='n', ylab="Global_reactive_power", xlab="datetime"))
# with(ds1, lines(DateTime, Global_reactive_power))
# dev.off()
# 
# 


# if(!file.exists("data")) {
#     dir.create("data")
# }
# 
# 




