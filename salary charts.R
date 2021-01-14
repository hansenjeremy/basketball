library(tidyverse)
library(dplyr)
library(utils)
library(ggplot2)


#this is to create the data
players <- read_csv("players.csv") %>% select(`_id`, name)
salaries <- read_csv("salaries_1985to2018.csv") %>%
  inner_join(players, by = c("player_id" = "_id"))


salaries <- salaries %>% filter(season_start >= 2000) %>%
  select(player_id, name, salary, year = season_start, team)

# total salary by year
salaries %>% group_by(year) %>%
  summarize(tot_salary = sum(salary)) %>%
  ggplot(aes(year, tot_salary)) +
  geom_point() + geom_line() +
  expand_limits(y = 0) +
  labs(x = "Year", y = "Total salary",
       title = "Total salary of all players by year")




# compare with constant inflation of 4 percent
tot_2000 <- salaries %>% filter(year == 2000) %>%
  summarize(tot_salary = sum(salary)) %>% pull()
inflation_df <- data.frame(year = 2000:2017,
                           inflation_amt = tot_2000 * 1.04^(0:17))

salaries %>% group_by(year) %>%
  summarize(tot_salary = sum(salary)) %>%
  ggplot(aes(year, tot_salary)) +
  geom_point() + geom_line() +
  geom_line(aes(year, inflation_amt), data = inflation_df, 
            col = "red", linetype = 2) +
  annotate("text", x = 2008, y = 2.6e9, 
           label = c("4% increase/yr"), color="red") +
  expand_limits(y = 0) +
  labs(x = "Year", y = "Total salary",
       title = "Total salary of all players by year")


# total salary by year by team
salaries %>% group_by(year, team) %>%
  summarize(tot_salary = sum(salary)) %>%
  ggplot(aes(year, tot_salary)) +
  geom_line(aes(group = team), size = 0.1) +
  geom_smooth(size = 2, se = FALSE) +
  expand_limits(y = 0) +
  labs(x = "Year", y = "Total salary",
       title = "# of players by year",
       subtitle = "One line per team") +
  theme(legend.position = "none")

# team ranking comparison by total salary by year
salaries %>% group_by(year, team) %>%
  summarize(tot_salary = sum(salary)) %>%
  arrange(year, desc(tot_salary)) %>%
  mutate(rank = row_number()) %>%
  group_by(team) %>%
  mutate(overall_rank = mean(rank)) %>%
  ggplot(aes(year, fct_reorder(team, overall_rank, .desc = TRUE))) +
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
  mutate(cum_salary = cumsum(salary),
         tot_salary = sum(salary),
         cum_n = row_number(),
         tot_n = n()) %>%
  mutate(cum_salary_prop = cum_salary / tot_salary * 100,
         cum_n_prop = cum_n / tot_n * 100) %>%
  ggplot(aes(cum_n_prop, cum_salary_prop, col = factor(year))) +
  geom_line() +
  geom_abline(slope = 1, intercept = 0, linetype = 2) +
  labs(x = "Bottom x%", y = "% of total salary",
       title = "% of total salary made by bottom x% of players") +
  coord_equal() +
  theme(legend.title = element_blank())








