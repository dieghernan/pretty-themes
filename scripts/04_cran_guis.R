# Create vscode (json) and RStudio (rstheme) variants using tmTheme as base

library(tidyverse)
tminput <- "./dist/tmTheme/cran.tmTheme"

source("dev/functions.R")

# VScode -----
output <- basename(tminput) %>%
  str_replace_all(".tmTheme", "-theme.json") %>%
  str_replace_all(" ", "-") %>%
  file.path("dist", "vscode", .)

output

tmtheme2vscode(tminput, output)

# Prettify output
read_json(output) |>
  write_json(path = output, auto_unbox = TRUE, pretty = TRUE)

# And get type of theme here
them_type <- read_json(output)$type

message(basename(tminput), " is ", them_type)

# RStudio Theme ----

# Beautify tmTheme
xml2::read_xml(tminput) %>%
  xml2::write_xml(tminput)


# Create a first compilation
outdir <- "./dist/rstheme"
rtheme <- tools::file_path_sans_ext(tminput) |>
  basename() |>
  paste0(".rstheme") %>%
  file.path(outdir, .)


rstudioapi::convertTheme(tminput,
  add = FALSE,
  outputLocation = outdir,
  force = TRUE
)


## Additional colors -----

# Cursors and accents, etc. from tmTheme
tmthemecols <- read_tmtheme(tminput)

fg_col <- tmthemecols |>
  filter(name == "foreground") |>
  pull(value)

bg_col <- tmthemecols |>
  filter(name == "background") |>
  pull(value)

margin_col <- tmthemecols |>
  filter(name == "invisibles") |>
  pull(value)

cursor_col <- tmthemecols |>
  filter(name == "caret") |>
  pull(value)
sel_col <- tmthemecols |>
  filter(name == "selection") |>
  pull(value)

head_col <- tmthemecols |>
  filter(scope == "markup.heading") |>
  pull(foreground)


scales::show_col(c(
  fg_col, bg_col, sel_col,
  cursor_col, margin_col, head_col
))


# Create sass variables for compilation

ui_foreground <- paste0("$ui_foreground: ", fg_col, ";")
ui_background <- paste0("$ui_background: ", bg_col, ";")
ui_selection <- paste0("$ui_selection: ", sel_col, ";")
ui_cursor <- paste0("$ui_cursor: ", cursor_col, ";")


# Other rules
crs_css <- paste0(".ace_cursor {color: ", cursor_col, ";}")
margin_css <- paste0(".ace_print-margin {background: ", margin_col, ";}")

head_css <- paste0(".ace_heading {color: ", head_col, "; font-style: italic;}")

# Compiler based in theme settings

extra_rstudio <- them_type %>%
  paste0("./src/_", ., "_rstheme.scss") %>%
  readLines()


# Read the lines of the auto-generated rstheme (is a css)
# and add new css rules and extra cols

readLines(rtheme) %>%
  # New rules
  c(crs_css, margin_css, head_css) %>%
  # Compilers
  c(ui_background, ui_foreground, ui_cursor, ui_selection, extra_rstudio) %>%
  # Compile and write
  sass::sass(output = rtheme, cache = FALSE)



# Apply the new theme
rstudioapi::addTheme(rtheme, apply = TRUE, force = TRUE)
