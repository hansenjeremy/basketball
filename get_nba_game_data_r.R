library(rvest)
library(lubridate)

year <- "2021" 
month <- "december"
url <- paste0("https://www.basketball-reference.com/leagues/NBA_", year, 
              "_games-", month, ".html")
webpage <- read_html(url)

col_names <- webpage %>% 
  html_nodes("table#schedule > thead > tr > th") %>% 
  html_attr("data-stat")    
col_names <- c("game_id", col_names)

dates <- webpage %>% 
  html_nodes("table#schedule > tbody > tr > th") %>% 
  html_text()
dates <- dates[dates != "Playoffs"]

game_id <- webpage %>% 
  html_nodes("table#schedule > tbody > tr > th") %>%
  html_attr("csk")
game_id <- game_id[!is.na(game_id)]

data <- webpage %>% 
  html_nodes("table#schedule > tbody > tr > td") %>% 
  html_text() %>%
  matrix(ncol = length(col_names) - 2, byrow = TRUE)

month_df_jan <- as.data.frame(cbind(game_id, dates, data), stringsAsFactors = FALSE)
names(month_df_jan) <- col_names





year <- "2021" 
month <- "january"
url <- paste0("https://www.basketball-reference.com/leagues/NBA_", year, 
              "_games-", month, ".html")
webpage <- read_html(url)

col_names <- webpage %>% 
  html_nodes("table#schedule > thead > tr > th") %>% 
  html_attr("data-stat")    
col_names <- c("game_id", col_names)

dates <- webpage %>% 
  html_nodes("table#schedule > tbody > tr > th") %>% 
  html_text()
dates <- dates[dates != "Playoffs"]

game_id <- webpage %>% 
  html_nodes("table#schedule > tbody > tr > th") %>%
  html_attr("csk")
game_id <- game_id[!is.na(game_id)]

data <- webpage %>% 
  html_nodes("table#schedule > tbody > tr > td") %>% 
  html_text() %>%
  matrix(ncol = length(col_names) - 2, byrow = TRUE)

month_df_jan <- as.data.frame(cbind(game_id, dates, data), stringsAsFactors = FALSE)
names(month_df_jan) <- col_names


df <- rbind(month_df, month_df_jan)



# change columns to the correct types
df$visitor_pts <- as.numeric(df$visitor_pts)
df$home_pts    <- as.numeric(df$home_pts)
df$attendance  <- as.numeric(gsub(",", "", df$attendance))
df$date_game   <- mdy(df$date_game)
# add column to indicate if regular season or playoff
playoff_startDate <- ymd("2021-05-22")
df$game_type <- with(df, ifelse(date_game >= playoff_startDate, 
                                "Playoff", "Regular"))
# drop boxscore column
df$box_score_text <- NULL


df$winner <- with(df, ifelse(visitor_pts > home_pts, 
                             visitor_team_name, home_team_name))
df$loser <- with(df, ifelse(visitor_pts < home_pts, 
                            visitor_team_name, home_team_name))


teams <- sort(unique(df$visitor_team_name))
standings <- data.frame(team = teams, stringsAsFactors = FALSE)
standings$conf <- c("East", "East", "East", "East", "East",
                    "East", "West", "West", "East", "West",
                    "West", "East", "West", "West", "West",
                    "East", "East", "West", "West", "East",
                    "West", "East", "East", "West", "West",
                    "West", "West", "East", "West", "East")
standings$div <- c("Southeast", "Atlantic", "Atlantic", "Southeast", "Central",
                   "Central", "Southwest", "Northwest", "Central", "Pacific",
                   "Southwest", "Central", "Pacific", "Pacific", "Southwest",
                   "Southeast", "Central", "Northwest", "Southwest", "Atlantic",
                   "Northwest", "Southeast", "Atlantic", "Pacific", "Northwest",
                   "Pacific", "Southwest", "Atlantic", "Northwest", "Southeast")



standings$win <- 0; standings$loss <- 0
for (i in 1:nrow(standings)) {
  standings$win[i]  <- sum(df$winner == standings$team[i], na.rm = T)
  standings$loss[i] <- sum(df$loser  == standings$team[i], na.rm = T)
}

standings$wl_pct <- with(standings, win / (win + loss))

View(standings)

east_standings <- standings %>% 
  group_by(conf) %>% 
  dplyr::summarise(team,
                   conf,
                   div,
                   win,
                   loss,
                   wl_pct)

east_standings1 <- arrange(filter(east_standings, conf == "East"), desc(wl_pct))
east_standings1$`conf == "East"` <-  NULL

View(east_standings1)

west_standings <- standings %>% 
  group_by(conf) %>% 
  dplyr::summarise(team,
                   conf,
                   div,
                   win,
                   loss,
                   wl_pct)

west_standings1 <- arrange(filter(west_standings, conf == "West"), desc(wl_pct))
west_standings1$`conf == "Wast"` <-  NULL

View(west_standings1)




