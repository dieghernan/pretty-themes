library(tidyverse)

tm_path <- "./dist/tmTheme/StackOverflow Light.tmTheme"
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

tm <- readLines(rtheme)

# Insert new rules
cursor_col <- "#b75501"
crs_css <- paste0(".ace_cursor {color: ", cursor_col, ";}")
margin_col <- "#CECFD0"
margin_css <- paste0(".ace_print-margin {background: ", margin_col, ";}")

head_col <- "#015692"
head_css <- paste0(
  ".ace_heading {color: ",
  head_col, ";}"
)


# Re-generate css and write
final_tm <- c(tm, crs_css, margin_css, head_css)

final_tm %>%
  sass::sass(output = rtheme)

rstudioapi::addTheme(rtheme, apply = TRUE, force = TRUE)
