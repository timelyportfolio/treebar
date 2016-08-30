## work with treemap and use treecolors

library(treemap)
library(treebar)
library(dplyr)

data_hier <- tidyr:::drop_na(random.hierarchical.data(depth=4)) %>%
  inner_join(treepalette(.,index=names(.)[-ncol(.)])) %>%
  mutate(color = HCL.color) %>%
  select(-starts_with("HCL"))

d3r::d3_nest(data_hier, value_cols=c("x","color")) %>%
  d3r::d3_json() %>%
  treebar(value="x")
