library(treebar)
library(data.tree)

portfolio <- data.frame(
  year = rep(2014:2016, each=8),
  asset = c(rep("equity",5),rep("fixed",3)),
  subasset = c("infotech","infotech","energy","energy","telecom","invgrade","invgrade","highyield"),
  ticker = rep(c("msft","apple","xom","cvx","t","pttrx","vficx","vwehx"),3),
  value = runif(24,50000,250000),
  stringsAsFactors = FALSE
)

portfolio$pathString <- paste(
  "portfolio", 
  portfolio$year, 
  portfolio$asset,
  portfolio$subasset,
  portfolio$ticker,
  sep = "/"
)

portfolio_tree <- as.Node(portfolio)

treebar(
  ToListExplicit(portfolio_tree, unname=TRUE),
  id = "name"
)

# also allows different tiling options
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
            ToListExplicit(portfolio_tree, unname=TRUE),
            id = "name",
            tile = tile, 
            height = 250,
            width = 320
          )
        )
      }
    )   
  )
)


# play with treemap treepalette
library(treemap)
library(treebar)
library(dplyr)

portfolio %>%
  mutate(year = as.character(year)) %>%
  inner_join(treepalette(.,index=c("asset","subasset","ticker"))) %>%
  mutate(color = HCL.color) %>%
  select(-starts_with("HCL")) %>%
  d3r::d3_nest(value_cols=c("value","color")) %>%
  treebar()
