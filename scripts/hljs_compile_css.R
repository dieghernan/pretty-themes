library(tidyverse)
all_hljs <- list.files("./src/styles",
  pattern = ".scss", full.names = TRUE
)

# hljs only
all_hljs <- all_hljs[grepl("hljs", all_hljs)]
f <- all_hljs

for (f in all_hljs) {
  out_sass <- basename(f) %>%
    gsub("_|hljs", "", .) %>%
    file.path("./dist", "hljs", .)

  out_css <- basename(out_sass) %>%
    gsub("_", "", .) |>
    tools::file_path_sans_ext() |>
    paste0(".css") %>%
    file.path("./dist", "hljs", .)

  out_css_min <- basename(out_sass) %>%
    tools::file_path_sans_ext() |>
    paste0(".min.css") %>%
    file.path("./dist", "hljs", .)
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
