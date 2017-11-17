

## Run docker:
## sudo docker run -d -p 4445:4444 selenium/standalone-firefox:2.53.0
## sudo docker ps

library(RSelenium)

## Create the connection
remDr <- remoteDriver(port = 4445L)
## Connect to server
remDr$open()
## checking the connection status
remDr$getStatus()




# get played matches from current premier league season -------------------------------------------

URL <- "https://www.whoscored.com/Regions/252/Tournaments/2/England-Premier-League"
getWeekMatchTablesFromDate(URL = URL, startDate = "2017-08-15") 
## In this case to get all matches from 1st round
## it's necessarily to declare startDate argument as random day of 2nd round (next to the last (the oldest) round you want to stop).
## Download data is done in reverse order, from the newest round to the oldest one.

# save(matches, file = "data/Eng_PL_2017_2018.RData")

## The next run of the function couses addition another rows to existing table 
## Two last rounds from 2016/17 season
URL <- "https://www.whoscored.com/Regions/252/Tournaments/2/Seasons/6335/England-Premier-League"
getWeekMatchTablesFromDate(URL = URL, startDate = "2017-05-15") 
getMatchStats(URL = URL, startDate = "2017-05-15")


# Statistics from matches -------------------------------------------------

URL <- "https://www.whoscored.com/Regions/252/Tournaments/2/England-Premier-League"
getMatchStats(URL = URL, startDate = "2017-10-25")







