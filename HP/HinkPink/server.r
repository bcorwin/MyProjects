library(shiny)

function(input, output) {
  output$ans <- renderDataTable({
    solveHP(input$word1, input$word2,
            scnt = hps[hps$name == input$ss, "scnt"])
  }, options = list(paging = FALSE,
                    language = list(emptyTable = paste("No suggested answers found.")),
                    columnDefs = list(list(targets = c(1, 2) - 1, searchable = FALSE)),
                    search = list(regex = TRUE))
  )
  output$synAns <- renderDataTable({
    scnt <- syllCnts[syllCnts$name == input$sss, "scnt"]
    syns <- findSynonyms(input$syn)
    
    if(!any(is.na(syns))) {
      sylls <- sapply(syns, function(x) {
        s <- getSyllableCnt(x)[[1]]
        if(is.na(s)) return("Unknown")
        else if(length(s) > 1) return(paste(s, collaspse = " or "))
        else return(as.character(s))
      }, USE.NAMES = FALSE)
      
      out <- data.frame(Synonyms = syns, Syllables = sylls,
                        stringsAsFactors = FALSE)
    } else {
      out <- data.frame(Synonyms = character(0), Syllables = character(0),
                        stringsAsFactors = FALSE)
    }
    if(!is.na(scnt)) {
      if(scnt != -1) out <- out[grepl(as.character(scnt), out$Syllables),]
      else out <- out[out$Syllables == "Unknown",]
    }
    out    
  }, options = list(paging = FALSE,
                    language = list(emptyTable = paste("No synonyms found.")),
                    columnDefs = list(list(targets = c(0,1), searchable = FALSE)),
                    search = list(regex = TRUE))
  )
  
  output$rhyAns <- renderDataTable({
    scnt <- syllCnts[syllCnts$name == input$rss, "scnt"]
    rhys <- findRhymes(input$rhy)[,"Word"]
    
    if(length(rhys) > 0) {
      sylls <- sapply(rhys, function(x) {
        s <- getSyllableCnt(x)[[1]]
        if(is.na(s)) return("Unknown")
        else if(length(s) > 1) return(paste(s, collaspse = " or "))
        else return(as.character(s))
      }, USE.NAMES = FALSE)
      
      out <- data.frame(Rhymes = rhys, Syllables = sylls,
                        stringsAsFactors = FALSE)
    } else {
      out <- data.frame(Synonyms = character(0), Syllables = character(0),
                        stringsAsFactors = FALSE)
    }
    if(!is.na(scnt)) {
      if(scnt != -1) out <- out[grepl(as.character(scnt), out$Syllables),]
      else out <- out[out$Syllables == "Unknown",]
    }
    out    
  }, options = list(paging = FALSE,
                    language = list(emptyTable = paste("No rhymes found.")),
                    columnDefs = list(list(targets = c(0,1), searchable = FALSE)),
                    search = list(regex = TRUE))
  )
  
  output$ansTitle <- renderText({
    if(input$word1 != "" & input$word2 != "") {
      paste0("Suggested answers for '",
             toupper(input$word1), " ", toupper(input$word2), "'")
    } else ""
  })
  output$synAnsTitle <- renderText({
    if(input$syn != "") {
      paste0("Synonyms for '", toupper(input$syn), "'")
    } else ""
  })
  output$rhyAnsTitle <- renderText({
    if(input$rhy != "") {
      paste0("Rhymes for '", toupper(input$rhy), "'")
    } else ""
  })
  
  output$ansSub <- renderText({
    if(input$word1 != "" & input$word2 != "") input$ss
    else ""
  })
}