library(tidyverse)
library(xml2)

theme <- "skeletor"


get_template <- read_xml("./src/templates/template.tmTheme") |>
  as_list()

get_template$plist$dict$array
get_template$plist

get_cols <- readLines(paste0("src/compiledcols/_", theme, "_colors.scss"))
scopes_ddbb <- read_csv("dev/scopes_ddbb.csv")
# clipr::write_clip(scopes_ddbb)

scopeandcols <- get_cols[get_cols != ""] %>%
  gsub(".", "", ., fixed = TRUE) %>%
  gsub("_", ".", ., fixed = TRUE) %>%
  lapply(., function(x) {
    scope <- str_split_i(x, "\\{", 1) |> trimws()
    col <- str_split_i(x, "\\{", 2) |>
      trimws() |>
      str_remove_all("color: ") |>
      str_remove_all(fixed("; }")) |>
      trimws()

    tibble(
      scope = scope,
      color = col
    )
  }) |>
  bind_rows()

# Remove those that are like foreground
fg <- scopeandcols |>
  filter(scope == "foreground") |>
  pull(color)

bg <- scopeandcols |>
  filter(scope == "background") |>
  pull(color)

# Suggestion for selection
sel <- colorspace::mixcolor(0.8, colorspace::hex2RGB(fg), colorspace::hex2RGB(bg)) |>
  colorspace::hex()
inv <- colorspace::mixcolor(0.95, colorspace::hex2RGB(fg), colorspace::hex2RGB(bg)) |>
  colorspace::hex()

# Fill the template
setting <- list(
  dict = list(
    key = list("settings"),
    dict = list(
      key = list("background"),
      string = list(bg),
      key = list("caret"),
      string = list(fg),
      key = list("foreground"),
      string = (list(fg)),
      key = list("invisibles"),
      string = list(inv),
      key = list("lineHighlight"),
      string = list(sel),
      key = list("selection"),
      string = list(sel)
    )
  )
)

# Scope and cols
scopes <- scopeandcols |>
  filter(!scope %in% c("foreground", "background")) |>
  select(scope, foreground = color)

scopes <- scopes |>
  mutate(
    foreground = ifelse(foreground == fg, NA, foreground),
    fontStyle = NA
  ) |>
  left_join(scopes_ddbb)


scopes[scopes$scope == "markup.italic", "fontStyle"] <- "italic"
scopes[scopes$scope == "markup.bold", "fontStyle"] <- "bold"

enddef <- scopes |>
  filter(!(is.na(foreground) & is.na(fontStyle)))

ntot <- seq_len(nrow(enddef))

for (i in ntot) {
  one <- enddef[i, ]
  message(one$scope)

  onl <- list(
    dict = list(
      key = list("name"),
      string = list(one$name),
      key = list("scope"),
      string = list(one$scope),
      key = list("settings"),
      dict = list()
    )
  )
  dictt <- NULL
  if (!is.na(one$foreground)) {
    dictt <- c(dictt, list(
      key = list("foreground"),
      string = list(one$foreground)
    ))
  }
  if (!is.na(one$fontStyle)) {
    dictt <- c(dictt, list(
      key = list("fontStyle"),
      string = list(one$fontStyle)
    ))
  }

  onl$dict$dict <- dictt
  message(i)
  message(dput(onl))
  setting <- c(setting, onl)
}




build <- get_template

build$plist$dict$array <- list(setting)

out_f <- paste0("dev/test", theme, ".tmTheme")

build |>
  xml2::as_xml_document() |>
  write_xml(out_f)
newname <- gsub(".", "_", theme, fixed = TRUE)
readLines(out_f) |>
  str_replace_all("Template for creating tmTheme files", newname) |>
  writeLines(out_f)

source("dev/functions.R")


pp <- read_tmtheme(out_f)
