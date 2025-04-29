library(tidyverse)
all_pygments <- list.files("./src/styles",
  pattern = ".scss", full.names = TRUE
)

# pygments only
all_pygments <- all_pygments[grepl("_pygments", all_pygments)]
f <- all_pygments

for (f in all_pygments) {
  out_sass <- basename(f) %>%
    gsub("_|pygments", "", .) %>%
    file.path("./dist", "pygments", .)

  out_css <- basename(out_sass) %>%
    gsub("_", "", .) |>
    tools::file_path_sans_ext() |>
    paste0(".css") %>%
    file.path("./dist", "pygments", .)

  out_css_min <- basename(out_sass) %>%
    tools::file_path_sans_ext() |>
    paste0(".min.css") %>%
    file.path("./dist", "pygments", .)
  in_f <- readLines(f)

  message(basename(out_sass))

  comp <- sass::sass(in_f,
    output = out_sass,
    cache = FALSE,
    options = sass::sass_options(output_style = "compact")
  )

  comp <- sass::sass(in_f,
    output = out_css,
    cache = FALSE,
    options = sass::sass_options(output_style = "compact")
  )
  comp <- sass::sass(in_f,
    output = out_css_min,
    cache = FALSE,
    options = sass::sass_options(output_style = "compressed")
  )
}
