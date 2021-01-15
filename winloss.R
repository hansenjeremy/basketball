#winloss

library(ggplot2)

ggplot(data = winloss, aes(x = DELTA_LOSS, y = DELTA_WIN, label = Player)) +
  geom_point(color = "cornflowerblue", size = 1.5) +
  geom_label_repel(aes(label = ifelse(DELTA_LOSS > 0, as.character(Player), ''))) +
  geom_abline(slope = -.8461, intercept = -.5478, color = "gray50", linetype = "dotted")
  
winlosslm <- lm(DELTA_LOSS ~ DELTA_WIN, data = winloss)
winlosslm
#took the data from the linear model in order to make the abline



