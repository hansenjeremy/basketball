library(tidyverse)
library(plyr)
library(dplyr)
library(utils)
library(ggplot2)
library(ggthemes)
library(readxl)
library(plotly)
library(stringr)


#this is to create the data
players <- read_csv("players.csv") %>% 
  select(`_id`, name)
salaries <- read_csv("salaries_1985to2018.csv") %>%
  inner_join(players, by = c("player_id" = "_id"))


salaries1 <- salaries %>% 
  filter(season_start >= 2000) %>%
  select(player_id, name, salary, year = season_start, team)

# total salary by year
yearly <- salaries1 %>% 
  group_by(year) %>% 
  dplyr::summarise(tot_salary = sum(salary) * .000000001) #this is to make the y axis scale better (billions)


#just a rough graph
ggplot(yearly, aes(x = year, y = tot_salary)) +      #doenst work now  dont know why
  geom_point(color = "cornflowerblue") +
  geom_line(color = "cornflowerblue") +
  expand_limits(y = .5) +
  labs(x = "Year", 
       y = "Total League Salary (Billions)", 
       title = "Total Salary of the League by Year") +
  theme_few()



# This is to make another line that will show the inflation rate each year
rates <- c(1.2, 1.8, 2.4, 2.1, 1.3, 0.1, 1.6, 1.5, 2.1, 3.2, 1.6, -0.4, 3.8, 2.8, 3.2, 3.4, 2.7, 2.3, 1.6, 2.8, 3.4)

inflation_df <- data.frame(year = 2000:2017,
                           inflation_amt = yearly$tot_salary * 1.04^(0:17))

inflation_df$rates <- rates[1:18]

inflation$year <- c(2000:2017)

ggplot() +
  geom_point(data = yearly, aes(x = year, y = tot_salary), color = "cornflowerblue") +
  geom_line(data = yearly, aes(x = year, y = tot_salary), color = "cornflowerblue") +
  geom_line(data = inflation, aes(x = year, y = rates), color = "darkorange3") +
  geom_point(data = inflation, aes(x = year, y = rates), color = "darkorange3") +
  expand_limits(y = .5) +
  labs(x = "year", y = "total salary for league (billions)", 
       title = "total salary of all players by year",
       subtitle = "orange line is inflation rate per year") +
  theme_few()




# this is to adjust the salaries to the yearly cpi
CPALTT01USM657N <- read_excel("CPALTT01USM657N.xls")



cpi <- slice(CPALTT01USM657N, c(41:58))

yearly$cpi <- cpi$CPI
yearly$adjusted <- yearly$tot_salary / cpi$CPI *100


#cant decide if this graph makes sense yet or not 
ggplot() +
  geom_point(data = yearly, aes(x = year, y = adjusted), color = "cornflowerblue") +
  geom_line(data = yearly, aes(x = year, y = adjusted), color = "cornflowerblue") +
  expand_limits(y = .5) +
  labs(x = "year", y = "total salary for league (billions)", 
       title = "total salary of all players by year (adjusted to 2000 dollars)") +
  geom_text(aes(x = x, y = y, label = label),
            data = data.frame(x = 2008,
                            y = 53.5,
                            label = "2008"), 
            size = 3) +
  theme_few()



####every teams salary####
team_salaries <- salaries1 %>% 
  group_by(year, team) %>% 
  dplyr::summarise(tot_salary = sum(salary) * .000001)

gg <- ggplot(data = team_salaries, aes(year, tot_salary)) +
  geom_line(aes(group = team), color = "gray70") +
  expand_limits(y = 0) +
  geom_smooth(se = F, color = "salmon") +
  labs(title = "team salaries over time", 
       subtitle = "(each line is a team, pink is the average)",
       x = "year",
       y = "total team salary (millions)") +
  theme_few()

ggplotly(gg)

##########
# team ranking comparison by total salary by year, but doesnt work yet

ranked_team_salaries <- team_salaries %>% 
  dplyr::arrange(year, desc(tot_salary)) %>% 
  dplyr::mutate(rank = row_number()) %>% 
  group_by(team) %>%
  mutate(overall_rank = mean(rank))
  



ggplot(data = ranked_team_salaries, 
       aes(year, fct_reorder(team, x = overall_rank, .desc = T))) +
  geom_tile(aes(fill = rank)) +
  scale_fill_distiller(palette = "RdYlBu", direction = 1) +
  labs(x = "Year", y = NULL, 
       title = "Teams ranked by total salary by year") +
  theme(legend.position = "bottom")




# top paid player in each year
salaries %>% group_by(year) %>%
  top_n(salary, n = 1) %>%
  arrange(year)




# Lorenz curve for 4 years
salaries %>% filter(year %in% c(2000, 2005, 2010, 2015)) %>%
  arrange(year, salary) %>%
  group_by(year) %>%
  dplyr::mutate(cum_salary = cumsum(salary),
         tot_salary = sum(salary),
         cum_n = row_number(),
         tot_n = n()) %>%
  mutate(cum_salary_prop = cum_salary / tot_salary * 100,
         cum_n_prop = cum_n / tot_n * 100) %>%
  ggplot(aes(cum_n_prop, cum_salary_prop, col = factor(year))) +
  geom_line() +
  geom_abline(slope = 1, intercept = 0, linetype = 2, color = "gray50") +
  labs(x = "Bottom x%", y = "% of total salary",
       title = "% of total salary made by bottom x% of players") +
  coord_equal() +
  theme(legend.title = element_blank()) +
  theme_few()











#######
#this selects the last word, which in this case is the mascot
team_salaries$TEAM <- word(team_salaries$team, -1)


#this chart is better because i got rid of the city,
#which means that when teams move, they are combined
gg <- ggplot(data = team_salaries, aes(year, tot_salary)) +
  geom_line(aes(group = TEAM), color = "gray70") +
  expand_limits(y = 0) +
  geom_smooth(se = F, color = "salmon") +         #is there a way to make it so when you touch a line, then that line lights up?
  labs(title = "team salaries over time", 
       # subtitle = "(each line is a team, pink is the average)",
       x = "year",
       y = "total team salary (millions)") +
  theme_few()

ggplotly(gg)
