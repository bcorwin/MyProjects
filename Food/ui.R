library(shiny)
shinyUI( fluidPage(
  
  titlePanel("Local Retail Food Establishments"),
  
  sidebarLayout(
    mainPanel(
      dataTableOutput('mytable')
    )
    , sidebarPanel(
      htmlOutput('map'),
      actionButton("plotButton", "Plot selected locations")
      #textOutput('rows_out')
    )
  )
))


#To do:
##Make it so you can plot locations from different pages
##Add button to clear selected locations
##Add yelp/google reviews (e.g 1,2,3,4, or 5 starts)
##Add avg price (e.g. $, $$, etc.)
##Add address to tooltip (and other information)
##Try to tag the locations (e.g. fast food, fast causal, sit-down, etc.)
##Add food type tag (e.g. Asian, Indian, etc.)
##Track places I've been? Load/save data needed. Log ins?
##Add food trucks
