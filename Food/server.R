library(shiny)
library(ggmap)
suppressPackageStartupMessages(library(googleVis))

office <- data.frame(DOING.BUSINESS.AS.NAME = "Work",
                     LATITUDE = 41.879252,
                     LONGITUDE = -87.637087,
                     stringsAsFactors = FALSE)
load("LocationList.rdata")
displayData <- LocationList[ ,
                            c("DOING.BUSINESS.AS.NAME", "ADDRESS", "DISTANCE", "MAP.LINK")]
displayData$DISTANCE <- round(displayData$DISTANCE, 2)
displayData$MAP.LINK <- paste0("<a href='", displayData$MAP.LINK ,"' target='_blank'>Link</a>")

colnames(displayData) <- c("Name", "Address", "Distance (mi)", "Directions")

function(input, output) {
  output$mytable <- renderDataTable(
    displayData[,c("Name", "Address", "Distance (mi)", "Directions")],
    options = list(
      lengthMenu = list(c(25, 50, 100, -1), c("25", "50", "100", "All")),
      columnDefs = list(list(targets = c(3, 4) - 1, searchable = FALSE))
      ),
    callback = "function(table) {
      table.on('click.dt', 'tr', function() {
        $(this).toggleClass('selected');
        Shiny.onInputChange('rows',
        table.rows('.selected').data().toArray());
      });
    }"
  )
  output$map <- renderGvis({
    
    input$plotButton
    
    isolate({
      if(length(input$rows) > 0) {
        temp <- as.data.frame(matrix(input$rows, ncol = 4, byrow = TRUE),
                              stringsAsFactors = FALSE)
        names(temp) <- c("DOING.BUSINESS.AS.NAME", "ADDRESS", "DISTANCE", "MAP.LINK")
        plotValues <- merge(temp, LocationList,
                            by = c("DOING.BUSINESS.AS.NAME", "ADDRESS"))
        plotValues <- plotValues[,c("DOING.BUSINESS.AS.NAME","LATITUDE", "LONGITUDE")]
      } else plotValues <- LocationList[,c("DOING.BUSINESS.AS.NAME","LATITUDE", "LONGITUDE")]
      
      plotValues <- rbind(office, plotValues)
      plotValues$LatLong <- with(plotValues, paste(LATITUDE,LONGITUDE, sep = ":"))
      gvisMap(plotValues, "LatLong" , "DOING.BUSINESS.AS.NAME", 
              options=list(showTip=TRUE, 
                           showLine=FALSE, 
                           enableScrollWheel=FALSE,
                           mapType='terrain', 
                           useMapTypeControl=FALSE))
    })
    
  })
}