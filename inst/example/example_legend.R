#devtools::install_github("timelyportfolio/d3legendR", subdir="pkg")

library(treebar)
library(d3legendR)
library(htmltools)
library(stringr)
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


# now add a legend
#  will eventually make this easier
browsable(
  attachDependencies(
    tagList(
      htmlwidgets::onRender(
        treebar(data, margin=list(right=200), height="100%", width="100%"),
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
      .attr('transform', 'translate(' + (+chart.width()-200) + ',100)');
    
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
