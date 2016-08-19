library(stringr)
library(treebar)
library(jsonlite)

## make it a more generic hierarchy
##  normally this step is not necessary
json <- str_replace_all(
  readLines("./inst/example/data.json"),
  "(country)|(continent)|(year)|(type)",
  "id"
)

data <- fromJSON(json, simplifyDataFrame=FALSE)

treebar(data)


# use different key for id and value
json <- str_replace_all(
  readLines("./inst/example/data.json"),
  "(country)|(continent)|(year)|(type)",
  "name"
)

json <- str_replace_all(
  json,
  "(value)",
  "size"
)

data <- fromJSON(json, simplifyDataFrame=FALSE)

treebar(data, value="size", id="name")
