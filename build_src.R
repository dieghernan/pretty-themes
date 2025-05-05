styler::style_dir("scripts")
source("scripts/01_run_all.R")
lintr::lint_dir("scripts")

library(jsonlite)

pk <- read_json("package.json")

tm <- pk$contributes$themes
rnk <- tm |> lapply(function(x){
  x[["label"]]
}) |> unlist() |> order()

pk2 <- pk

pk2$contributes$themes <- tm[rnk]

write_json(pk2, "package.json", pretty = TRUE, auto_unbox = TRUE)
