

# save(list = c("getWeekMatchTablesFromDate", "readDateButton", "getDateFromDateButton", "getDate", "getOneMatchWeek", "changeMatchWeek"),
#      file = "functions/getWeekMatchTablesFromDate.RData")

######################################



getWeekMatchTablesFromDate <- function(URL, startDate) {
  
  pckgs <- "lubridate"
  for(pckg in pckgs) 
  {
    if(!require(pckg, character.only = TRUE))
    {
      install.packages(pckg)
    }
  }
  require(lubridate)
  
  if(!is.Date(startDate)) {
    tryCatch(expr = {
      startDate <- as.Date(startDate)
    }, 
    error = function(e) stop("Data została podana w nieprawidłowym formacie"))
    
    if(startDate > Sys.Date() || startDate < as.Date("2010-01-01")) {
      stop("Data wykracza poza przedział: [2017-01-01; dzisiaj]")
    }
  }
  
  remDr$navigate(URL)
  
  legues_seasons <- remDr$findElement(using = "xpath", value = "//select[@id='tournaments']")
  league_season <- legues_seasons$findChildElements(using = "xpath", value = "//option[@selected='selected']")
  league <- unlist( league_season[[1]]$getElementText() )
  season <- unlist( league_season[[2]]$getElementText() )
  
  D_upperDate <- readDateButton()
  
  while(D_upperDate >= startDate) {
    
    D_upperDate <- readDateButton()
    print(paste("Upper date:", D_upperDate))
    
    getOneMatchWeek(league = league, season = season)
    changeMatchWeek()
    
    Sys.sleep(1)
  }
  
  if(matches$Wynik[1] == "AAA") {
    matches <<- matches[-1,]
  }
  
  matches$Dzien <<- as.Date(matches$Dzien)
  matches$MeczId <<- paste(
      gsub("-", "_", matches$Dzien ),
      matches$Gospodarz,
      sep = "_"
    )
  
  matches <<- matches
  
  return(TRUE)
}



