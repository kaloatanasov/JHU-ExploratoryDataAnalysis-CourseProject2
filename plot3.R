## Exploratory Data Analysis - Week 4 - Course Project 2

## Read the two data files, after placing the provided folder in the working directory

NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

head(NEI)
str(NEI)

## Subset for Baltimore City, Maryland, Emissions, year, and type

install.packages("data.table")
library(data.table)

subFips <- subset(NEI, fips == "24510", select = c(Emissions, type, year))
head(subFips)

## Calculate sum of PM2.5 for each type, for each year, for Baltimore City, Maryland with the "dplyr" package

install.packages("dplyr")
library(dplyr)

totalPm <- subFips %>% group_by(type, year) %>% summarise_all(funs(sum))
str(totalPm)

## Install the ggplot2 package, plot the required graph, and highlight the different "type" sub groups

install.packages("ggplot2")
library(ggplot2)

qplot(year, Emissions, data = totalPm, color = type, geom = "line", xlab = "Year", ylab = "Total Emissions",
      main = "Total Emissions (PM2.5) per Year, per Type, for Baltimore City, MD")

## Once the plot has been figured out, open the appropriate graphics file device;
## in this case it's png.

png(filename = "plot3.png", width = 550, height = 550, units = "px", bg = "transparent")
qplot(year, Emissions, data = totalPm, color = type, geom = "line", xlab = "Year", ylab = "Total Emissions",
      main = "Total Emissions (PM2.5) per Year, per Type, for Baltimore City, MD")
dev.off()

## Make sure the device was closed properly with dev.off().
