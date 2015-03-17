library(shiny)

function(input, output, session) {
  output$buttonText <- renderText({
    input$timerButton
    isolate({
      if(input$mode == "Begin") {
        updateTextInput(session, "orator", value = "")
        updateTabsetPanel(session, "allTabs", selected = "Options")
        updateTextInput(session, "mode", value = "Start")
        "Start"
      } else if(input$mode == "Start") {
        startTime <<- Sys.time()
        colorSwitch <<- c(FALSE, FALSE, FALSE)
        
        if(test == TRUE) {
          firstTime <<- startTime + 2
          secondTime <<- startTime + 4
          thirdTime <<- startTime + 6
        } else {
          firstTime <<- startTime + 60*lengths[1]
          secondTime <<- startTime + 60*lengths[2]
          thirdTime <<- startTime + 60*lengths[3]  
        }
        
        updateTextInput(session, "mode", value = "Stop")
        "Stop"
      } else if (input$mode == "Stop") {
        timeLen <- as.numeric(difftime(Sys.time(), startTime), units = "mins") 
        
        mins <- sprintf("%02.f", floor(timeLen))
        secs <- sprintf("%02.f", floor(60*(timeLen - floor(timeLen))))
        timeResult <- paste0(mins, ":", secs)
        
        css <- c("#bg0 {background-color: #FFFFFF;}",
                 paste0("#bg1 {color: ", getFGcolor(selectedColors[1]),
                        "; background-color: ",selectedColors[1],";}"),
                 paste0("#bg2 {color: ", getFGcolor(selectedColors[2]),
                        "; background-color: ",selectedColors[2],";}"),
                 paste0("#bg3 {color: ", getFGcolor(selectedColors[3]),
                        "; background-color: ",selectedColors[3],";}"))
        
        bgCol <- "#bg0"
        if(colorSwitch[1] == TRUE) bgCol <- "#bg1"
        if(colorSwitch[2] == TRUE) bgCol <- "#bg2"
        if(colorSwitch[3] == TRUE) bgCol <- "#bg3"
        
        addResult <- data.frame("Orator" = input$orator,
                                "Start Time" = strftime(startTime, "%H:%M",
                                                        tz = input$tzSelected),
                                "Speech Length" = paste(timeResult, bgCol),
                                stringsAsFactors = FALSE)
        names(addResult) <- c("Orator", "Start Time", "Speech Length")
        
        if(exists("allResults")) allResults <<- rbind(allResults, addResult)
        else allResults <<- addResult
        
        out <- markdownToHTML(text = kable(allResults), fragment.only = TRUE)
        resultsTable <<- colortable(out, css)
        
        updateTextInput(session, "mode", value = "Time")
        timeResult
      } else {
        updateTextInput(session, "mode", value = "Begin")
        "Begin"
      }
    })
  })
  
  output$outResults <- renderUI({
    input$mode
    resultsTable
  })
  
  runTimer <- reactiveTimer(100, session)
  
  output$timer <- renderText({
    runTimer()
    
    if(input$mode == "Stop") {      
      cTime <- Sys.time()
      
      if(cTime >= thirdTime)  colorSwitch[3] <<- changeBGcolor(
        selectedColors[3], flash = input$doFlash & !colorSwitch[3])
      else if(cTime >= secondTime) colorSwitch[2] <<- changeBGcolor(
        selectedColors[2], flash = input$doFlash & !colorSwitch[2])
      else if(cTime >= firstTime) colorSwitch[1] <<- changeBGcolor(
        selectedColors[1], flash = input$doFlash & !colorSwitch[1])
      else changeBGcolor(color = "#FFFFFF", flash = FALSE)
      
      if(input$showTimer == TRUE) {
        timer <- as.numeric(difftime(Sys.time(), startTime), units = "mins")
        mins <- sprintf("%02.f", floor(timer))
        secs <- sprintf("%02.f", floor(60*(timer - floor(timer))))
        paste0(mins, ":", secs)
      } else ""
    } else {
      changeBGcolor(color = "#FFFFFF", flash = FALSE)
      ""
    }
  })
  
  observe({
    temp <- as.numeric(unlist(strsplit(input$timePreset, split = "- ")))
    
    updateNumericInput(session, "first", value = temp[1])
    updateNumericInput(session, "second", value = temp[2])
    updateNumericInput(session, "third", value = temp[3])
  })
  observe({
    temp <- t(colorOptions[colorOptions$name == input$colorOptions,-1])
    session$sendCustomMessage(type = "changeFirst", temp[1])
    session$sendCustomMessage(type = "changeSecond", temp[2])
    session$sendCustomMessage(type = "changeThird", temp[3])
  })
  
  output$setResult <- renderText({
    result <- "Set Timer"
    if(input$setOptions > 0) {
      isolate(
        if(input$second <= input$first) result <- "Second time is less than first."
        else if(input$third <= input$second) result <- "Third time is less than Second."
        else {
          lengths <<- c(input$first, input$second, input$third)
          selectedColors <<- t(colorOptions[colorOptions$name == input$colorOptions,-1])
          updateTabsetPanel(session, "allTabs", selected = "Timer")
        }
      )
    }
    result
  })
  
  changeBGcolor <- function(color, flash) {
    if(flash == TRUE) {
      session$sendCustomMessage(type = "changeColor", color)
      for(c in seq(5)) {
        Sys.sleep(.1)
        session$sendCustomMessage(type = "changeColor", "#FFFFFF")
        Sys.sleep(.1)
        session$sendCustomMessage(type = "changeColor", color)
      }
    } else {
      session$sendCustomMessage(type = "changeColor", color)
    }
    return(TRUE)
  }
}