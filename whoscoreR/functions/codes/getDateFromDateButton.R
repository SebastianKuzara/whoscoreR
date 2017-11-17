



getDateFromDateButton <- function(textDate) {
  Sys.setlocale("LC_TIME", "C")
  on.exit({Sys.setlocale("LC_TIME", "pl_PL.UTF-8 ")})
  
  res_date <- as.Date(textDate, format = "%d %b %Y")
  
  return(res_date)
}



