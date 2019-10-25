# Download the data
if (!file.exists("power.zip")) {
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(url, destfile = "power.zip")
}

# Load in the data
unzip("power.zip")
data <- read.csv("household_power_consumption.txt", 
                 sep = ";", 
                 stringsAsFactors = FALSE)

# Convert Date column to date objects
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")

# Strip off dates outside 2007-02-01 and 2007-02-02
data <- data[grep("2007-02-01|2007-02-02", data$Date),]

# Create a POSIXlt datetime column from the component parts
DTcombo <- paste(data$Date, data$Time)
data$DTcombo <- strptime(DTcombo, format = "%Y-%m-%d %H:%M:%S")

# Convert data to numeric
data[,3:9] <- sapply(data[,3:9], as.numeric)

# Plot 4: amalgam
# Setup for 4 plots
par(mfcol = c(2, 2))
par(mar = c(4, 4, 1, 1))

# 4.1: Plot 2
plot(x = data$DTcombo, 
     y = data$Global_active_power,
     type = "l",
     col = "black",
     ylab = "Global Active Power",
     xlab = "",
     fg = "black")

# 4.2: Plot 3
plot(x = data$DTcombo,
     y = data$Sub_metering_1,
     type = "l",
     ylab = "Energy sub metering",
     xlab = "")

points(x = data$DTcombo,
       y = data$Sub_metering_2,
       type = "l",
       col = "red")

points(x = data$DTcombo,
       y = data$Sub_metering_3,
       type = "l",
       col = "blue")

legend("topright", 
       lty = 1, 
       col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       bty = "n")

# 4.3: line
plot(x = data$DTcombo,
     y = data$Voltage,
     type = "l",
     col = "black",
     ylab = "Voltage",
     xlab = "datetime")

# 4.4: line
plot(x = data$DTcombo,
     y = data$Global_reactive_power,
     type = "l",
     col = "black",
     ylab = "Global_reactive_power",
     xlab = "datetime")

dev.copy(png, file = "plot4.png", width = 480, height = 480, units = "px")
dev.off()
