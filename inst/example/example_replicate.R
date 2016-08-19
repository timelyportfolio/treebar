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
