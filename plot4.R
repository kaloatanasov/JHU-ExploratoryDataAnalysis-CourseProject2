## Exploratory Data Analysis - Week 4 - Course Project 2

## Read the two data files, after placing the provided folder in the working directory

NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

head(NEI)
str(NEI)

## Find the Pollutant code for coal combustion-related sources and subset based on that.

## We start by looking for "Coal", then for combustion (or "Comb") in the "Short.Name" variable.

subSCC <- SCC[grep("Coal", SCC$Short.Name), ]
subSCC <- subSCC[grep("Comb", subSCC$Short.Name), ]

head(subSCC)

## To avoid repeating codes, isolate the unique values of the "SCC" variables and store them in a
## character vector, which will be used to subset the NEI data set later on.

valuesSCC <- unique(as.character(subSCC$SCC))
class(valuesSCC)
length(valuesSCC)

## Subset the NEI data set for the appropriate SCC codes (in the valuesSCC value), Emissions, and year.

install.packages("data.table")
library(data.table)

subNEI <- subset(NEI, SCC %in% valuesSCC, select = c(Emissions, year))

head(subNEI)
tail(subNEI)

## Calculate sum of PM2.5 for each year with the "dplyr" package

install.packages("dplyr")
library(dplyr)

totalPM <- subNEI %>% group_by(year) %>% summarise_all(funs(sum))
str(totalPM)

## Plot the results

plot(totalPM$year, totalPM$Emissions, type = "l", xlab = "Year", ylab = "Total Emissions",
     main = "Total Emissions (PM2.5) per Year from Coal Combustion", xaxt = "n")
axis(1, at = totalPM$year)

## Once the plot has been figured out, open the appropriate graphics file device;
## in this case it's png.

png(filename = "plot4.png", width = 480, height = 480, units = "px", bg = "transparent")
plot(totalPM$year, totalPM$Emissions, type = "l", xlab = "Year", ylab = "Total Emissions",
     main = "Total Emissions (PM2.5) per Year from Coal Combustion", xaxt = "n")
axis(1, at = totalPM$year)
dev.off()

## Make sure the device was closed properly with dev.off().
