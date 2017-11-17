changeMatchWeek <- function() {
  
  previousButton <- remDr$findElement(using = "css", 
                                      value = "a.previous.button")
  
  previousButton$clickElement()
  
}

