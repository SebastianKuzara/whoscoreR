




getHrefsToPlayedMatches <- function() {
  
  tableOfMatches <- remDr$findElement(using = "id", value = "tournament-fixture")
  rowsInTablesOfMatches <- tableOfMatches$findChildElements("css", "tr")
  
  hrefs <- list()
  i <- 1
  
  sapply(rowsInTablesOfMatches, function(oneRow) {
    if( oneRow$getElementAttribute("class") == "rowgroupheader" ) {
      matchDay <- oneRow$getElementText()
      tidyMatchDay <<- getDate(matchDay)
    }
    else if( grepl( "^item", oneRow$getElementAttribute("class") )) {
      matchDetails <- oneRow$findChildElements(using = "css", value = "td")
      
      sapply(matchDetails, function(oneDetail) {
        
        if( grepl(pattern = "^team home", x = oneDetail$getElementAttribute("class")) ) {
          teamHome <- oneDetail$getElementText()
          teamHome <<- gsub("^\\d+", "", teamHome)
        }
        
        if( oneDetail$getElementAttribute("class") == "result" ) 
        {
          if(oneDetail$getElementText() != "vs") 
          {
            a <- oneDetail$findChildElement(using = "css", value = "a")
            matchHref <- c(unlist(a$getElementAttribute("href")), 
                           paste(gsub("-", "_", as.character(tidyMatchDay)),
                                 teamHome, 
                                 sep = "_"))
            
            names(matchHref) <- c("href", "matchId")
            hrefs[[i]] <<- matchHref
            i <<- i + 1
          }
          
        }
        return(NULL)
      })
    }
    hrefs <<- hrefs
  })
  hrefs <<- hrefs
}
    

    
    
    
    
    
    
    