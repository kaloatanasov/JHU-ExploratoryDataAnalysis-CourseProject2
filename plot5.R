## Exploratory Data Analysis - Week 4 - Course Project 2

## Read the two data files, after placing the provided folder in the working directory

NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

head(NEI)
str(NEI)

## Find the appropriate means to isolate motor vehicle sources and subset based on that.

unique(SCC$Data.Category)

## One of the four data categories in the SCC data set is "Onroad", which is a good starting point.

subSCC <- subset(SCC, Data.Category == "Onroad")
head(subSCC)
tail(subSCC)

## The data related to the "Onroad" category seems to be the one related to motor vehicle sources.
## This category is available in the NEI data set as well (as "ON-ROAD"), under the "type" variable.

## Subset for Baltimore City, Maryland, Emissions, year, and type equal to "ON_ROAD"

install.packages("data.table")
library(data.table)

subFips <- subset(NEI, fips == "24510", select = c(Emissions, type, year))
head(subFips)
subType <- subset(subFips, type == "ON-ROAD", select = c(Emissions, year))
head(subType)

## Calculate sum of PM2.5 for each year with the "dplyr" package

install.packages("dplyr")
library(dplyr)

totalPm <- subType %>% group_by(year) %>% summarise_all(funs(sum))
str(totalPm)

## Plot the results

plot(totalPm$year, totalPm$Emissions, type = "l", xlab = "Year", ylab = "Total Emissions",
     main = "Total Emissions per Year, for Baltimore City,MD, from Motor Vehicles", xaxt = "n")
axis(1, at = totalPm$year)

## Once the plot has been figured out, open the appropriate graphics file device;
## in this case it's png.

png(filename = "plot5.png", width = 550, height = 550, units = "px", bg = "transparent")
plot(totalPm$year, totalPm$Emissions, type = "l", xlab = "Year", ylab = "Total Emissions",
     main = "Total Emissions per Year, for Baltimore City,MD, from Motor Vehicles", xaxt = "n")
axis(1, at = totalPm$year)
dev.off()

## Make sure the device was closed properly with dev.off().
