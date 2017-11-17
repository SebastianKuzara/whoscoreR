



getOneMatchDetailedStats <- function(matchId, category, league, season) {
  
  statTables <- remDr$findElements("class", "filterz-filter-sub-group")
  ifEmptyElement <- sapply(statTables, function(statTable) {
    if( unlist( statTable$getElementText() ) == "") 
      return(TRUE)
    else
      return(FALSE)
  })
  statTables[ifEmptyElement] <- NULL 
  
  if(length(statTables)==0)
  {
    return(NULL)
  }
  
  
  statisticsTable <- data.frame(
    MeczId = NA,
    Liga = NA,
    Sezon = NA,
    Kategoria = NA,
    Podkategoria = NA,
    Substatystyka = NA,
    Wartosc_gospodarze = NA,
    Wartosc_goscie = NA
    )
  
  sapply(statTables, function(statTable) {
    tableText <- unlist( statTable$getElementText() )
    tableText_splitted <- unlist( strsplit( tableText, "\n"  ) )
    tableText_splitted <- tableText_splitted[tableText_splitted!="All"]
    subcategory <- tableText_splitted[1]
    
    for(values in tableText_splitted[2:length(tableText_splitted)])
    {
      HomeValue <- as.numeric( gsub("\\D+\\d+$", "", values) )
      AwayValue <- as.numeric( gsub("^\\d+\\D+", "", values) )
      Substatistic <- gsub("^\\d+|\\d+$", "", values)
      
      oneRow <- c(matchId, 
                  league, 
                  season, 
                  category, 
                  subcategory, 
                  Substatistic, 
                  HomeValue, 
                  AwayValue)
      statisticsTable <- rbind(statisticsTable, oneRow)
    }
    
    if( is.na(statisticsTable[1, 2]) && is.na(statisticsTable[1, 3]) )
    {
      statisticsTable <- statisticsTable[-1 , ]
    }
    
    statisticsTable <<- statisticsTable
  })
  
  statisticsTable$Substatystyka <- gsub("-yard box", "6-yard box", statisticsTable$Substatystyka)
  
  return(statisticsTable)
}









