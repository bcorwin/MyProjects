#Source: https://data.cityofchicago.org/Community-Economic-Development/Business-Licenses/r5kz-chrr
#Source(map): https://data.cityofchicago.org/Transportation/Street-Center-Lines/6imu-meau

setwd("C:\\Data\\Other Stuff\\Projects\\Local Businesses")
require(reshape2)

alldata <- read.csv("Business_Licenses.csv", stringsAsFactors = FALSE)
addysplit <- colsplit(alldata$ADDRESS, " ", c("NUMBER", "DIR", "STREET.NAME", "ROAD", "APT"))
alldata <- cbind(alldata, addysplit)
alldata$IN.NS <- alldata$NUMBER >= "4750" & alldata$NUMBER < "5350" &
                    alldata$STREET.NAME %in% c("BROADWAY", "WINTHROP", "KENMORE", "SHERIDAN")
alldata$IN.EW <- alldata$NUMBER >= "950" & alldata$NUMBER < "1250" &
                    alldata$STREET.NAME %in% c("BERWYN", "FOSTER", "WINONA", "CARMEN", "WINNEMAC", "ARGYLE", "AINSLIE", "LAWRENCE", "GUNNISON")
alldata$EXPIRE.DATE <- as.Date(alldata$LICENSE.TERM.EXPIRATION.DATE, "%m/%d/%Y")

currlocal <- alldata[(alldata$IN.NS | alldata$IN.EW) == "TRUE"
                     & alldata$EXPIRE.DATE >= as.Date("05/27/2014", "%m/%d/%Y"),]
currlocal <- currlocal[order(currlocal$ACCOUNT.NUMBER,currlocal$SITE.NUMBER),]

LICENSES <- currlocal[,c("ACCOUNT.NUMBER", "LICENSE.DESCRIPTION")]
names(LICENSES) = c("ACCOUNT.NUMBER", "LICENSE.LIST")
for(row in 2:nrow(LICENSES)) {
  if(LICENSES$ACCOUNT.NUMBER[row] == LICENSES$ACCOUNT.NUMBER[row-1]) {
    LICENSES$LICENSE.LIST[row] <- paste(LICENSES$LICENSE.LIST[row-1], LICENSES$LICENSE.LIST[row], sep = "|")
  }
}
for(row in 1:(nrow(LICENSES)-1)) {
  if(LICENSES$ACCOUNT.NUMBER[row] == LICENSES$ACCOUNT.NUMBER[row+1]) {
    LICENSES$LICENSE.LIST[row] <- NA
  }
}
LICENSES <- LICENSES[!is.na(LICENSES$LICENSE.LIST),]
currlocal <- merge(currlocal, LICENSES)
currlocal$lat <- as.numeric(currlocal$LATITUDE)
currlocal$lon <- as.numeric(currlocal$LONGITUDE)

output <- currlocal[!duplicated(currlocal[c("ACCOUNT.NUMBER", "DOING.BUSINESS.AS.NAME")]),
                    c("DOING.BUSINESS.AS.NAME","NUMBER","DIR","STREET.NAME","ROAD","LICENSE.LIST","lat", "lon")]

write.table(output, "Business_List.csv", sep = ",", na = "", row.names = FALSE)

withVists <- read.csv("Business_List _withVists.csv")
withVists <- withVists[!is.na(withVists$lon),]

require(maps)
require(ggmap)
map <- get_googlemap(c(lon=-87.656,lat=41.9740), zoom = 16, maptype = "roadmap")
legend <- scale_colour_discrete(name = "Visited?")
ggmap(map) + geom_point(data = withVists, aes(x=lon, y=lat, colour = BEN.VISITED),
                        size = 2, alpha = .5) + legend

#Need to set address boundries
#Pull data automatically from website for most up-to-date (?)