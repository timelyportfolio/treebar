library(treebar)
library(dplyr)

# create two years of fake data
dates <- seq.Date(as.Date("2014-01-01"),as.Date("2016-12-31"), by="days")
df <- data.frame(
  date = dates,
  profit = runif(length(dates), 100, 10000)
)

# change our date to be hierarchy of years, quarters, months, weeks
#  could easily change weeks to days
df_hier <- df %>%
  mutate(
    year = format(date, "%Y"),
    quarter = paste0("Qtr",ceiling(as.numeric(format(date,"%m")) / 3)),
    month = format(date, "%b"),
    week = format(date, "%U")
  ) %>%
  select(year, quarter, month, week, profit) %>%
  group_by(year, quarter, month, week) %>%
  summarize(profit = sum(profit)) %>%
  ungroup()

df_hier %>%
  d3r::d3_nest(value_col="profit") %>%
  d3r::d3_json() %>%
  treebar(value="profit")
