
mavs_threes <- rbind(luka, maxi)
View(mavs_threes)
mavs_threes$Made <- mavs_threes$MADE == "Made Shot"

q1 <- filter(mavs_threes, PERIOD == 1)

View(q1)

mavs_threes[c(mavs_threes$Made)]


mavs_threes %>%
  group_by(PERIOD) %>%
  dplyr::summarise(sum_made = sum(Made),
            prop_made = mean(Made),
            sum_missed = sum(Made == FALSE))




