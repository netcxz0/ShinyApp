library(shiny)
library(leaflet)
library(dplyr)

options(shiny.maxRequestSize=30*1024^2)

prod <- function(dmgexp) {
    if (dmgexp %in% c("h", "H")) return(100)
    else if (dmgexp %in% c("k", "K")) return(1000)
    else if (dmgexp %in% c("m", "M"))  return(1000000)
    else if (dmgexp %in% c("b", "B"))  return(1000000000)
    else if (dmgexp %in% c("1":"9")) return(as.numeric(dmgexp))
    else return( 0)                                      
}

#load storm data once when application loaded
selectCol <- c("COUNTYNAME", "STATE", "EVTYPE", "FATALITIES", "INJURIES", "PROPDMGCOST", "CROPDMGCOST")

stormData <- read.csv("data/stormData.csv", na.strings = "", comment.char = "#")
stormData$PROPDMGCOST <- stormData$PROPDMG * sapply(stormData$PROPDMGEXP, prod)
stormData$CROPDMGCOST <- stormData$CROPDMG * sapply(stormData$CROPDMGEXP, prod)

#load geocodes data 
geocodes <- read.csv("data/Geocodes_USA_with_Counties.csv", header = TRUE)

#select relevant columns only
stormData <- stormData[stormData$FATALITIES > 0 | stormData$INJURIES > 0 | stormData$PROPDMGCOST > 0 | stormData$CROPDMGCOST > 0, selectCol]

#group by state, county, event, then sum the numbers
stormData <- stormData %>% group_by(STATE, COUNTYNAME, EVTYPE) %>% summarise(FATALITIES = sum(FATALITIES), INJURIES = sum(INJURIES), PROPDMGCOST = sum(PROPDMGCOST), CROPDMGCOST = sum(CROPDMGCOST) )

#convert back to data frame
stormData <- as.data.frame(stormData)

#add geocodes into stormData
stormData <- cbind(stormData, geocodes[match(tolower(paste(stormData$STATE, as.character(stormData$COUNTYNAME))), tolower(paste(geocodes$state, as.character(geocodes$county)))), c("latitude", "longitude")])

#remove rows without geocodes
stormData <- stormData[!is.na(stormData$latitude), ]


