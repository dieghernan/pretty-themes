library(tidyverse)
library(jsonlite)

js <- list.files("dist/vscode", pattern = ".json", full.names = TRUE)
f <- js[1]

for (f in js) {
  read_json(f) |>
    write_json(path = f, auto_unbox = TRUE, pretty = TRUE)
}
