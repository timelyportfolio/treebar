library(treebar)
library(dplyr)

# create two years of fake data
dates <- seq.Date(as.Date("2014-01-01"),as.Date("2016-12-31"), by="days")
df <- data.frame(
  date = dates,
  profit = runif(length(dates), 100, 10000)
)

# change our date to be hierarchy of years, quarters, and months
df_hier <- df %>%
  mutate(
    year = format(date, "%Y"),
    quarter = paste0("Qtr",ceiling(as.numeric(format(date,"%m")) / 3)),
    month = format(date, "%b"),
    day = format(date, "%d")
  ) %>%
  select(year, quarter, month, day, profit)

df_hier %>%
  nestd3(value_col="profit") %>%
  jsonlite::toJSON(auto_unbox=TRUE, dataframe="row") %>%
  treebar(value="profit")
