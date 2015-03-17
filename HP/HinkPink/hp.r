library(RCurl)
library(XML)

findSynonyms <- function(words) {
  wordList <- thes$Synonyms[thes$Word %in% toupper(words)]
  if(length(wordList) == 0) return(NA)
  out <- strsplit(thes$Synonyms[thes$Word %in% toupper(words)],
                  split = ",")[[1]]
  return(sort(unique(out)))
}

findRhymes <- function(words, syllables = NA) {
  end <- rdict$Stressed.Ending[rdict$Word %in% toupper(words)]
  out <- rdict[rdict$Stressed.Ending %in% end,]
  if(any(!is.na(syllables))) out <- out[out$Syllable.Cnt %in% syllables,]
  out <- unique(out[,c('Word','Stressed.Ending')])
  return(out)
}

getSyllableCnt <- function(word) {
 ans <- rdict[rdict$Word == toupper(word), "Syllable.Cnt"]
 if(length(ans) > 0) return(unique(ans))
 else return(NA)
}

findHits <- function(phrase) {
  site <- getForm("http://www.google.com/search",
                  hl="en", lr="", q= phrase, btnG="Search")
  rcnt <- as.character(sub("(.*About )([[:digit:],]+)( results.*)", "\\2", site))
  rcnt <- as.numeric(gsub(",", "", rcnt))
  return(rcnt)
}

solveHP <- function(word1, word2, scnt = NA) {
  #Way to force a word (e.g. I konw the first  word is Camo)
  #findSynonyms errors out, needs to return NA
  #Plurals (e.g. Measures-Platforms)
  #Check google for number of hist, use google n grams?
  #use google suggestions to get other paired words instead of just synonyms
  # Do another layer of synonyms?
  slist1 <- unique(c(findSynonyms(word1), toupper(word1)))
  slist2 <- unique(c(findSynonyms(word2), toupper(word2)))
  rhymes1 <- findRhymes(slist1, syllables = scnt)
  rhymes2 <- findRhymes(slist2, syllables = scnt)
  
  m1 <-match(slist1, rhymes2$Word)
  m1<- m1[!is.na(m1)]

  m2 <-match(slist2, rhymes1$Word)
  m2 <- m2[!is.na(m2)]
  
  words <- merge(rhymes2[m1, ], rhymes1[m2, ],
               by = "Stressed.Ending")[, c("Word.x", "Word.y")]
  words <- words[words$Word.x != words$Word.y,]
  
  out <- data.frame("First Word" = words$Word.x, "Second Word" = words$Word.y,
                    stringsAsFactors = FALSE)
  #out$Score <- sapply(paste0(out$First.Word, out$Second.Word), findHits, USE.NAMES = FALSE)
  #if(nrow(out) == 0) return(as.data.frame("No suggested answers found."))
  names(out) <- c("First Word", "Second Word")
  return(out)
}
