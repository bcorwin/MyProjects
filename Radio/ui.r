library(shiny)

shinyUI(fluidPage(
  tabsetPanel(
    tabPanel("Practice",
             h4(textOutput("Question")),
             actionButton("pickA", h5(textOutput("OptA"))), br(),
             actionButton("pickB", h5(textOutput("OptB"))), br(),
             actionButton("pickC", h5(textOutput("OptC"))), br(),
             actionButton("pickD", h5(textOutput("OptD"))), br(), br(),
             actionButton("Prev", h5("Previous")), actionButton("Next", h5("Next")),
             textOutput("Result"), br(),
             textOutput("cCnt"), textOutput("iCnt"), br(),
             actionButton("gradeMe", "Grade me"), textOutput("cGrade"),
             imageOutput("Fig")
      ),
    tabPanel("Options",
             radioButtons("Mode", "Question generation mode:",
                          c("Random" = "R",
                            "Quiz-like" = "Q"),
                          inline = TRUE),
             radioButtons("Grade", "Grade instantly:",
                          c("Yes" = "Y",
                            "No" = "N"),
                          inline = TRUE),
             actionButton("resetScore", "Reset Score"),
             actionButton("resetAns", "Reset Answers")
             )
    )
))

#Have tab with a sample test (that draws the correct number of questions from each sub/grp)
##With timer?
#Have a tab with the selection criteria (License/Subelement[/Group])
#Make sure to footnote the source
#Track correct/incorrect responses for random questions