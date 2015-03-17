library(shiny)

load("radioQuestions.rdata")

set.seed(as.numeric(Sys.time()))

cCnt <<- 0
iCnt <<- 0
aCnt <<- 0
qNum <<- 0
lNext <<- 0
lPrev <<- 0

shinyServer(function(input, output) {
  output$cCnt <- renderText(paste("Correct:  ", cCnt))
  output$iCnt <- renderText(paste("Incorrect:", iCnt))
  
  cQues <- reactive({
    input$Mode
    input$Prev
    if(input$Next > lNext) {
      qNum <<- qNum %% nrow(quesList) + 1
      lNext <<- lNext + 1
    } else if(input$Prev > lPrev) {
      qNum <<- (qNum - 2) %% nrow(quesList) + 1
      lPrev <<- lPrev + 1
    } else {
      qNum <<- 1
    }
    
    aCnt <<- 0
    r <- randRows[qNum]
    
    output$Result <- renderText("")
    output$cGrade <- renderText("")
    
    if(input$Grade == "N") {
      if(!is.na(quesList[r,"sAns"])) {
        output$cCnt <- renderText("You've selected:")
        output$iCnt <- renderText(quesList$sAns[randRows[qNum]])
      } else {
        output$cCnt <- renderText("")
        output$iCnt <- renderText("")
      }
    }
    
    quesList[r,]
    })
  
  #Change mode
  observe({
    input$Mode
    isolate({
      if(input$Mode == "R") {
        quesList <<- quesDB
        randRows <<- sample(seq(1,nrow(quesList)))
        quesList$Result <<- NA
        quesList$sAns <<- NA
      } else if(input$Mode == "Q") {
        quesList <<- genQuiz(quesDB, subElements)
        quesList$Result <<- NA
        quesList$sAns <<- NA
        randRows <<- seq(nrow(quesList))
      }
      })
  })
  
  output$Question <-renderText(cQues()$Question)
  output$OptA <- renderText(cQues()$OptA)
  output$OptB <- renderText(cQues()$OptB)
  output$OptC <- renderText(cQues()$OptC)
  output$OptD <- renderText(cQues()$OptD)
  output$Fig <- renderImage({
    if(cQues()$Fig != "") {
      filename <- normalizePath(file.path(cQues()$Fig))
      list(src = filename)
    } else {
      filename <- normalizePath(file.path("Blank.jpg"))
      list(src = filename)
    }
    }, deleteFile = FALSE)
  
  #Grade me
  observe({
    input$gradeMe
    isolate({
      missCnt <- NA
      if(input$Mode == "Q") {
        results <- ifelse(is.na(quesList$Result), 0, quesList$Result)
        missCnt <- sum(is.na(quesList$Result))
      }
      else if(input$Mode == "R") results <- quesList$Result[!is.na(quesList$Result)]
      if(!is.na(mean(results))) {
        if(!is.na(missCnt)) {
          output$cGrade <- renderText(
            paste0("Your grade: ",sprintf("%.f%%", 100*mean(results)),
            " (", missCnt, " are missing)"))
        } else {
          output$cGrade <- renderText(
            paste("Your grade:",sprintf("%.f%%", 100*mean(results)))) 
        }
      }
      
    })
  })
  
  #Resets
  observe({
    input$resetScore
    isolate({
      cCnt <<- 0
      iCnt <<- 0
      output$cCnt <- renderText("")
      output$iCnt <- renderText("")
    })
  })
  observe({
    input$resetAns
    isolate({
      quesList$sAns <<- NA
      quesList$Result <<- NA
      output$cCnt <- renderText("")
      output$iCnt <- renderText("")
    })
  })
  
  sAns <- NA
  observe({
    if (input$pickA == 0) return()
    isolate({
      sAns <- "A"
      aCnt <<- aCnt + 1
      res <- cQues()$Ans == sAns
      quesList$sAns[randRows[qNum]] <<- sAns

      if(res & aCnt == 1) {
        cCnt <<- cCnt + 1
        quesList$Result[randRows[qNum]] <<- 1.0
      }
      else if (aCnt == 1) {
        iCnt <<- iCnt + 1
        quesList$Result[randRows[qNum]] <<- 0.0
      }
      
      if(input$Grade == "Y") {
        if(res) output$Result <- renderText("Correct!")
        else output$Result <- renderText("Incorrect.")
        output$cCnt <- renderText(paste("Correct:  ", cCnt))
        output$iCnt <- renderText(paste("Incorrect:", iCnt))
      } else {
        output$cCnt <- renderText("You've selected:")
        output$iCnt <- renderText(quesList$sAns[randRows[qNum]])
      }

    })
  })
  observe({
    if (input$pickB == 0) return()
    isolate({
      sAns <- "B"
      aCnt <<- aCnt + 1
      res <- cQues()$Ans == sAns
      quesList$sAns[randRows[qNum]] <<- sAns
      
      if(res & aCnt == 1) {
        cCnt <<- cCnt + 1
        quesList$Result[randRows[qNum]] <<- 1.0
      }
      else if (aCnt == 1) {
        iCnt <<- iCnt + 1
        quesList$Result[randRows[qNum]] <<- 0.0
      }
      
      if(input$Grade == "Y") {
        if(res) output$Result <- renderText("Correct!")
        else output$Result <- renderText("Incorrect.")
        output$cCnt <- renderText(paste("Correct:  ", cCnt))
        output$iCnt <- renderText(paste("Incorrect:", iCnt))
      } else {
        output$cCnt <- renderText("You've selected:")
        output$iCnt <- renderText(quesList$sAns[randRows[qNum]])
      }
    })
  })
  observe({
    if (input$pickC == 0) return()
    isolate({
      sAns <- "C"
      aCnt <<- aCnt + 1
      res <- cQues()$Ans == sAns
      quesList$sAns[randRows[qNum]] <<- sAns
      
      if(res & aCnt == 1) {
        cCnt <<- cCnt + 1
        quesList$Result[randRows[qNum]] <<- 1.0
      }
      else if (aCnt == 1) {
        iCnt <<- iCnt + 1
        quesList$Result[randRows[qNum]] <<- 0.0
      }
      
      if(input$Grade == "Y") {
        if(res) output$Result <- renderText("Correct!")
        else output$Result <- renderText("Incorrect.")
        output$cCnt <- renderText(paste("Correct:  ", cCnt))
        output$iCnt <- renderText(paste("Incorrect:", iCnt))
      } else {
        output$cCnt <- renderText("You've selected:")
        output$iCnt <- renderText(quesList$sAns[randRows[qNum]])
      }
    })
  })
  observe({
    if (input$pickD == 0) return()
    isolate({
      sAns <- "D"
      aCnt <<- aCnt + 1
      res <- cQues()$Ans == sAns
      quesList$sAns[randRows[qNum]] <<- sAns
      
      if(res & aCnt == 1) {
        cCnt <<- cCnt + 1
        quesList$Result[randRows[qNum]] <<- 1.0
      }
      else if (aCnt == 1) {
        iCnt <<- iCnt + 1
        quesList$Result[randRows[qNum]] <<- 0.0
      }
      
      if(input$Grade == "Y") {
        if(res) output$Result <- renderText("Correct!")
        else output$Result <- renderText("Incorrect.")
        output$cCnt <- renderText(paste("Correct:  ", cCnt))
        output$iCnt <- renderText(paste("Incorrect:", iCnt))
      } else {
        output$cCnt <- renderText("You've selected:")
        output$iCnt <- renderText(quesList$sAns[randRows[qNum]])
      }
    })
  })
})

genQuiz <- function(db, se) {
  cQuiz <- db[0,]
  for(sNum in seq(nrow(se))) {
    cSub <- se[sNum,]
    add <- getQues(db, cSub$Sub, cSub$qCnt)
    cQuiz <- rbind(cQuiz, add)
  }
  return(cQuiz)
}
getQues <- function(db, Sub, Cnt) {
  out <- db[db$Sub == Sub, ]
  out <- out[sample(nrow(out), Cnt),]
  return(out)
}