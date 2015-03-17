setwd("C:\\Users\\matr06619\\Documents\\R Scripts\\Radio")

#raw <- readLines(".\\Raw Data\\Questions.txt")

maxCnt <- length(raw)
qStartPattern <- "^([[:alnum:]]*)[[:blank:]]\\(([[:alpha:]])\\)(([[:blank:]]\\[.*){0,1})"
aStartPattern <- "^[[:alpha:]]\\."
sStartPattern <- "SUBELEMENT[[:blank:]]([[:alpha:]][[:digit:]]+)([[:blank:]].[[:blank:]])*(.*)"
gStartPattern <- "([[:alpha:]][[:digit:]]+)([[:alpha:]])([[:blank:]].[[:blank:]])*(.*)"
figPattern <- "(.*FIGURE[[:blank:]])([[:alpha:]][[:digit:]]+)(.*)"

subElements <- data.frame(Sub = character(maxCnt),
                          Description = character(maxCnt),
                          stringsAsFactors = FALSE)
groups <- data.frame(Sub = character(maxCnt),
                     Grp = character(maxCnt),
                     Description = character(maxCnt),
                     stringsAsFactors = FALSE)
quesDB <- data.frame(QuesID = character(maxCnt),
                     Sub = character(maxCnt),
                     Grp = character(maxCnt),
                     Question = character(maxCnt),
                     Ans = character(maxCnt),
                     ansCol = character(maxCnt),
                     OptA = character(maxCnt),
                     OptB = character(maxCnt),
                     OptC = character(maxCnt),
                     OptD = character(maxCnt),
                     #OptE = character(maxCnt),
                     Ref = character(maxCnt),
                     Fig = character(maxCnt),
                     stringsAsFactors = FALSE)
qCnt <- 0
sCnt <- 0
gCnt <- 0
qStartRow <- 0
for(rnum in seq(1,length(raw))) {
  row <- raw[rnum]
  if(grepl(sStartPattern, row, ignore.case = TRUE) == TRUE) {
    sCnt <- sCnt + 1
    subElements[sCnt, "Sub"] <- gsub(sStartPattern, "\\1", row, ignore.case = TRUE)
    subElements[sCnt, "Description"] <- gsub(sStartPattern, "\\3", row, ignore.case = TRUE)
  } else if (grepl(qStartPattern, row, ignore.case = TRUE) == TRUE) {
    qCnt <- qCnt + 1
    qStartRow <- rnum
    
    quesDB[qCnt, "QuesID"]<- gsub(qStartPattern, "\\1", row, ignore.case = TRUE)
    quesDB[qCnt, "Ans"]   <- gsub(qStartPattern, "\\2", row, ignore.case = TRUE)
    quesDB[qCnt, "Ref"]   <- gsub(qStartPattern, "\\3", row, ignore.case = TRUE)
    quesDB[qCnt, "ansCol"] <- paste0("Opt", quesDB[qCnt, "Ans"])
    
    quesDB[qCnt, "Sub"] <- substr(quesDB[qCnt, "QuesID"], 1, 2)
    quesDB[qCnt, "Grp"] <- substr(quesDB[qCnt, "QuesID"], 3, 3)
  } else if (grepl(aStartPattern, row, ignore.case = TRUE) == TRUE) {
    colNum <- match(substr(row, 1, 1), LETTERS) + match("OptA", names(quesDB)) - 1
    quesDB[qCnt, colNum] <- row
  } else if (rnum == qStartRow + 1) {
    quesDB[qCnt, "Question"] <- row
    
    if(grepl(figPattern, row, ignore.case = TRUE) == TRUE) {
      quesDB[qCnt, "Fig"] <- paste0(gsub(figPattern, "\\2", row, ignore.case = TRUE),
                                    ".jpg")
    }
    
  } else if(grepl(gStartPattern, row, ignore.case = TRUE) == TRUE) {
    gCnt <- gCnt + 1
    groups[gCnt, "Sub"] <- gsub(gStartPattern, "\\1", row, ignore.case = TRUE)
    groups[gCnt, "Grp"] <- gsub(gStartPattern, "\\2", row, ignore.case = TRUE)
    groups[gCnt, "Description"] <- gsub(gStartPattern, "\\4", row, ignore.case = TRUE)
  }
}
quesDB <- quesDB[seq(1,qCnt),]
subElements <- subElements[seq(1,sCnt),]
subElements$qCnt <- as.numeric(gsub("(.*\\[.*)([[:digit:]]+)(.*exam.*\\])", "\\2",
                          subElements$Description, ignore.case = TRUE))
groups <- groups[seq(1,gCnt),]

save(quesDB, subElements, groups,
     file = "radioQuestions.rdata")