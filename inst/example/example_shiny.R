#devtools::install_github("timelyportfolio/treebar")

library(stringr)
library(treebar)
library(jsonlite)
library(shiny)

## make it a more generic hierarchy
##  normally this step is not necessary
json <- str_replace_all(
  readLines(system.file("example/data.json",package="treebar")),
  "(country)|(continent)|(year)|(type)",
  "id"
)

data <- fromJSON(json, simplifyDataFrame=FALSE)

shinyApp(
  ui = htmlwidgets::onRender(
    treebar(data),
    htmlwidgets::JS(
'
function(el, x){
  var chart = HTMLWidgets.getInstance(el).instance.treebar;
  chart.on("nodeMouseover", function(d,i){
    Shiny.onInputChange("treebar_mouseover", d.data);
  });
}
'    
    )
  ),
  server = function(input, output, session){
    observeEvent(input$treebar_mouseover,{
      print(input$treebar_mouseover)
    })
  }
)
