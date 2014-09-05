setwd("C:/Data/Other Stuff/Projects/CTA Card")
options(stringsAsFactors = FALSE)

#Read the historic Ventra numbers
ventraHist <- read.csv('./History/V_History.csv', header = TRUE, stringsAsFactors = FALSE)
ventraHist <- ventraHist[ventraHist$Transaction.Status == "Success",]
ventraHist$Txn.DateTime <- as.POSIXct(strptime(ventraHist$Txn.DateTime, "%m/%d/%Y %H:%M"))
ventraHist$Transaction.Type.Desc <- ifelse(ventraHist$Transaction.Type == "Account-Based Pass Load",
                                           "Sale", ifelse(grepl("Transfer", ventraHist$Fare.Product, ignore.case = TRUE),
                                                          "Transfer", "Use"))
ventraHist$Fare.Product <- gsub(" (Transfer)", "", ventraHist$Fare.Product, fixed = TRUE)
ventraHist$Source = "VHIST"
ventraHist <- ventraHist[, c("Txn.DateTime",
                             "Operator",
                             "Facility",
                             "Fare.Product",
                             "Transaction.Type.Desc",
                             "Source")]


#Read incremental ventra numbers
fileList = list.files("./Incremental", pattern = "*.csv", full.names = TRUE)
incList <- lapply(fileList, function(x) {
    temp <- read.csv(x)
    names(temp) <- c('Txn.DateTime', 'Transaction.Type.Desc', 'Operator', 'Facility', 'Fare.Product', 'Amount')
    temp$Source = x
    temp})
allInc = data.frame('Txn.DateTime' = character(),
                    'Transaction.Type.Desc' = character(),
                    'Operator' = character(),
                    'Facility' = character(),
                    'Fare.Product' = character(),
                    'Amount' = character(),
                    'Source' = character())
for(l in incList) {
    allInc <- rbind(allInc, l)
}
allInc$Txn.DateTime <- as.POSIXct(strptime(allInc$Txn.DateTime, "%m/%d/%Y %H:%M"))
allInc <- allInc[, c("Txn.DateTime",
                     "Operator",
                     "Facility",
                     "Fare.Product",
                     "Transaction.Type.Desc",
                     "Source")]

#Combine and reduce
allTrans0 <- rbind(allInc, ventraHist)
allTrans0 <- allTrans0[order(allTrans0$Txn.DateTime),]
##Remove all but the last appearance
for(row in seq(nrow(allTrans0) - 1)) {
    if(allTrans0$Txn.DateTime[row] == allTrans0$Txn.DateTime[row + 1]) {
        allTrans0$Dup[row] <- TRUE
    } else {
        allTrans0$Dup[row] <- FALSE
    }
}
allTrans <- allTrans0[allTrans0$Dup == FALSE, ]

allTrans$Card.Use <- (allTrans$Transaction.Type.Desc == "Use")
allTrans$Bus.Entry <- (allTrans$Operator == "CTA Bus")
allTrans$Train.Entry <- (allTrans$Operator == "CTA Rail")
for(row in seq(nrow(allTrans))) {
    if(row > 1) {
        allTrans$Transfer2[row] <- (allTrans$Transaction.Type.Desc[row] == "Transfer") &
            (allTrans$Transaction.Type.Desc[row - 1] == "Transfer")
        allTrans$Transfer1[row] <- (allTrans$Transaction.Type.Desc[row] == "Transfer") &
            !allTrans$Transfer2[row]
    } else {
        allTrans$Transfer1[row] <- (allTrans$Transaction.Type.Desc[row] == "Transfer")
        allTrans$Transfer2[row] <- FALSE
    }
    allTrans$Transfer[row] <- (allTrans$Transaction.Type.Desc[row] == "Transfer") |
        allTrans$Transfer2[row]
}
allTrans$Ohare <- (allTrans$Facility == "O'Hare")
##All transfer are now .25. When did this change? When did Ohare change?
allTrans$Estimate.Cost = .25*allTrans$Transfer +
    allTrans$Card.Use*(2.25*allTrans$Train.Entry + 2*allTrans$Bus.Entry + 2.75*allTrans$Ohare)

write.csv(allTrans, "allTransactions.csv")

allTrans$Txn.Hour <- strftime(allTrans$Txn.DateTime, format="%H")
allTrans$Txn.Mon <-  strftime(allTrans$Txn.DateTime, format="%m")
allTrans$Txn.Date <- as.POSIXct(strftime(allTrans$Txn.DateTime, format="%Y-%m-%d"))

txnHours <- aggregate(allTrans$Txn.Hour, list(allTrans$Txn.Hour), FUN = length)
txnDates <- aggregate(allTrans$Txn.Date, list(allTrans$Txn.Date), FUN = length)
allDays <- seq(min(allTrans$Txn.Date), max(allTrans$Txn.Date), by = "day")
barplot(txnHours$x)

#Pull in stations lat and lon


trainTrans <- allTrans[allTrans$Operator == "CTA Rail",]
trainTrans$test <- lapply(trainTrans$Facility, agrep, stationLoc$STATION_DESCRIPTIVE_NAME)
trainTrans$Station.Name <- lapply(trainTrans$Facility, agrep, stationLoc$STATION_NAME, max.distance = 0)

                                 

