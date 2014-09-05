setwd("C:/Data/Other Stuff/Projects/CTA Card")
options(stringsAsFactors = FALSE)
require(stringr)

stationLoc <- read.csv("cta_L_stops.csv")
stationLoc <- subset(stationLoc, !duplicated(stationLoc$STATION_DESCRIPTIVE_NAME),
                     select = c("LAT", "LON", "STATION_NAME", "STATION_DESCRIPTIVE_NAME"))

stationLoc$LINE.LIST <- str_extract_all(gsub(" Line(s)*|,|& |- ", "",
                                             stationLoc$STATION_DESCRIPTIVE_NAME), "\\([^()]+\\)")
stationLoc$LINE.LIST <- strsplit(substring(stationLoc$LINE.LIST, 2, nchar(stationLoc$LINE.LIST) - 1), " ")
stationLoc$LINE.COUNT <- sapply(stationLoc$LINE.LIST, length)

stationLocFinal = data.frame(Merge.On = character(),
                             LAT = numeric(),
                             LON = numeric())
for(rowNum in seq(nrow(stationLoc))) {
    LAT = stationLoc$LAT[rowNum]
    LON = stationLoc$LON[rowNum]
    lineCnt = stationLoc$LINE.COUNT[rowNum]
    
    addStations = data.frame(Merge.On = character(lineCnt + 1),
                             LAT = LAT, LON = LON)
    addStations$Merge.On[1] = toupper(stationLoc$STATION_NAME[rowNum])
    
    for(lineNum in seq(lineCnt)) {
        addName = toupper(paste(addStations$Merge.On[1],stationLoc$LINE.LIST[[rowNum]][lineNum],
                          sep = "_"))
        addStations$Merge.On[1 + lineNum] = toupper(addName)
    }
        
    stationLocFinal = rbind(stationLocFinal, addStations)
}