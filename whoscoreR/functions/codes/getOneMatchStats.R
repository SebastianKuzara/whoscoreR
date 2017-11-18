
#  ------------------------------------------------------------------------


getOneMatchStats <- function(matchURL, matchId, league, season) {
  
  remDr$navigate(matchURL)
  
  if( !"matchStats" %in% ls(envir = parent.env(env = environment())) ) {
    matchStats <<- data.frame(
      MeczId = NA,
      Liga = NA,
      Sezon = NA,
      Statystyka = NA,
      Wartosc_gospodarze = NA,
      Wartosc_goscie = NA
    )
  }
  
  if( !"matchDetailedStats" %in% ls(envir = parent.env(env = environment())) ) {
    matchDetailedStats <<- data.frame(
      MeczId = NA,
      Liga = NA,
      Sezon = NA,
      Kategoria = NA,
      Podkategoria = NA,
      Substatystyka = NA,
      Wartosc_gospodarze = NA,
      Wartosc_goscie = NA
    )
  }
  
  matchesIdWithProblems <<- character()
  
  matchMainStatsPanel <- remDr$findElement(using = "id", value = "match-centre-stats")
  matchMainStatsBoxes <- matchMainStatsPanel$findChildElements(using = "class", value = "match-centre-stat")
  
  boxesToReject <- function(b) {
    whichCategories <- c("Possession%", "Pass Success%", "Aerials Won", "Corners")
    if(grepl( pattern = paste0(whichCategories, 
                               collapse = "|"), 
              x =  unlist(b$getElementText()) )) 
    {
      return(FALSE)
    }
    
    else 
      return(TRUE)
  }
  
  matchMainStatsBoxes[ sapply(matchMainStatsBoxes, boxesToReject) ] <- NULL
  
  ifOpenDetails <- TRUE
  
  lapply(matchMainStatsBoxes[1:3], function(statBox) {
    
    if( grepl(pattern = "Aerials Won", x = unlist(statBox$getElementText()) ) )
    {
      category <- "Aerials Won"
      subcategory <- "Details"
      
      moreButton <- statBox$findChildElement(using = "class", value = "toggle-stat-details")
      moreButton$clickElement()
      # Sys.sleep(0.5)
      
      details <- remDr$findElement(using = "xpath", value = "//li[@class='match-centre-stat-details visible']")
      detailBoxes <- details$findChildElements(using = "tag name", value = "li")
      
      # print(details$getElementText())
      sapply(detailBoxes, function(oneBox) {
        statBoxNameElem <- oneBox$findChildElement(using = "css", value = "h4")
        statBoxName <- unlist( statBoxNameElem$getElementText() )
        
        if(statBoxName == "Aerials Won")
          return(NULL)
        
        statBoxHomeValue <- unlist( oneBox$findChildElements(using = "css", value = "span")[[1]]$getElementText() )
        statBoxAwayValue <- unlist( oneBox$findChildElements(using = "css", value = "span")[[3]]$getElementText() )
        
        oneRow <- c(
          matchId,
          league,
          season,
          category,
          subcategory,
          statBoxName,
          statBoxHomeValue,
          statBoxAwayValue
        )
        
        matchDetailedStats <<- rbind(matchDetailedStats, oneRow)
        
      })
      
    }
    else
    {
      statBoxNameElem <- statBox$findChildElement(using = "css", value = "h4")
      statBoxName <- statBoxNameElem$getElementText()
      
      statBoxHomeValue <- statBox$findChildElements(using = "css", value = "span")[[1]]$getElementText()
      statBoxAwayValue <- statBox$findChildElements(using = "css", value = "span")[[3]]$getElementText()
      
      statBoxSummary <- c(
        matchId,
        league,
        season,
        unlist(statBoxName),
        unlist(statBoxHomeValue),
        unlist(statBoxAwayValue)
      )
      
      matchStats <<- rbind(matchStats, statBoxSummary)
    }
    
  })
  print("Read Match Centre Data.")
  ######################
  ## Statystyki dla rzutów rożnych (nie wczytywało gdy obliczało łącznie z pozostałymi)
  lapply(matchMainStatsBoxes[4], function(statBox) {
    
    category <- "Corners"
    subcategory <- "Details"
    moreButton <- statBox$findChildElement(using = "class", value = "toggle-stat-details")
    moreButton$clickElement()
    Sys.sleep(0.5)
    moreButton$clickElement()
    Sys.sleep(0.5)
    
    details <- remDr$findElement(using = "xpath", value = "//li[@class='match-centre-stat-details visible']")
    detailBoxes <- details$findChildElements(using = "tag name", value = "li")
    
    sapply(detailBoxes, function(oneBox) {
      statBoxNameElem <- oneBox$findChildElement(using = "css", value = "h4")
      statBoxName <- unlist( statBoxNameElem$getElementText() )
      
      if(statBoxName == "Corners")
        return(NULL)
      
      statBoxHomeValue <- unlist( oneBox$findChildElements(using = "css", value = "span")[[1]]$getElementText() )
      statBoxAwayValue <- unlist( oneBox$findChildElements(using = "css", value = "span")[[3]]$getElementText() )
      
      oneRow <- c(
        matchId,
        league,
        season,
        category,
        subcategory,
        statBoxName,
        statBoxHomeValue,
        statBoxAwayValue
      )
      
      matchDetailedStats <<- rbind(matchDetailedStats, oneRow)
      moreButton$clickElement() ## close details
      # Sys.sleep(0.5)
    })
  })
  
  
  #####################
  
  
  menuPanel <- remDr$findElement(using = "id", value = "live-match-options")
  chalkboard <- menuPanel$findChildElements(using = "css", value = "li")[[3]]
  chalkboard$clickElement()
  
  statsPanel <- remDr$findElement(using = "id", value = "event-type-filters")
  statBoxes <-statsPanel$findChildElements(using = "class", value = "filterz-option")
  print("Read Chalkboard Data.")
  lapply(statBoxes, function(statBox) {
    statBoxNameElem <- statBox$findChildElement(using = "css", value = "h4")
    statBoxName <- statBoxNameElem$getElementText()
    
    statBoxHomeValue <- statBox$findChildElements(using = "css", value = "span")[[1]]$getElementText()
    statBoxAwayValue <- statBox$findChildElements(using = "css", value = "span")[[3]]$getElementText()
    
    statBoxSummary <- c(
      matchId,
      league,
      season,
      unlist(statBoxName),
      unlist(statBoxHomeValue),
      unlist(statBoxAwayValue)
    )
    matchStats <<- rbind(matchStats, statBoxSummary)
    
    # detail stats ------------------------------------------------------------
    
    Sys.sleep(0.5)
  
    tryCatch({
      statBox$findChildElements(using = "css", value = "span")[[1]]$clickElement()
    }, 
    error = function(e) {
      matchesIdWithProblems <<- unique(c(matchesIdWithProblems, matchId))
      print(paste("Nie udało się wczytać danych dla meczu", matchId, "z kategorii", unlist(statBoxName)))
      },
    message = function(m) {
      cat("")
    })
    
    Sys.sleep(0.5)
  
    
    onePieceDetailedStats <- getOneMatchDetailedStats(matchId = matchId,
                                                      category = unlist(statBoxName),
                                                      league = league,
                                                      season = season)
    matchDetailedStats <<- rbind(matchDetailedStats, onePieceDetailedStats)
    # detail stats - end ------------------------------------------------------
    
  })
  matchStats <<- matchStats[which(!is.na(matchStats$Statystyka)) , ]
  matchDetailedStats <<- matchDetailedStats[which(!is.na(matchDetailedStats$Substatystyka)) , ]
  matchesIdWithProblems <<- matchesIdWithProblems
}







