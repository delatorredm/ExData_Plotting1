# LOAD AND READ DATA
filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("household_power_consumption.txt")) { 
  unzip(filename) 
}

dataReq <- (2075259 *9*8)/2^20

library(data.table)
dataPower <- fread("household_power_consumption.txt", 
                   sep = ";", header = TRUE, na.strings = "?")

dataPower[,DT := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

library(dplyr)
subDataT <- filter(dataPower, DT >= as.POSIXct("2007-02-01 00:00:00"), DT < as.POSIXct("2007-02-03 00:00:00"))

## Main plotting code
with(subDataT, plot(DT, Sub_metering_1, type="l", xlab = "", ylab = "Energy sub metering"))
with(subDataT, lines(DT, Sub_metering_2, type="l", col = "red"))
with(subDataT, lines(DT, Sub_metering_3, type="l", col = "blue"))
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = c(1,1,1), col = c("black", "red", "blue"))

# Output file
dev.copy(png, "plot3.png", width=480, height=480)
dev.off()
