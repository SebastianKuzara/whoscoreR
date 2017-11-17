


readDateButton <- function() {
  dateButton <- remDr$findElement(using = "id", value = "date-config-toggle-button")
  El_dateRange <- dateButton$findElement(using = "class", value = "text")
  Text_dateRange <- unlist(El_dateRange$getElementText())
  
  Text_upperDate <- gsub("^\\d+ \\w+ - ", "", Text_dateRange)
  Text_upperDate <- gsub("^\\d+ - ", "", Text_upperDate)
  
  D_upperDate <- getDateFromDateButton(Text_upperDate)
  
  return(D_upperDate)
}


