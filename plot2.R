## Exploratory Data Analysis - Week 4 - Course Project 2

## Read the two data files, after placing the provided folder in the working directory

NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

head(NEI)

## Subset for Baltimore City, Maryland, Emissions, and year

install.packages("data.table")
library(data.table)

subFips <- subset(NEI, fips == "24510", select = c(Emissions, year))
head(subFips)

## Calculate sum of PM2.5 for each year, for Baltimore City, Maryland and create new data frame with the values

pmSum <- with(subFips, tapply(Emissions, year, sum, na.rm = TRUE))
pmSum

pmYear <- data.table(Year = names(pmSum), Emissions = pmSum)
str(pmYear)

## Plot the results

plot(pmYear$Year, pmYear$Emissions, type = "l", xlab = "Year", ylab = "Total Emissions",
     main = "Total Emissions (PM2.5) per Year for Baltimore City, MD", xaxt = "n")
axis(1, at = pmYear$Year)

## Once the plot has been figured out, open the appropriate graphics file device;
## in this case it's png.

png(filename = "plot2.png", width = 480, height = 480, units = "px", bg = "transparent")
plot(pmYear$Year, pmYear$Emissions, type = "l", xlab = "Year", ylab = "Total Emissions",
     main = "Total Emissions (PM2.5) per Year for Baltimore City, MD", xaxt = "n")
axis(1, at = pmYear$Year)
dev.off()

## Make sure the device was closed properly with dev.off().
