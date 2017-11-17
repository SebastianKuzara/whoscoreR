

## Przkeształca informacje o date meczu na format datowy R

getDate <- function(txt) {
  
  Sys.setlocale("LC_TIME", "C")
  on.exit({Sys.setlocale("LC_TIME", "pl_PL.UTF-8 ")})
  
  weekdays <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
  
  date_raw <- gsub(pattern = paste0("(", paste(weekdays, collapse = "|"), "), "), 
                   replacement = "" ,
                   x =  txt)
  
  date_tidy <- as.Date(x = date_raw, 
                       format = "%b %d %Y")
  
  return(date_tidy)
  
}