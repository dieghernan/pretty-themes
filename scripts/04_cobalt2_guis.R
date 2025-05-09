# Create vscode (json) and RStudio (rstheme) variants using tmTheme as base

library(tidyverse)
tminput <- "./dist/tmTheme/cobalt2.tmTheme"

# Beautify tmTheme
xml2::read_xml(tminput) %>%
  xml2::write_xml(tminput)

source("dev/functions.R")

# RStudio Theme ----

outdir <- "./dist/rstheme"
rtheme_out <- tools::file_path_sans_ext(tminput) |>
  basename() |>
  paste0(".rstheme") %>%
  file.path(outdir, .)


tmtheme2rstheme(tminput, rtheme_out)


# Apply the new theme
rstudioapi::addTheme(rtheme_out, apply = TRUE, force = TRUE)
