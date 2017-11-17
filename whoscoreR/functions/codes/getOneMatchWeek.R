




getOneMatchWeek <- function(league, season) {
  
  resultTable <- remDr$findElement(using = "id", value = "tournament-fixture")
  resultRows <- resultTable$findChildElements(using = "css",value =  "tr")
  
  matchDay <- NA
  matchTime <- NA
  teamHome <- NA
  teamAway <- NA
  matchResult <- NA
  
  if( !"matches" %in% ls(envir = globalenv()) ) {
    matches <<- data.frame(
      MeczId = "AAA",
      Liga = "AAA",
      Sezon = "AAA",
      Dzien = as.character("1900-01-01"),
      Godzina = "AAA",
      Gospodarz = "AAA",
      Gosc = "AAA",
      Wynik = "AAA"
      )
    matches$MeczId <<- as.character(matches$MeczId)
    matches$Liga <<- as.character(matches$Liga)
    matches$Sezon <<- as.character(matches$Sezon)
    matches$Dzien <<- as.Date(matches$Dzien)
    matches$Godzina <<- as.character(matches$Godzina)
    matches$Gospodarz <<- as.character(matches$Gospodarz)
    matches$Gosc <<- as.character(matches$Gosc)
    matches$Wynik <<- as.character(matches$Wynik)
  }
  else
  {
    matches$Dzien <<- as.character(matches$Dzien)
  }
  
  
  sapply(resultRows, function(oneRow) {
    if( oneRow$getElementAttribute("class") == "rowgroupheader" ) {
      matchDay <<- oneRow$getElementText()
    }
    else if( grepl( "^item", oneRow$getElementAttribute("class") )) {
      matchDetails <- oneRow$findChildElements(using = "css", value = "td")
      sapply(matchDetails, function(oneDetail) {
        if( oneDetail$getElementAttribute("class") == "time" ) {
          matchTime <<- oneDetail$getElementText()
        }
        else if( grepl(pattern = "^team home", x = oneDetail$getElementAttribute("class")) ) {
          teamHome <<- oneDetail$getElementText()
        }
        else if( grepl(pattern = "^team away", x = oneDetail$getElementAttribute("class")) ) {
          teamAway <<- oneDetail$getElementText()
        }
        else if( oneDetail$getElementAttribute("class") == "result" ) {
          matchResult <<- oneDetail$getElementText()
        }
      })
      
    }
    
    if(!is.na(teamHome) && unlist(matchResult)!="vs") {
      
      oneMatch <- c(paste(as.character(getDate(matchDay)),
                          gsub("^\\d", "", unlist(teamHome)),
                          sep = "_"),
                    league,
                    season,
                    as.character(getDate(matchDay)),
                    unlist(matchTime),
                    gsub("^\\d", "", unlist(teamHome)),
                    gsub("\\d$", "", unlist(teamAway)),
                    unlist(matchResult))
      
      matches <<- rbind(matches, oneMatch)
      
      teamHome <<- NA
      
    }
    
  })
  
  return(matches)
  
}





