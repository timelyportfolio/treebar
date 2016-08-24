## work with treemap and use treecolors

library(treemap)
library(treebar)
library(dplyr)

data_hier <- tidyr:::drop_na(random.hierarchical.data(depth=5)) %>%
  inner_join(treepalette(.,index=names(.)[-ncol(.)])) %>%
  mutate(color = HCL.color) %>%
  select(-starts_with("HCL"))

nestd3(data_hier, value_cols=c("x","color")) %>%
  jsonlite::toJSON(dataframe="row",auto_unbox=TRUE) %>%
  treebar()
