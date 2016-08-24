### Work In Progress function
###  to create nested d3 hierarchy

library(dplyr)
library(tidyr)

change_to_id <- function(x){
  dplyr::mutate(x, children = lapply(
    children,
    function(y) dplyr::rename_(y,id=colnames(y)[1])
  ))
}

nestd3 <- function(
  data=NULL,
  value_cols=character(),
  root = "root"
) {
  stopifnot(!is.null(data), inherits(data, "data.frame"))
  nonnest_cols <- dplyr::setdiff(colnames(data),value_cols)
  
  data_nested <- tidyr::nest_(
    data=data,
    nest_cols=c(nonnest_cols[length(nonnest_cols)], value_cols),
    key_col="children"
  ) %>% change_to_id("name")
  
  for(x in rev(colnames(data_nested)[-ncol(data_nested)])){
    data_nested <- tidyr::nest_(
      data_nested,
      nest_cols = c(x,"children"),
      key_col = "children"
    ) %>% change_to_id()
  }
  data_nested$id = root
  return(data_nested)
}

portfolio %>%
  nestd3(value_cols="value", root="portfolio")

portfolio %>%
  nestd3(value_cols="value", root="portfolio") %>%
  jsonlite::toJSON(dataframe="row",auto_unbox=TRUE) %>%
  treebar()


titanic_df <- data.frame(Titanic)
tit_tb <- titanic_df %>%
  select(Class,Age,Survived,Sex,Freq) %>%
  nestd3(value_cols="Freq", root="titanic") %>%
  jsonlite::toJSON(dataframe="row",auto_unbox=TRUE) %>%
  treebar(value = "Freq")
tit_tb


# now add a legend
#  will eventually make this easier

library(d3legendR)
library(htmltools)

tit_tb$x$height <- 400
tit_tb$x$width <- 600
tit_tb$x$options$margin <- list("right"=150)

browsable(
  attachDependencies(
    tagList(
      htmlwidgets::onRender(
        tit_tb,
        htmlwidgets::JS(
"
function(el,x){
// get our treebar chart
var chart = HTMLWidgets.getInstance(el).instance.treebar;
chart.on('updateComplete.legend', drawLegend);

function drawLegend(chart){
var svg = chart.getSvg();

var legend_el = svg.selectAll('.legendOrdinal').data([0])

legend_el = legend_el.enter().append('g')
.attr('class', 'legendOrdinal')
.merge(legend_el)
.attr('transform', 'translate(' + (+chart.width()-150) + ',100)');

var legendOrdinal = d3.legendColor()
.shapeWidth(30)
.orient('vertical')
.scale(chart.options().color);

svg.select('.legendOrdinal')
.call(legendOrdinal);
};
}
"        
        )
      )
    ),
    list(
      htmldependency_d3legend_v4()
    )
  )
)