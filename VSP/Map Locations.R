suppressPackageStartupMessages(library(googleVis))

setwd("C:\\Users\\matr06619\\Documents\\Other\\MyProjects\\VSP")

locs <- read.csv("Locations.csv", stringsAsFactors = F)
locs$Sat.Open <- gsub("([^[:digit:]]*)(\\d*:\\d{2})( -.*)",
                      "\\2", locs$Sat.Hours)
locs$Sat.Close <- gsub("([^[:digit:]]*)(\\d*:\\d{2})( - )(\\d*:\\d{2})(.*)",
                       "\\4", locs$Sat.Hours)
locs$Full.Address <- paste(locs$Address, locs$City)
map <- gvisMap(locs, "Full.Address" , "Name", 
               options=list(showTip=TRUE, 
                            showLine=FALSE, 
                            enableScrollWheel=TRUE,
                            mapType='terrain', 
                            useMapTypeControl=FALSE))
plot(map)
cat(map$html$chart, file="Eye Store Map.html")

# Might be faster to get Lat:Lon first
## Look at network when loading to get the get function