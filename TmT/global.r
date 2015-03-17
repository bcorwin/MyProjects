library(markdown)
library(knitr)

test <- FALSE

colorOptions <- data.frame(name = c("Standard",
                                    "Color blind safe",
                                    "Standard (dark)"),
                           val1 = c("#008000", "#1b9e77", "#006400"),
                           val2 = c("#FFFF00","#7570b3", "#DAA520"),
                           val3 = c("#FF0000","#d95f02", "#8B0000"),
                           stringsAsFactors = FALSE
)

colortable <- function(htmltab, css, style="table-condensed table-bordered"){
  tmp <- strsplit(htmltab, "\n")[[1]]
  CSSid <- gsub("\\{.+", "", css)
  CSSid <- gsub("^[\\s+]|\\s+$", "", CSSid)
  CSSidPaste <- gsub("#", "", CSSid)
  CSSid2 <- paste(" ", CSSid, sep = "")
  ids <- paste0("<td id='", CSSidPaste, "'")
  for (i in 1:length(CSSid)) {
    locations <- grep(CSSid[i], tmp)
    tmp[locations] <- gsub("<td", ids[i], tmp[locations])
    tmp[locations] <- gsub(CSSid2[i], "", tmp[locations], 
                           fixed = TRUE)
  }
  htmltab <- paste(tmp, collapse="\n")
  Encoding(htmltab) <- "UTF-8"
  list(
    tags$style(type="text/css", paste(css, collapse="\n")),
    tags$script(sprintf( 
      '$( "table" ).addClass( "table %s" );', style
    )),
    HTML(htmltab)
  )
}

allResults <- data.frame("Orator" = character(),
                         "Start Time" = character(),
                         "Speech Length" = character(),
                         stringsAsFactors = FALSE)
names(allResults) <- c("Orator", "Start Time", "Speech Length")

resultsTable <- colortable(markdownToHTML(text = kable(allResults),
                                          fragment.only = TRUE), "")

getFGcolor <- function(bgColor) {
  threshold <- 105
  rgb <- list(r = strtoi(substr(bgColor, 2, 3), base = 16),
              g = strtoi(substr(bgColor, 4, 5), base = 16),
              b = strtoi(substr(bgColor, 6, 7), base = 16))
  
  bgDelta <- (rgb$r * 0.299) + (rgb$g * 0.587) + (rgb$b * 0.114)
  
  if((255 - bgDelta) < threshold) return("#000000")
  else return("#FFFFFF")
}
