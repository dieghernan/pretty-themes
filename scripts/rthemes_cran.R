library(tidyverse)

tm_path <- "./dist/tmTheme/cran.tmTheme"
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
cursor_col <- "#007020"
crs_css <- paste0(".ace_cursor {color: ", cursor_col, ";}")
margin_col <- "#DBDBDB"
margin_css <- paste0(".ace_print-margin {background: ", margin_col, ";}")

head_col <- "#BA2121"
head_css <- paste0(
  ".ace_heading {color: ",
  head_col, "; font-style: italic;}"
)


# Re-generate css and write
final_tm <- c(tm, crs_css, margin_css, head_css)

final_tm %>%
  sass::sass(output = rtheme)

rstudioapi::addTheme(rtheme, apply = TRUE, force = TRUE)
