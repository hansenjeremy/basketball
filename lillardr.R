######NBA SHOT CHARTS########

install.packages("httr")
library(tidyverse)
library(httr)
library(ggplot2)

headers = c(
  `Connection` = 'keep-alive',
  `Accept` = 'application/json, text/plain, */*',
  `x-nba-stats-token` = 'true',
  `X-NewRelic-ID` = 'VQECWF5UChAHUlNTBwgBVw==',
  `User-Agent` = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.87 Safari/537.36',
  `x-nba-stats-origin` = 'stats',
  `Sec-Fetch-Site` = 'same-origin',
  `Sec-Fetch-Mode` = 'cors',
  `Referer` = 'https://stats.nba.com/players/leaguedashplayerbiostats/',
  `Accept-Encoding` = 'gzip, deflate, br',
  `Accept-Language` = 'en-US,en;q=0.9'
)

#i guess if i change the player id which here is 203081 then the player changes
url <- "https://stats.nba.com/stats/shotchartdetail?AheadBehind=&CFID=33&CFPARAMS=2019-20&ClutchTime=&Conference=&ContextFilter=&ContextMeasure=FGA&DateFrom=&DateTo=&Division=&EndPeriod=10&EndRange=28800&GROUP_ID=&GameEventID=&GameID=&GameSegment=&GroupID=&GroupMode=&GroupQuantity=5&LastNGames=0&LeagueID=00&Location=&Month=0&OnOff=&OpponentTeamID=0&Outcome=&PORound=0&Period=0&PlayerID=203081&PlayerID1=&PlayerID2=&PlayerID3=&PlayerID4=&PlayerID5=&PlayerPosition=&PointDiff=&Position=&RangeType=0&RookieYear=&Season=2019-20&SeasonSegment=&SeasonType=Regular+Season&ShotClockRange=&StartPeriod=1&StartRange=0&StarterBench=&TeamID=0&VsConference=&VsDivision=&VsPlayerID1=&VsPlayerID2=&VsPlayerID3=&VsPlayerID4=&VsPlayerID5=&VsTeamID="

res <- httr::GET(url = url, httr::add_headers(.headers=headers))
json_resp <- jsonlite::fromJSON(content(res, "text"))
df <- data.frame(json_resp$resultSets$rowSet[1])
colnames(df) <- json_resp[["resultSets"]][["headers"]][[1]]

View(df)






df$LOC_X <- as.numeric(as.character(df$LOC_X))
df$LOC_Y <- as.numeric(as.character(df$LOC_Y))

ggplot(data = df, aes(x = `LOC_X`, y = `LOC_Y`)) +
  geom_point() +
  coord_equal() +
  theme_void()

court_img.url <- "https://www.nba.com/stats/media/img/halfcourt.png"

library(grid)
library(jpeg)
court <- rasterGrob(readJPEG(getURLContent(courtImg.URL)),
                    width=unit(1,"npc"), height=unit(1,"npc"))











