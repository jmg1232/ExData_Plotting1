
#setwd("C:/Users/jeff/Desktop/JHU_eda2014/ExData_Plotting1")

if (!file.exists("data")){
      dir.create("data")
}

# Set dates to keep.  Date is in format  day/month/year
# only keep records from Feb 01, 2007 and Feb 02, 2007
studyDates <- c("1/2/2007", "2/2/2007")

############################################################################################################
# if data file already exists, use it, otherwise build it
############################################################################################################

###################################################################################
# If data file already exists use it:
###################################################################################
if(file.exists("./data/household_power_consumption.rds")){
      ds1 <- readRDS("./data/household_power_consumption.rds")
}

###################################################################################
# If data file doesn't already exist, so build it:
###################################################################################

if(!file.exists("./data/household_power_consumption.rds")){
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
      # A temporary directory has been created to extract the data from the zip file.
      # The unzip()function is used to query the contents of a zip file
      # and extract files to a specified location. I
      #
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
      write.csv(ds1, file="./data/household_power_consumption.csv")
      saveRDS(ds1, file="./data/household_power_consumption.rds")
      # to load use:  ds2 <- readRDS("./data/household_power_consumption.rds")
}

###################################################################################################
# Start plot code
###################################################################################################

# Plot2
png("plot2.png", width=480, height=480, units="px")
with(ds1, plot(DateTime, Global_active_power, type='n', ylab="Global Active Power (kilowatts)", xlab=""))
with(ds1, lines(DateTime, Global_active_power))
dev.off()

