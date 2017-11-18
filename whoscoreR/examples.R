

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

# save(getWeekMatchTablesFromDate, getOneMatchWeek, changeMatchWeek, readDateButton, getDateFromDateButton, getDate,
#     file = "functions/getWeekMatchTablesFromDate.RData")
load("functions/getWeekMatchTablesFromDate.RData")

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


# Statistics from matches -------------------------------------------------

# save(getMatchStats, getOneMatchStats, getOneMatchDetailedStats, getHrefsToPlayedMatches, changeMatchWeek, readDateButton, getDate, getDateFromDateButton,
#      file = "functions/getMatchStats.RData")
load("functions/getMatchStats.RData")

## In function below both arguments are declared in the same way as previous example.
## URL should lead to site with match results for leagues with detailed statistics available.
## As result we get two data.frame with main statistics and detailed statistics.
## Moreover next run of the function causes binding new rows to previous table.

## Some last matches from current season PL
URL <- "https://www.whoscored.com/Regions/252/Tournaments/2/England-Premier-League"
getMatchStats(URL = URL, startDate = "2017-10-25")

## Some last matches from last season PL
URL <- "https://www.whoscored.com/Regions/252/Tournaments/2/Seasons/6335/England-Premier-League"
getMatchStats(URL = URL, startDate = "2017-05-15")





# Get one match statistics ------------------------------------------------

## When there were some problems with getting data for single match,
## you can try get statistics only for this one match by function below
## You need to declare URL for this match, and matchId, league and season by hand

URL <- "https://www.whoscored.com/Matches/1190320/Live/England-Premier-League-2017-2018-Arsenal-Tottenham"
getOneMatchStats(matchURL = URL, matchId = "2017_11_18_Arsenal", league = "Premier League", season = "2017/2018")








