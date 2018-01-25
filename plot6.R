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

subBC <- subset(NEI, fips == "24510", select = c(fips, Emissions, type, year))
head(subBC)
subTypeBC <- subset(subBC, type == "ON-ROAD", select = c(fips, Emissions, year))
head(subTypeBC)

## Subset for Los Angeles County, California, Emissions, year, and type equal to "ON_ROAD"

subLA <- subset(NEI, fips == "06037", select = c(fips, Emissions, type, year))
head(subLA)
subTypeLA <- subset(subLA, type == "ON-ROAD", select = c(fips, Emissions, year))
head(subTypeLA)

## Row bind the Baltimore and LA subsets together

subNEI <- rbind(subTypeBC, subTypeLA, stringsAsFactors = FALSE)
str(subNEI)

## Calculate the sum of PM2.5 for each region (Baltimore and LA), and for each year with the "dplyr" package

install.packages("dplyr")
library(dplyr)

totalPM <- subNEI %>% group_by(fips, year) %>% summarise_all(funs(sum))
str(totalPM)

## Install the ggplot2 package, plot the required graph, and highlight the different "fips" sub groups

install.packages("ggplot2")
library(ggplot2)

ggplot(totalPM, aes(year, Emissions, group = fips)) +
        geom_line(aes(color = fips)) +
        geom_point(aes(color = fips)) +
        labs(title = "Total Emissions per Year, for Los Angeles, CA and Baltimore, MD") +
        labs(x = "Year", y = "Total Emissions") +
        scale_color_discrete(name = "Location",
                             labels = c("Los Angeles, CA", "Baltimore, MD"))

## Once the plot has been figured out, open the appropriate graphics file device;
## in this case it's png.

png(filename = "plot6.png", width = 550, height = 550, units = "px", bg = "transparent")
ggplot(totalPM, aes(year, Emissions, group = fips)) +
        geom_line(aes(color = fips)) +
        geom_point(aes(color = fips)) +
        labs(title = "Total Emissions per Year, for Los Angeles, CA and Baltimore, MD") +
        labs(x = "Year", y = "Total Emissions") +
        scale_color_discrete(name = "Location",
                             labels = c("Los Angeles, CA", "Baltimore, MD"))
dev.off()

## Make sure the device was closed properly with dev.off().
