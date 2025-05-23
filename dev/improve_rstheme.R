library(tidyverse)
tminput <- "./dist/tmTheme/Selenized Dark.tmTheme"
outdir <- "./dist/rstheme"
rtheme_out <- tools::file_path_sans_ext(tminput) |>
  basename() |>
  paste0(".rstheme") %>%
  file.path(outdir, .)

# Start fun here!!!!!!!!!!!

require(tidyverse)
require(xml2)
require(sass)

## Additional colors -----
source("src/functions.R")
tmcols <- read_tmtheme(tminput)
mapping <- read_csv("src/mapping_themes.csv", show_col_types = FALSE)

### Rules ----


tmcols_clean <- tmcols |>
  mutate(
    tm = coalesce(scope, name),
    fg = coalesce(foreground, value),
    bg = background,
    fontweight = ifelse(str_detect(fontStyle, "old"), "bold", NA),
    fontstyle = ifelse(str_detect(fontStyle, "talic"), "italic", NA)
  ) |>
  select(tm, fg, bg, fontweight, fontstyle)

col2add <- tmcols_clean |>
  inner_join(mapping, by = "tm") |>
  filter(!is.na(rstheme)) |>
  select(rstheme, fg:fontstyle)

new_css <- c("/* Rules from tmTheme */", "")
cssrule <- ".ace_heading"
for (cssrule in col2add$rstheme) {
  thisval <- col2add[col2add$rstheme == cssrule, ]
  if (cssrule == ".ace_print-margin") {
    thisrule <- paste0(".ace_print-margin {background: ", thisval$fg, ";}")
    new_css <- c(new_css, thisrule, "")
  } else {
    newr <- list(
      color = thisval$fg,
      "background-color" = thisval$bg,
      "font-weight" = thisval$fontweight,
      "font-style" = thisval$fontstyle
    )
    newr_clean <- newr[!is.na(newr)]
    specs <- paste0(names(newr_clean), ": ", newr_clean, ";", collapse = " ")
    thisrule <- paste0(cssrule, " {", specs, "}")
    new_css <- c(new_css, thisrule, "")
  }
}


### Compiled vars ----

fg_col <- tmcols |>
  filter(name == "foreground") |>
  pull(value) %>%
  paste0("$fg: ", ., ";")

bg_col <- tmcols |>
  filter(name == "background") |>
  pull(value) %>%
  paste0("$bg: ", ., ";")

accent_col <- tmcols |>
  filter(name == "caret") |>
  pull(value) %>%
  paste0("$accent: ", ., ";")

sel_col <- tmcols |>
  filter(name == "selection") |>
  pull(value) %>%
  paste0("$selection: ", ., ";")

com_col <- tmcols |>
  filter(str_detect(scope, "comment") & !is.na(foreground)) |>
  arrange(scope) |>
  slice_head(n = 1) |>
  pull(foreground) %>%
  paste0("$comment: ", ., ";")

# SASS stylesheet
compiler <- readLines("./src/_better_rstheme.scss")

## Build ----

# Create a first compilation
rstudioapi::convertTheme(tminput,
  add = FALSE, outputLocation = outdir,
  force = TRUE
)


# Read the lines of the auto-generated rstheme (is a css)
# and add new css rules and extra cols

readLines(rtheme_out) %>%
  # New rules
  c(new_css) %>%
  # Compilers
  c(fg_col, bg_col, accent_col, sel_col, com_col, compiler) |>
  # Compile and write
  sass::sass(output = rtheme_out, cache = FALSE)

# Apply the new theme
rstudioapi::addTheme(rtheme_out, apply = TRUE, force = TRUE)
