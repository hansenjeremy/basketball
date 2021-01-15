#some work on some nba data that i downloaded


names(X2020nbatopscorers)

attach(X2020nbatopscorers)
ggplot(X2020nbatopscorers, aes(x = `Minutes Per Game`, y = `Points Per Game`, color = Pos, label = Player)) +
  geom_point() +
  geom_text(aes(label = ifelse(`Points Per Game` > 25.5, as.character(Player), '')), hjust = 0, vjust = 0)

#the ifelse part makes it only label the over 1700 people

library(ggrepel)


nbaplot <- ggplot(X2020nbatopscorers, aes(x= `Minutes Per Game`, y = `Points Per Game`, color = Pos)) + 
   geom_point(size = 2)

### geom_label_repel
nbaplot + 
  geom_label_repel(aes(label = ifelse(`Points Per Game` > 22.75, as.character(Player), '')),
                   box.padding   = 0.35, 
                   point.padding = 0.5,
                   segment.color = 'grey50') +
  theme_classic()

# this makes clean labels with lines




attach(X2020nbatop200)
names(X2020nbatop200)

ggplot(X2020nbatop200, aes(x = STLPG, y = BLKPG, color = Age, label = Player)) +
  geom_point(size = 1.5) +
  geom_text(aes(label = ifelse(BLKPG > 2 & STLPG > 1, as.character(Player), '')), hjust = 0, vjust = -.75) +
  ggtitle("Should Anthony Davis have won DOPY?", subtitle = "a chart by jeremy hansen") +
  labs(x = "Steals per Game", y = "Blocks per Game") +
  theme_minimal()
#note the use of the & here in the ifelse statement




#####################################################################

##this graph is very informative
nbaplot1 <- ggplot(X2020nbatop200, aes(x= STLPG, y = BLKPG)) + 
  geom_point(size = 1.5, color = "cornflowerblue") +
  ggtitle("Only four players averaged over one block and one steal per game", 
          subtitle = "data taken from basketball reference") +
  geom_hline(yintercept = 1, linetype = "dotted", color = "gray50") +
  geom_vline(xintercept = 1, linetype = "dotted", color = "gray50") +
  labs(x = "Steals per Game", y = "Blocks per Game")

nbaplot1 + 
  geom_label_repel(aes(label = ifelse(BLKPG > 1 & STLPG > 1, as.character(Player), '')),
                   box.padding   = 0.35, 
                   point.padding = 0.5,
                   segment.color = 'grey50') +
   theme_minimal()

#####################################################


ggplot(X2020nbatop200, aes(x = `3PA`, y = `2PA`, label = Player)) +
  geom_point(color = "cornflowerblue") +
  geom_text(aes(label = ifelse(`3PA` > 600, as.character(Player), '')), hjust = 0, vjust = 0) +
  theme_minimal()
  
ggplot(X2020nbatop200, aes(x = `FGAPG`, y = `PPG`, label = Player)) +
  geom_point(color = "gray50", size = 1.5) +
  ggtitle("Does more shots mean more points?", subtitle = "a chart by jeremy hansen") +
  geom_label_repel(aes(label = ifelse(`Tm` == "DAL" , as.character(Player), '')), hjust = 0, vjust = 0) +
  theme_minimal()


####################################################
install.packages("devtools")
devtools::install_github("abresler/nbastatR")
library(nbastatR)

assign_nba_players()

players_careers(players = c("LeBron James")) #is the same as:
players_careers(player_ids = c(2544))


##this is a good way to see stuff
lebron_totals <- players_careers(players = c("LeBron James"),
                                 modes = c("Totals"))
View(lebron_totals)

lebron_career <- players_careers(players = c("LeBron James"),
                                 modes = c("Totals", "PerGame", "Per36"))

View(lebron_career) #this is really good because it gives career stats for 
#his per game, totals and his per 36
#####################

#let's try and make some charts with this data
attach(lebron_career[[5]][[11]])
ggplot(lebron_career[[5]][[11]], aes(x = slugSeason, y = pctFG)) +
  geom_point(size = 1.5) +
  geom_label_repel(aes(label = agePlayer)) +
  ggtitle("has lebron gotten more efficent in the playoffs with age?", subtitle = "another jeremy hansen chart") +
  theme_classic()


########################################################################
#lets try another player

malone_totals <- players_careers(player_ids = c(252, 304), 
                                 modes = c("Totals", "PerGame", "Per36"))
View(malone_totals)

cp3_totals <- players_careers(player_ids = 101108,
                               modes = c("Totals", "PerGame", "Per36"))
View(cp3_totals)

# This graphs both players on the same chart
ggplot() +
  geom_point(data = malone_totals[[5]][[9]], aes(x = pts, y = ast), color = "cornflowerblue") +
  geom_point(data = malone_totals[[5]][[1]], aes(x = pts, y = ast), color = "salmon") + 
  geom_point(data = cp3_totals[[5]][[1]], aes(x = pts, y = ast), color = "lightgreen") +
  labs(title = "This one is a little wacky") +
  theme_minimal()


#leaving this for now but the important thing i s

###df_dict_nba_players###


bennet_totals <- players_careers(player_ids = 203461,
                              modes = c("Totals", "PerGame", "Per36"))
View(bennet_totals)




ggplot(cp3_totals[[5]][[3]], aes(x = slugSeason, y = pctFG)) +
  geom_point(size = 1.5) +
  geom_label_repel(aes(label = agePlayer)) +
  ggtitle("has cp3 gotten more efficent in the playoffs with age?", subtitle = "another jeremy hansen chart") +
  theme_classic()






###############NEW PACKAGE######################################

install.packages("NBAloveR")

#franchises
library("NBAloveR")
View(franchise)
#per means win percentage

#matchups
bos11 <- getMatchups(team_code = "bos", season = 2011)
View(bos11)
sas01 <- getMatchups(team_code = "sas", season = 2001)
View(sas01)

#stats leader
getStatsLeader(stats_type = c("PTS", "G", "MP", "FG", "FT", "TRB", "AST","STL", "BLK", "TOV", "PF", "FG3"), period = c("career", "season", "game"))
getStatsLeader(type = "PTS", period = "game")
#doesnt work :(



# player data set
View(players)
#YOS is year of seasons
# https://basketball.realgm.com/nba/stats/2020/Averages/Qualified/points/All/desc/1/Opponent_Top_10_Defense
#this is quite the website


#######MY OWN DATA##############

attach(advanced_stats)
head(advanced_stats)
compareOmean <- {ORtg - mean(ORtg)}
compareDmean <- {DRtg - mean(DRtg)}
mean(ORtg)

compareREG <- lm(compareDmean ~ compareOmean)
compareREG


ggplot(data = advanced_stats, aes(y = compareDmean, x = compareOmean)) +
  geom_point(color = "gray50", size = 1.5) +
  geom_vline(xintercept = 0, linetype = "dotted", color = "dimgrey") +
  geom_hline(yintercept = 0, linetype = "dotted", color = "dimgrey") +
  geom_label_repel(aes(label = ifelse(compareDmean > 0 & compareOmean > 0, Team, ""), color = ifelse(Team %in% c("Dallas", "Denver", "Portland"), "red", '')), show.legend = F) +
  ggtitle("Of the seven teams with above average offensive and defensive ratings last season, only three made the playoffs") +
  xlab("Offensive Rating Points Relative to Average") +
  ylab("Defensive Rating Points Relative to Average") +
  xlim(from = -6, to = 6.2) +
  ylim(from = -6, to = 6) + #i chose 6.2 because dallas = 6.1933
  labs(caption = "A Jeremy Hansen Plot") +
  plot.title = element_text(color = "red") +
  theme_minimal()



ggplot(data = advanced_stats, aes(x = `TS%`, y = compareOmean)) +
  geom_point(color = "cornflowerblue", size = 1.5) +
  geom_abline(intercept = -92.64, slope = 164.16, color = "dimgray", linetype = "dotted") +
  xlab("Team True Shooting Percentage") +
  ylab("Offensive Rating Points Relative to Average") +
  geom_label_repel(aes(label = ifelse(`TS%` > .58, Team, ''))) +
  ggtitle("Does Shooting Percentage Increase Offensive Rating for a Team?") +
  geom_hline(yintercept = 0, color = "dimgray", linetype = "dotted") +
  theme_classic()

tsREG <- lm(data = advanced_stats, compareOmean ~ `TS%`)
tsREG


library(ggplot2)

theme_set(theme_classic())

ggplot(data = advanced_stats, aes(x = `ORB%`, y = `TRB%`)) +
  geom_point(color = "cornflowerblue", size = 1.5)







