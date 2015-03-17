library(shiny)

timeZones <- c("US/Eastern", "US/Central", "US/Mountain", "US/Pacific")
timePresets <- c("1 - 1.5 - 2",
                 "3 -  4  - 5",
                 "5 -  6  - 7")

shinyUI( fluidPage(includeScript('color.js'),
  tags$head(
    tags$style(HTML("
      .center {
        position: absolute;
        width: 100px;
        height: 50px;
        top: 50%;
        left: 50%;
        margin-left: -50px;
        margin-top: -25px; 
      }
      .myFull {position: absolute;width: 100vw; height: 100vh}
     "))
    
  ),
  
  tabsetPanel(id = "allTabs",
              tabPanel("Timer", id = "Timer",
                       div(class="myFull",
                           div(class = "center",
                               actionButton("timerButton", h4(textOutput("buttonText"))),
                               textOutput("timer")
                           )
                           
                       ),
                       div(style="display: none;", textInput("mode",""))
              ),
              tabPanel("Options", id = "Options",
                       selectInput("tzSelected", "Time zone",
                                   choices = timeZones, selected = "US/Central"),
                       selectInput("colorOptions", "Color Options",
                                   choices = colorOptions$name, selected = colorOptions$name[1]),
                       selectInput("timePreset", "Time Presets",
                                   choices = timePresets, selected = timePresets[1]),
                       div(class = "firstCol",
                           numericInput("first", "1st",
                                        as.numeric(strsplit(timePresets[1], "- ")[[1]][1]),
                                        min = 0, step = .5)),
                       numericInput("second", "2nd",
                                    as.numeric(strsplit(timePresets[1], "- ")[[1]][2]),
                                    min = 0, step = .5),
                       numericInput("third", "3rd",
                                    as.numeric(strsplit(timePresets[1], "- ")[[1]][3]),
                                    min = 0, step = .5),
                       textInput("orator", "Orator (optional)"),
                       checkboxInput("doFlash", "Flash on color change", value = FALSE),
                       checkboxInput("showTimer", "Show timer", value = TRUE),
                       actionButton("setOptions", textOutput("setResult"))
              ),
              tabPanel("Results", id = "results", fluidPage(fluidRow(column(2,
                       uiOutput("outResults")))))
  )
))