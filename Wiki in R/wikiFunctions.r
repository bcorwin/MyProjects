getStartingLinks <- function(numLinks) {
    #Load packages
    require(RCurl)
    require(XML)
    
    output <- data.frame(pageName = character(numLinks),
                         pageLink = character(numLinks),
                         stringsAsFactors = FALSE)
    
    for(lNum in seq(numLinks)) {
        #Download html
        html <- getURL("http://en.wikipedia.org/wiki/Special:Random", followlocation = TRUE)
        doc = htmlParse(html, asText=TRUE)
        
        #Get title
        title <- xpathSApply(doc, "//title", xmlValue)
        output$pageName[lNum] <- gsub(" - Wikipedia, the free encyclopedia", "", title)
        
        #Get link
        output$pageLink[lNum] <- xpathSApply(doc, "//link[@rel='canonical']/@href")
    }
    output
}
rmBrackets <- function(str, l = "(", r = ")") {
    if(l %in% c("(", "{")) lOut <- paste("\\", l, sep = "") else lOut <- l
    if(r %in% c(")", "}")) rOut <- paste("\\", r, sep = "") else rOut <- r
    
    pattern <- paste(lOut, "[^(", l, ")(", r, ")]*", rOut, sep = "")
    for(s in seq(length(str))) {
        while(grepl(pattern, str[s])) {
            str[s] <- gsub(pattern, "", str[s])
            str[s] <- gsub("  ", " ", str[s])
        }        
    }
    str
}
rmHTMLfunc <- function(text, htmlFunc = "i") {
    start <- paste("<", htmlFunc, ">")
    end <- paste("</", htmlFunc, ">")
    
    starts <- gregexpr("<i>", text, ignore.case = TRUE)
    ends <- gregexpr("</i>", text, ignore.case = TRUE)
    
    text <- data.frame(str = text, stringsAsFactors = FALSE)
    text$starts <- starts
    text$ends <- ends
    text$stLens <- lapply(starts, attr, which = "match.length")
    text$endLens <- lapply(ends, attr, which = "match.length")
    
    output <- apply(text, 1,rmSubStrs)
    return(output)
    
}
rmSubStrs <- function(string) {
    if(string$starts[[1]] > -1) {
        funcCnt <- length(string$starts)
        rmVals <- NULL
        for(cnt in seq(funcCnt)) {
            startVal <- string$starts[[cnt]]
            endVal <- string$ends[[cnt]]
            endLen <-  string$endLens[[cnt]]
            rmVals <- c(rmVals, substr(string$str, startVal, endVal + endLen - 1))
        }
        rmVals <- paste(rmVals, collapse = "|")
        output <- gsub(rmVals, "", string$str)
    } else {
        output <- string$str
    }
    return(output)
}
getFirstLink <- function(url){
    #Load packages
    require(RCurl)
    require(XML)

    #Download html
    html <- getURL(url, followlocation = TRUE)
    html <- rmHTMLfunc(html)
    html <- rmBrackets(html)
    doc = htmlParse(html, asText=TRUE)
    
    #All links in paragraphs
    xPath <- "//div[@id = 'mw-content-text']/*[not(self::table)][not(self::div)]//a/@href"
    links <- xpathSApply(doc, xPath)
    ##Grab the above first, then remove <i> and ()s? then grab links? that way if error, do not remove ()s <i>
    
    link <- NA
    #Check links and grab the first
    for(lNum in seq(length(links))) {
        link <- links[[lNum]]
        if(grepl("/WIKI/", link, ignore.case = TRUE)) break
    }
    link <- paste("http://en.wikipedia.org", link, sep = "")
    link
}

test <- getStartingLinks(2)
test$firstLink <- sapply(test$pageLink, getFirstLink)

#Examples
##Parenthesis
###url <- "http://en.wikipedia.org/wiki/Jason_Da_Costa"
###http://en.wikipedia.org/wiki/Watisoni_Votu
###http://en.wikipedia.org/wiki/Augusto_Monti
###url <- "http://en.wikipedia.org/wiki/Mozambique" (Good one to test)
##Only list (no paragraph)
###url <- "http://en.wikipedia.org/wiki/White_Horse_Tavern"
##With tables
###url <- "http://en.wikipedia.org/wiki/333_BC"
##First link is truncationed (not fixed)
### url <- "http://en.wikipedia.org/wiki/Jos%C3%A9_Mar%C3%ADa_Bustillo"


#Plan:
##Get starting paths
##(create a function to find paths and add start -> first link to use as a look-up)
##Find paths (and loops) as lists in the starting path data frame