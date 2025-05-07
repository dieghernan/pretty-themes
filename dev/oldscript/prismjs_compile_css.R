library(tidyverse)
all_prismjs <- list.files("./src/styles",
  pattern = ".scss", full.names = TRUE
)

# prismjs only
all_prismjs <- all_prismjs[grepl("prismjs", all_prismjs)]
f <- all_prismjs

for (f in all_prismjs) {
  out_sass <- basename(f) %>%
    gsub("_|prismjs", "", .) %>%
    file.path("./dist", "prismjs", .)

  out_css <- basename(out_sass) %>%
    gsub("_", "", .) |>
    tools::file_path_sans_ext() |>
    paste0(".css") %>%
    file.path("./dist", "prismjs", .)

  out_css_min <- basename(out_sass) %>%
    tools::file_path_sans_ext() |>
    paste0(".min.css") %>%
    file.path("./dist", "prismjs", .)
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
