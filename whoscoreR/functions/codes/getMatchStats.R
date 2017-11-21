



getMatchStats <- function(URL, startDate, skip = 0) {
  
  require(lubridate)
  
  if(!is.Date(startDate)) {
    tryCatch(expr = {
      startDate <- as.Date(startDate)
    }, 
    error = function(e) stop("Nieprawidłowy format daty"))
    
    if(startDate > Sys.Date() || startDate < as.Date("2010-01-01")) {
      stop(paste0("Data wykracza poza przedział: [2017-01-01; ", Sys.Date(), "]"))
    }
  }
  
  remDr$navigate(URL)
  
  legues_seasons <- remDr$findElement(using = "xpath", value = "//select[@id='tournaments']")
  league_season <- legues_seasons$findChildElements(using = "xpath", value = "//option[@selected='selected']")
  league <- unlist( league_season[[1]]$getElementText() )
  season <- unlist( league_season[[2]]$getElementText() )
  
  D_upperDate <- readDateButton()
  
  nrOfTablesToSkip <- skip
  
  while(D_upperDate >= startDate)
  {
    remDr$navigate(URL)
    for(i in seq_len(nrOfTablesToSkip))
    {
      changeMatchWeek()
      # Sys.sleep(1)
    }
    
    D_upperDate <- readDateButton()
    print(paste("Upper date:", D_upperDate))
    
    getHrefsToPlayedMatches()
    ## result: list of 2 elements vectors named 'hrefs'
    
    if(length(hrefs) > 0) 
    {
      for(nrHref in 1:length(hrefs))
      {
        print(paste0(
          as.character(format(Sys.time(), format = "%H:%M:%S")), 
          ": Read match id ",
          unname(hrefs[[ nrHref ]]["matchId"])
        ))
        
        getOneMatchStats( matchURL = hrefs[[ nrHref ]]["href"],
                          matchId = hrefs[[ nrHref ]]["matchId"],
                          league = league,
                          season = season)
      }
    }
    
    remDr$navigate(URL)
    
    nrOfTablesToSkip <- nrOfTablesToSkip + 1
  }
  
  rm(list = c("tidyMatchDay", "teamHome", "hrefs"), envir = globalenv())
  
  return(TRUE)
}


