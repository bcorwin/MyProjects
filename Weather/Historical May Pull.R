library(jsonlite)

setwd("C:\\Users\\matr06619\\Documents\\Other\\MyProjects\\Weather")

key <- readLines("Key.key", warn = F)

dates <- expand.grid(Year = seq(1950,2015), Month = "05", Day = sprintf("%02d", seq(1,31)))
dates <- paste0(dates$Year, dates$Month, dates$Day)

for(date in dates) {
    print(date)
    url <- paste0("http://api.wunderground.com/api/", key, "/history_", date, "/q/IL/Chicago.json")
    data <- fromJSON(url)
    utcdate <- data$history$observations$utcdate$pretty
    tempi <- data$history$observations$tempi
    add <- data.frame(Date = as.Date(data$history$utcdate$pretty, "%B %d, %Y"),
                      utcdatetime = as.POSIXct(utcdate, "GMT", "%I:%M %p GMT on %B %d, %Y"),
                      tempi = tempi,
                      stringsAsFactors = FALSE)
    if(exists("weather")) {
        weather <- rbind(weather, add)
    } else {
        weather <- add
    }
    rm(add, data, utcdate, tempi)
    Sys.sleep(6)
}