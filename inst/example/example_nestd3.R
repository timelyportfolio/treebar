# examples of building nested d3 with d3r
library(treebar)
library(dplyr)
library(d3r)

# simulate a portfolio
portfolio <- data.frame(
  year = rep(2014:2016, each=8),
  asset = c(rep("equity",5),rep("fixed",3)),
  subasset = c("infotech","infotech","energy","energy","telecom","invgrade","invgrade","highyield"),
  ticker = rep(c("msft","apple","xom","cvx","t","pttrx","vficx","vwehx"),3),
  value = runif(24,50000,250000),
  stringsAsFactors = FALSE
)

portfolio %>%
  d3_nest(value_cols="value", root="portfolio")

portfolio %>%
  d3_nest(value_cols="value", root="portfolio") %>%
  treebar()


titanic_df <- data.frame(Titanic)
tit_tb <- titanic_df %>%
  select(Class,Age,Survived,Sex,Freq) %>%
  d3_nest(value_cols="Freq", root="titanic")%>%
  treebar(value = "Freq")
tit_tb


# now add a legend
#  will eventually make this easier

library(d3legendR)
library(htmltools)

tit_tb$x$height <- "100%"
tit_tb$x$width <- "100%"
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
