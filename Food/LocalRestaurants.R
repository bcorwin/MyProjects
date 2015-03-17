library(ggmap)

officeLat <- 41.879252
officeLon <- -87.637087
officeAdd <- "200 South Wacker Drive, Chicago, IL"


raw0 <- read.csv("https://data.cityofchicago.org/views/2e2f-tvfz/rows.csv", stringsAsFactors = FALSE)

deg2rad <- function(deg){
  return(deg*pi/180)
} 

getDistance <- function(lat1, lon1, lat2, lon2) {
  #Approximation good for small distances
  x <- (deg2rad(lon2)-deg2rad(lon1)) * cos((deg2rad(lat1)+deg2rad(lat2)/2))
  y <- (deg2rad(lat2)-deg2rad(lat1))
  
  #Radius of earth in miles
  d <- sqrt(x^2 + y^2) * 3959
  
  return(d)
}

raw0$DISTANCE <- getDistance(officeLat, officeLon, raw0$LATITUDE, raw0$LONGITUDE)

raw1 <- raw0[raw0$DISTANCE <= .23 & !is.na(raw0$DISTANCE),]
raw1$DOING.BUSINESS.AS.NAME <- gsub("^\\s+|\\s+$", "", toupper(raw1$DOING.BUSINESS.AS.NAME))
raw1$FULL.ADDRESS <- paste(raw1$ADDRESS, raw1$CITY, raw1$STATE, raw1$ZIP)
raw1$MAP.LINK <- paste0("http://maps.google.com/maps?t=m&saddr=",
                        officeLat, ",", officeLon, "&daddr=",
                        gsub(" ", "+", raw1$FULL.ADDRESS), "&dirflg=w")
raw1 <- raw1[order(raw1$DISTANCE),]

LocationList <- raw1[!duplicated(paste(raw1$ACCOUNT.NUMBER, raw1$LOCATION)),]
save(LocationList, file = "P:\\R Scripts\\Practice R\\LocalRetailFood\\LocationList.rdata")


map <- get_map(location = c(lon = officeLon, lat = officeLat), zoom = 16)
mapPoints <- ggmap(map) +
  geom_point(aes(x = LONGITUDE, y = LATITUDE), data = LocationList, alpha = .5)
mapPoints
