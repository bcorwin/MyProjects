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


getFirstLink <- function(url){
    #Load packages
    require(RCurl)
    require(XML)

    #Download html
    html <- getURL(url, followlocation = TRUE)
    #html <- rmItalics(html)
    #html <- gsub("([[:digit:]])\\)[^.!]", "\\1\\.", html)
    #html <- rmBrackets(html)
    doc = htmlParse(html, asText=TRUE)
    
    #All links in paragraphs
    xPath <- "//div[@id = 'mw-content-text']/*[not(self::table)][not(self::div)]//a/@href"
    links <- xpathSApply(doc, xPath)
    ##Grab the above first, then remove <i> and ()s? then grab links? that way if error, do not remove ()s <i>
    
    link <- NA
    #Check links and grab the first
    for(lNum in seq(length(links))) {
        link <- links[[lNum]]
        if(grepl("/wiki/", link)) break
    }
    link <- paste("http://en.wikipedia.org", link, sep = "")
    link
}

test <- getStartingLinks(25)
test$firstLink <- sapply(test$pageLink, getFirstLink)

#Examples
##Parenthesis
###http://en.wikipedia.org/wiki/Jason_Da_Costa
###http://en.wikipedia.org/wiki/Watisoni_Votu
###http://en.wikipedia.org/wiki/Augusto_Monti
###http://en.wikipedia.org/wiki/Mozambique (also goes to HELP:IPA)
##Only list (no paragraph)
###http://en.wikipedia.org/wiki/White_Horse_Tavern
##With tables
###url <- "http://en.wikipedia.org/wiki/333_BC"


#Plan:
##Get starting paths
##(create a function to find paths and add start -> first link to use as a look-up)
##Find paths (and loops) as lists in the starting path data frame


#remove (), needs to be recursively done though
gsub("\\([^()]*\\)", "", pTest)