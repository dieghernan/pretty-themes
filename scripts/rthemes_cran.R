library(tidyverse)

tm_path <- "./dist/tmTheme/cran.tmTheme"
outdir <- "./dist/rstheme"



# Create vscode here first
source("dev/functions.R")


out_vs <- "./dist/vscode/cran-theme.json"

tmtheme2vscode(tm_path, out_vs)


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
  filter(name == "caret") |>
  pull(value)


scales::show_col(c(cursor_col, margin_col, head_col))

# Insert new rules
crs_css <- paste0(".ace_cursor {color: ", cursor_col, ";}")
margin_css <- paste0(".ace_print-margin {background: ", margin_col, ";}")

head_css <- paste0(
  ".ace_heading {color: ",
  head_col, "; font-style: italic;}"
)




# Re-generate css and write
final_tm <- c(tm, crs_css, margin_css, head_css)

# UI fixtures


fg <- cols |>
  filter(name == "foreground") |>
  pull(value) %>%
  paste0("$ui_foreground: ", ., ";")

bg <- cols |>
  filter(name == "background") |>
  pull(value) %>%
  paste0("$ui_background: ", ., ";")

sel <- cols |>
  filter(name == "selection") |>
  pull(value) %>%
  paste0("$ui_selection: ", ., ";")

cur <- cols |>
  filter(name == "caret") |>
  pull(value) %>%
  paste0("$ui_cursor: ", ., ";")


rstudio_temp <- readLines("src/_light_rstheme.scss")



c(final_tm, fg, bg, sel, cur, rstudio_temp) %>%
  sass::sass(output = rtheme)



rstudioapi::addTheme(rtheme, apply = TRUE, force = TRUE)
