library(jsonlite)
library(tidyverse)

# Read produced vscode themes
myvs <- list.files("./dist/vscode", full.names = TRUE)

the_df <- lapply(myvs, function(x) {
  js <- read_json(x)
  tibble::tibble(
    label = js$name,
    uiTheme = ifelse(js$type == "light", "vs", "vs-dark"),
    path = x
  )
}) %>%
  bind_rows() %>%
  arrange(label)


tm <- list()

nm <- names(the_df)

for (i in seq_len(nrow(the_df))) {
  specs <- as.character(the_df[i, ])
  names(specs) <- nm

  tm[[i]] <- as.list(specs)
}

toJSON(tm, pretty = TRUE)




# Package json
pk <- read_json("package.json")
pk$contributes$themes <- tm

write_json(pk, "package.json", pretty = TRUE, auto_unbox = TRUE)
