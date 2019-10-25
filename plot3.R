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

# Plot 3: line
par(mfcol = c(1, 1))

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
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.copy(png, file = "plot3.png", width = 480, height = 480, units = "px")
dev.off()
