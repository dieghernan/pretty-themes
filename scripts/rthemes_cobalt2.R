library(tidyverse)

tm_path <- "./dist/tmTheme/cobalt2.tmTheme"
outdir <- "./dist/rstheme"
rtheme <- tools::file_path_sans_ext(tm_path) |>
  basename() |>
  paste0(".rstheme") %>%
  file.path(outdir, .)

xml2::read_xml(tm_path) |>
  xml2::write_xml(tm_path)

file.exists(tm_path)
rstudioapi::convertTheme(tm_path,
  add = FALSE,
  outputLocation = outdir,
  force = TRUE
)

# Modify some elements ----
cursor_col <- "#FFC600"


tm <- readLines(rtheme)

curs_lin <- grep("ace_cursor", tm)
tm[curs_lin + 1] <- paste0("color: ", cursor_col, ";")

# Add rules before terminal
tem_lin <- grep("terminal", tm)[1] - 1
partial1 <- tm[seq(1, tem_lin)]
partial2 <- tm[seq(tem_lin + 1, length(tm))]

# Insert new rules
head_css <- paste0(
  ".ace_heading {background-color: #001221; ",
  "color: #ffc600; font-weight: bold;}"
)

str <- paste0(
  ".ace_string {color: #9EFF80};"
)

# Re-generate css and write
final_tm <- c(partial1, head_css, str, partial2)

final_tm %>%
  sass::sass(output = rtheme)

rstudioapi::addTheme(rtheme, apply = TRUE, force = TRUE)
