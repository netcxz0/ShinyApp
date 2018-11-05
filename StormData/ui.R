#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that use leaflet and draw the event map.  The map has markers with pop up infomration for the county name and 
# the number of fatalities and injuries, and the property and crop damages in the dollar amount caused by the storm.

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Storm Damage Data"),
  
  # Sidebar with two drop down list inputs for state and event selection. 
  sidebarLayout(
    sidebarPanel(
       selectInput("state", "State: ", choices = c("All", unique(as.character(stormData$STATE))[order(unique(as.character(stormData$STATE)))])),
       selectInput("evtype", "Event: ", choices = c("All", unique(as.character(stormData$EVTYPE))[order(unique(as.character(stormData$EVTYPE)))])),
       submitButton("Submit"),
       #h3("Total rows: "),
       #textOutput("row"),
       width = 2
    ),
    
    # Show a plot of the map with markers.
    mainPanel(
      
       
       h3("Storm Damage Map: "),
       h4("This project involves exploring the U.S National Oceanic and Atmospheric Administration’s (NOAA) storm database, This database tracks characteristics of major storms and weathere events in the Inited States, including when and where they occure, as well as estimates of any fatalities, injuries, and property damage."),
       h4("Select the state from the state drop down list and the event type from the Event drop down list, the map will display the county with map marker, click at the marker to pop up the damages caused by the storm"),
       leafletOutput("map", height = 1000)
       
     #  h3("Storm Data dimention: "),
     #  tableOutput("table")
    )
  )
))
