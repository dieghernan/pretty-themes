library(tidyverse)

tm_path <- "./tmTheme/OkSolar Light.tmTheme"
outdir <- "./rstheme"
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

# Modify some elements ----
cursor_col <- "#093946"
tm <- readLines(rtheme)

curs_lin <- grep("ace_cursor", tm)
tm[curs_lin + 1] <- paste0("color: ", cursor_col, ";")

# Add rules before terminal
tem_lin <- grep("terminal", tm)[1] - 1
partial1 <- tm[seq(1, tem_lin)]
partial2 <- tm[seq(tem_lin + 1, length(tm))]

# Insert new rules
head_col <- "#AC8300"
head_css <- paste0(
  ".ace_heading {color: ",
  head_col, ";}"
)


# Re-generate css and write
final_tm <- c(partial1, head_css, partial2)

final_tm %>%
  sass::sass(output = rtheme)

rstudioapi::addTheme(rtheme, apply = TRUE, force = TRUE)
