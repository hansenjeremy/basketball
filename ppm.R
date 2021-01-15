###average plus minus###


b <- boxscore %>%
  group_by(PLAYER) %>%
  dplyr::summarise(avg_plusminus = mean(`+/-`),
                   total_mins = sum(MIN),
                   avg_mins = mean(MIN),
                   ppm = mean(PTS) / mean(MIN),
                   fgpm = mean(FGA) / mean(MIN),
                   fg_percent = sum(FGM) / sum(FGA),
                   `3p_percent` = sum(`3PM`) / sum(`3PA`))
View(b)

all_teams_box <- rbind(boxscore, boxscore_all)

b <- all_teams_box %>%
  group_by(PLAYER) %>%
  dplyr::summarise(avg_plusminus = mean(`+/-`),
                   total_mins = sum(MIN),
                   avg_mins = mean(MIN),
                   ppm = mean(PTS) / mean(MIN),
                   fgpm = mean(FGA) / mean(MIN),
                   fg_percent = sum(FGM) / sum(FGA),
                   `3p_percent` = sum(`3PM`) / sum(`3PA`),
                   `3pa` = sum(`3PA`),
                   fga = sum(FGA))




bb <- filter(b, total_mins > 20)



ggplot(bb, aes(x = ppm, y = fgpm)) +
  geom_point(color = "cornflowerblue") +
  geom_abline(slope = .5943, intercept = .0921, color = "gray50") +
  geom_label_repel(aes(label = ifelse(fgpm > .6, as.character(PLAYER), '')),
                   box.padding = .35,
                   point.padding = .5,
                   segment.color = "gray50") +
  theme_tufte()




lm <- lm(data = bb, fgpm ~ ppm + avg_plusminus + fg_percent + `3p_percent`)  
summary(lm)  
  
  
  

  
  
  












