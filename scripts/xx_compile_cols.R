library(tidyverse)
all_pygments <- list.files("./src/styles",
  pattern = ".scss", full.names = TRUE
)

# pygments only
all_pygments <- all_pygments[grepl("_pygments", all_pygments)]
f <- all_pygments[1]


for (f in all_pygments) {
  sasslines <- readLines(f)
  vars <- sasslines[sasslines |> str_detect("^\\$")]
  comp <- c(vars, "", "@import \"./src/_theme_cols.scss\";")
  out_f <- gsub("styles/", "compiledcols/", f)
  out_f <- gsub("_pygments.scss", "_colors.scss", out_f)
  final <- sass::sass(comp,
    options = sass::sass_options(output_style = "compact"),
    output = out_f
  )
}
