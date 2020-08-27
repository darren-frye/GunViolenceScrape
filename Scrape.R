library(RSelenium)

`%notin%` <- Negate(`%in%`)

interestVar <- "incidents"

remDr <- remoteDriver(
  port = 4445L,
  browserName = "firefox"
)

remDr$open()

for(year in 2018:2020){
  for (month in 0:12){
    for(day in 1:31){
      remDr$navigate("https://www.gunviolencearchive.org/query")
      
      Sys.sleep(1)
      
      newRule <- remDr$findElement(using = "css", "[class = 'filter-dropdown-trigger']")
      newRule$clickElement()
      
      selDate <- remDr$findElement(using = "css", "[data-value='IncidentDate']")
      selDate$clickElement()
      
      Sys.sleep(1)
      
      queryID <- remDr$findElement(using = 'css', "[class='filter-row row relative filter form-wrapper']")
      ID <- queryID$getElementAttribute("id")[[1]]
      
      fromDate <- remDr$findElement(using = "css", paste("[id='", ID, "-outer-filter-filter-field-date-from']", sep = ""))
      fromDate$clickElement()
      
      fromCalMonth <- remDr$findElement(using = "css", "[class='monthselect']")
      fromCalMonth$clickElement()
      
      fromMonth <- remDr$findElement(using = "css", paste("[value='", month, "']", sep = ""))
      fromMonth$clickElement()
      
      fromCalYear <- remDr$findElement(using = "css", "[class='yearselect']")
      fromCalYear$clickElement()
      
      fromYear <- remDr$findElement(using = "css", paste("[value='",year, "']", sep = ""))
      fromYear$clickElement()
      
      fromDay <- remDr$findElements(using = "css", "[class='available']")
      availableDays <- unlist(lapply(fromDay, function(x) {x$getElementText()}))
      
      if(as.character(day) %in% availableDays){
        fromDaySel <- fromDay[[which(availableDays == as.character(day))]]
        fromDaySel$clickElement()
        
        Sys.sleep(1)
        
        toDate <- remDr$findElement(using = "css", paste("[id='", ID, "-outer-filter-filter-field-date-to']", sep = ""))
        toDate$clickElement()
        
        toCalMonth <- remDr$findElements(using = "css", "[class='monthselect']")
        toCalMonthSel <- unlist(lapply(toCalMonth, function(x) {x$getElementText()}))
        toCalMonthSel <- toCalMonth[[which(toCalMonthSel != "")]]
        toCalMonthSel$clickElement()
        
        toMonth <- remDr$findElements(using = "css", paste("[value='", month, "']", sep = ""))
        toMonthSel <- unlist(lapply(toMonth, function(x) {x$getElementText()}))
        toMonthSel <- toMonth[[which(toMonthSel != "")]]
        toMonthSel$clickElement()
        
        toCalYear <- remDr$findElements(using = "css", "[class='yearselect']")
        toCalYearSel <- unlist(lapply(toCalYear, function(x) {x$getElementText()}))
        toCalYearSel <- toCalYear[[which(toCalYearSel != "")]]
        toCalYearSel$clickElement()
        
        toYear <- remDr$findElements(using = "css", paste("[value='",year, "']", sep = ""))
        toYearSel <- unlist(lapply(toYear, function(x) {x$getElementText()}))
        toYearSel <- toYear[[which(toYearSel != "")]]
        toYearSel$clickElement()
        
        toDay <- remDr$findElements(using = "css", "[class='available']")
        availableDays <- unlist(lapply(toDay, function(x) {x$getElementText()}))
        toDaySel <- toDay[[which(availableDays == as.character(day))]]
        toDaySel$clickElement()
        
        resAs <- remDr$findElement(using = "css", paste("[value='", interestVar, "']", sep = ""))
        resAs$clickElement()
        
        submitButton <- remDr$findElement(using = "css", "[class='button icon-arrow-right form-submit']")
        submitButton$clickElement()
        
        Sys.sleep(1)
        
        pageButtons <- remDr$findElements(using = "css", "[class='button']")
        buttonText <- unlist(lapply(pageButtons, function(x) {x$getElementText()}))
        exportButton <- pageButtons[[which(buttonText == "Export as CSV")]]
        exportButton$clickElement()
        
        Sys.sleep(5)
        
        downloadButton <- remDr$findElement(using = "css", "[class='button big']")
        
        csvLink <- downloadButton$getElementAttribute("href")[[1]]
        
        if(!exists("gunViolenceData")){
          gunViolenceData <- read.csv(csvLink)
        } else {
          newSet <- read.csv(csvLink)
          gunViolenceData <- rbind(gunViolenceData, newSet)
        }
        print(paste(month+1, "/", day, "/", year, " completed", sep = ""))
      } else {
        print(paste(month+1, "/", day, "/", year, " unavailable", sep = ""))
      }
    }
  }
}

# remDr$screenshot(display = TRUE)
