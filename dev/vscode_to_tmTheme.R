library(tidyverse)
library(xml2)
library(jsonlite)

vsinput <- "vendor/dracula/dracula.json"
output <- "dev/devdracula.tmTheme"
# Based in https://github.com/microsoft/vscode-generator-code/blob/6e3f05ab46b6186e588094517764fdf42f21d094/generators/app/generate-colortheme.js#L237C18-L261C2
mapping <- read_csv("src/mapping_themes.csv")

get_template <- read_xml("./src/templates/template.tmTheme") |>
  as_list()

# 1. Read vscode and prepare

vs <- read_json(vsinput)

# Convert settings to tmTheme
settings <- vs$colors

it <- seq_len(length(settings))

settings_df <- lapply(it, function(i) {
  x <- settings[i]
  val <- unlist(x)
  if (length(val) < 1) val <- NA
  tibble(
    vscode = names(x),
    color = unname(val)
  )
}) |> bind_rows()

# Match
end <- mapping |>
  left_join(settings_df) |>
  filter(!is.na(color)) |>
  select(tm, color) |>
  distinct()



# As a bare minimum we should have background, caret, foreground, invisibles
# lineHighlight, selection. If not assing colors

fg <- end |>
  filter(tm == "foreground") |>
  pull(color)
bg <- end |>
  filter(tm == "background") |>
  pull(color)

# Modify
sel <- end[end$tm == "selection", ]$color |> as.character()

if (!"caret" %in% end$tm) {
  df <- tibble(tm = "caret", color = fg)

  end <- bind_rows(end, df)
}
if (!"invisibles" %in% end$tm) {
  df <- tibble(tm = "invisibles", color = inv)

  end <- bind_rows(end, df)
}
if (!"lineHighlight" %in% end$tm) {
  df <- tibble(tm = "lineHighlight", color = sel)

  end <- bind_rows(end, df)
}
if (!"selection" %in% end$tm) {
  df <- tibble(tm = "selection", color = sel)

  end <- bind_rows(end, df)
}

themename <- vs$name |>
  as.character() |>
  unname()

# Create settings
ll <- NULL
for (i in seq_len(nrow(end))) {
  this <- end[i, ]
  tm <- this$tm |> as.character()
  col <- this$color |> as.character()
  ll <- c(ll, list(key = list(tm), string = list(col)))
}

# Fill the template
setting <- list(
  dict = list(
    key = list("settings"),
    dict = ll
  )
)


# Now get the rest of params (token colors)
tokens <- vs$tokenColors
ntok <- seq_len(length(tokens))

i <- 16

for (i in ntok) {
  this <- tokens[i][[1]]
  name <- unlist(this$name)
  if (length(name) == 0) {
    name <- ""
  }
  scope <- this$scope |>
    unlist() |>
    paste0(collapse = ", ")
  message(i, " is ", scope)
  # Settings are ok
  sett <- this$settings

  onl <- list(
    dict = list(
      key = list("name"),
      string = list(name),
      key = list("scope"),
      string = list(scope),
      key = list("settings"),
      dict = list()
    )
  )

  dictt <- NULL
  settts <- unlist(sett)
  if ("foreground" %in% names(settts)) {
    dictt <- c(dictt, list(
      key = list("foreground"),
      string = settts["foreground"] |> unname() |> paste0(collapse = " ") |> list()
    ))
  }
  if ("background" %in% names(settts)) {
    dictt <- c(dictt, list(
      key = list("background"),
      string = settts["background"] |> unname() |> paste0(collapse = " ") |> list()
    ))
  }
  if ("fontStyle" %in% names(settts)) {
    dictt <- c(dictt, list(
      key = list("fontStyle"),
      string = settts["fontStyle"] |> unname() |> paste0(collapse = " ") |> list()
    ))
  }

  if (!is.null(dictt)) {
    onl$dict$dict <- dictt

    setting <- c(setting, onl)
  }
}


build <- get_template
build$plist$dict[[2]][[1]] <- themename


build$plist$dict$array <- list(setting)

build |>
  xml2::as_xml_document() |>
  write_xml(output)
