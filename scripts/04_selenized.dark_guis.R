# Create vscode (json) and RStudio (rstheme) variants using tmTheme as base

library(tidyverse)
tminput <- "./dist/tmTheme/Selenized Dark.tmTheme"

# Beautify tmTheme
xml2::read_xml(tminput) %>%
  xml2::write_xml(tminput)

source("dev/functions.R")

# VScode -----
output <- basename(tminput) %>%
  str_replace_all(".tmTheme", "-color-theme.json") %>%
  str_replace_all(" ", "-") %>%
  file.path("dist", "vscode", .) |>
  tolower()

output

tmtheme2vscode(tminput, output)

# Prettify output
read_json(output) |>
  write_json(path = output, auto_unbox = TRUE, pretty = TRUE)

# And get type of theme here
them_type <- read_json(output)$type

message(basename(tminput), " is ", them_type)

# RStudio Theme ----

# Create a first compilation
outdir <- "./dist/rstheme"
rtheme_out <- tools::file_path_sans_ext(tminput) |>
  basename() |>
  paste0(".rstheme") %>%
  file.path(outdir, .)


tmtheme2rstheme(tminput, rtheme_out)


# Apply the new theme
rstudioapi::addTheme(rtheme_out, apply = TRUE, force = TRUE)
