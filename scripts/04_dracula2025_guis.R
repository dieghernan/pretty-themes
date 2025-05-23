# Create RStudio (rstheme) variants using tmTheme as base

library(tidyverse)
tminput <- "./dist/tmTheme/Dracula2025.tmTheme"

# Beautify tmTheme
xml2::read_xml(tminput) %>%
  xml2::write_xml(tminput)

source("src/functions.R")

# RStudio Theme ----

# Create a first compilation
outdir <- "./dist/rstheme"
rtheme_out <- tools::file_path_sans_ext(tminput) |>
  basename() |>
  paste0(".rstheme") %>%
  file.path(outdir, .)

aa <- read_tmtheme(tminput)

tmtheme2rstheme(tminput, rtheme_out)


# Apply the new theme
rstudioapi::addTheme(rtheme_out, apply = TRUE, force = TRUE)
