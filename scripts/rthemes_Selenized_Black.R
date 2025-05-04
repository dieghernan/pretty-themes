library(tidyverse)

tm_path <- "./dist/tmTheme/Selenized Black.tmTheme"
outdir <- "./dist/rstheme"
rtheme <- tools::file_path_sans_ext(tm_path) |>
  basename() |>
  paste0(".rstheme") %>%
  file.path(outdir, .)

xml2::read_xml(tm_path) %>%
  xml2::write_xml(tm_path)

rstudioapi::convertTheme(tm_path,
  add = FALSE,
  outputLocation = outdir,
  force = TRUE
)
source("dev/functions.R")
cols <- read_tmtheme(tm_path)

tm <- readLines(rtheme)

fg <- cols |>
  filter(name == "foreground") |>
  pull(value)

margin_col <- cols |>
  filter(name == "invisibles") |>
  pull(value)

head_col <- cols |>
  filter(scope == "markup.heading") |>
  pull(foreground)

cursor_col <- cols |>
  filter(str_detect(scope, "keyword|string|constant")) |>
  group_by(foreground) |>
  count(sort = TRUE) |>
  filter(!is.na(foreground) & foreground != fg) |>
  ungroup() |>
  slice_head(n = 1) |>
  pull(foreground)

# Insert new rules
crs_css <- paste0(".ace_cursor {color: ", cursor_col, ";}")

margin_css <- paste0(".ace_print-margin {background: ", margin_col, ";}")
head_css <- paste0(
  ".ace_heading {color: ",
  head_col, ";}"
)


# Re-generate css and write
final_tm <- c(tm, crs_css, margin_css, head_css)

final_tm %>%
  sass::sass(output = rtheme)

rstudioapi::addTheme(rtheme, apply = TRUE, force = TRUE)
