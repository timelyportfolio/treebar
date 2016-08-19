#devtools::install_github("timelyportfolio/treebar")

library(stringr)
library(treebar)
library(jsonlite)

## make it a more generic hierarchy
##  normally this step is not necessary
json <- str_replace_all(
  readLines(system.file("example/data.json",package="treebar")),
  "(country)|(continent)|(year)|(type)",
  "id"
)

data <- fromJSON(json, simplifyDataFrame=FALSE)

treebar(data)


# also allows different treemap tiling options
library(htmltools)

browsable(
  tagList(
    lapply(
      c("Squarify", "Binary", "SliceDice", "Slice", "Dice"),
      function(tile){
        tags$div(
          style = "float:left; display:inline;",
          tags$h3(tile),
          treebar(
            data,
            tile = tile, 
            height = 250,
            width = 400
          )
        )
      }
    )   
  )
)


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
