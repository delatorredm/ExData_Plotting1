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

# Device
png("plot4.png", width=480, height=480)

# Set up graphics device
par(mfrow=c(2,2))

# Plot 1
plot(subDataT$DT, subDataT$Global_active_power, type="l", xlab = "", ylab = "Global Active Power")

# Plot 2
plot(subDataT$DT, subDataT$Voltage, type="l", xlab = "datetime", ylab = "Voltage")

# Plot 3
with(subDataT, plot(DT, Sub_metering_1, type="l", xlab = "", ylab = "Energy sub metering"))
with(subDataT, lines(DT, Sub_metering_2, type="l", col = "red"))
with(subDataT, lines(DT, Sub_metering_3, type="l", col = "blue"))
legend("topright", 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty = c(1,1,1), col = c("black", "red", "blue"),
       bty = "n")

# Plot 4
plot(subDataT$DT, subDataT$Global_reactive_power, type="l", xlab = "datetime", ylab = "Global_reactive_power")

# Output file
dev.off()
