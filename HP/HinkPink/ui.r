library(shiny)
footnote <- paste0("Version 1.1 created by Benjamin Scott Corwin. Last published on ",
                   format(Sys.Date(), format="%B %d, %Y"), ".")

shinyUI(tabsetPanel(
  tabPanel("Hink-Pink Finder", fluidPage(
    titlePanel("Hink-Pink Finder"),
    sidebarLayout(
      sidebarPanel(
        textInput("word1", "First Clue"),
        textInput("word2", "Second Clue"),
        selectInput("ss", "Syllable Count", hps$name),    
        submitButton("Find Suggestions")
      ), mainPanel(
        h3(textOutput("ansTitle")),
        h4(textOutput("ansSub")), br(),
        dataTableOutput("ans")
      )
    ),
    br(),footnote
  )),
  tabPanel("Synonyms", fluidPage(
    titlePanel("Synonym Finder"),
    sidebarLayout(
      sidebarPanel(
        textInput("syn", "Word"),
        selectInput("sss", "Syllable Count", syllCnts$name),
        submitButton("Find Suggestions")
      ), mainPanel(
        h3(textOutput("synAnsTitle")), br(),
        dataTableOutput("synAns")
      )
    ),
    br(),footnote
  )),
  tabPanel("Rhymes", fluidPage(
    titlePanel("Rhyme Finder"),
    sidebarLayout(
      sidebarPanel(
        textInput("rhy", "Word"),
        selectInput("rss", "Syllable Count", syllCnts$name[-5]),
        submitButton("Find Suggestions")
      ), mainPanel(
        h3(textOutput("rhyAnsTitle")), br(),
        dataTableOutput("rhyAns")
      )
    ),
    br(),footnote
  ))
))

# Add tabs:
## Synonym finder
## Rhyme finder
## Directions/other info
# Replace submit buttons with buttons