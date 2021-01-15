nba <- read.csv("http://datasets.flowingdata.com/ppg2008.csv", sep=",")
ggplot(nba, aes(x= MIN, y= PTS, colour="green", label=Name))+
  geom_point() +geom_text(aes(label=Name),hjust=0, vjust=0)
ggplot(nba, aes(x= MIN, y= PTS, colour="green", label=Name))+
  geom_point() +
  geom_text(aes(label=ifelse(PTS>24,as.character(Name),'')),hjust=0,vjust=0)


library(ggrepel)


nbaplot <- ggplot(nba, aes(x= MIN, y = PTS)) + 
  geom_point(color = "blue", size = 3)

### geom_label_repel
nbaplot + 
  geom_label_repel(aes(label = Name),
                   box.padding   = 0.35, 
                   point.padding = 0.5,
                   segment.color = 'grey50') +
  theme_classic()

