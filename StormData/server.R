#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

# Define server logic required to draw a map
shinyServer(function(input, output) {
    stormData_state <- reactive({
        if (input$state == "All") {   # include all states in the storm data set.
            stormData_state <- stormData
        } else {
            stormData_state <- stormData[stormData$STATE == input$state, ]   # for the particular state that user selectd in the storm data set
        }
        
        if (input$evtype != "All") {   # for a particular event type that user selected.
            stormData_state <- stormData_state[stormData_state$EVTYPE == input$evtype,]
        } else {   # for all event type, will need to summerize the damages by each county.
            stormData_state <- stormData_state %>% group_by(STATE, COUNTYNAME, latitude, longitude) %>% summarise(FATALITIES = sum(FATALITIES), INJURIES = sum(INJURIES), PROPDMGCOST = sum(PROPDMGCOST), CROPDMGCOST = sum(CROPDMGCOST) )
            stormData_state <- as.data.frame(stormData_state) 
        }
        
        stormData_state
    })
    
   output$table <- renderTable({
      stormData_state()
   })
   
   output$row <- renderText({
      nrow(stormData_state()) 
   }) 
   
   output$map <- renderLeaflet({   #draw the map with marker and pop up information.
       stormData_state() %>% leaflet() %>% addTiles() %>% addMarkers(~longitude, ~latitude, popup = ~sprintf(
           'County = %s <br/> Fatalities = %s <br/> Injuries = %s <br/> Properties = $%s <br/> Crops = $%s', 
           as.character(COUNTYNAME), as.character(FATALITIES), as.character(INJURIES), as.character(format(PROPDMGCOST,big.mark=",")),
           as.character(format(CROPDMGCOST,big.mark=","))
       )) 
   })
})
