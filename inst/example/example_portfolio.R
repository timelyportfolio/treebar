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