
library(tidyverse)
library(understatr)

# Define teams and colours

teams <- structure(list(team_name = c("Aston Villa", "Everton", "Southampton", 
                                      "Leicester", "West Bromwich Albion", "Crystal Palace", "Chelsea", 
                                      "West Ham", "Tottenham", "Arsenal", "Newcastle United", "Liverpool", 
                                      "Manchester City", "Manchester United", "Burnley", "Brighton", 
                                      "Fulham", "Wolverhampton Wanderers", "Sheffield United", "Leeds"
), 
primary_colour = c("#791c41", "#0162a9", "#e41f26", "#0061a7", 
                   "#20415c", "#0364aa", "#015ea4", "#772e39", "#efefef", "#c62326", 
                   "#2a2a2a", "#e12126", "#66c2ec", "#d81f1c", "#853140", "#0362ac", 
                   "#f5f5f5", "#f6b407", "#f5f5f7", "#FFFFFF"), 
secondary_colour = c("#a5c1e8", 
                     "#0060aa", "#ebefeb", "#0264ad", "#f7f4f3", "#e51e24", "#025fa2", 
                     "#9dc0e8", "#1c3f5f", "#f5f5f5", "#FFFFFF", "#e21f27", "#6abfe4", 
                     "#e1342f", "#97cae9", "#f0f1ec", "#2f2929", "#2e2a29", "#d92223", 
                     "#3e89ae")), 
class = "data.frame", 
row.names = c(NA, -20L))


# Make colour palettes

primary_colours <- split(unique(teams$primary_colour),
                         unique(teams$team_name))


secondary_colours <- split(unique(teams$secondary_colour),
                           unique(teams$team_name))


# Download data

df <- teams %>% 
  mutate(data = map(team_name, ~get_team_players_stats(.x, 2020))) %>% 
  unnest(data, names_repair = "unique") %>% 
  select(-team_name...17) %>% 
  rename(team_name = team_name...1)


saveRDS(df, "output/df.RDS")
saveRDS(primary_colours, "output/primary_colours.RDS")
saveRDS(secondary_colours, "output/secondary_colours.RDS")


df2 <- get_league_teams_stats("EPL", 2020)

df2 <-df2 %>% 
  group_by(team_name) %>% 
  mutate(across(where(is.numeric), 
                .fns = list(cumul = ~cumsum(.)), 
                .names = "{col}_{fn}")) %>% 
  ungroup()

saveRDS(df2, "output/df2.RDS")
