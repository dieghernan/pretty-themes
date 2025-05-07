library(tidyverse)


# List files

allcss <- list.files("src/styles", pattern = ".scss$", full.names = TRUE)


# Pygments (also used for compiling colors) ----

all_pygments <- allcss[grepl("_pygments", allcss)]
f <- all_pygments[1]
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


  # Compile cols
  sasslines <- readLines(f)
  vars <- sasslines[sasslines |> str_detect("^\\$")]
  comp <- c(vars, "", "@import \"./src/_theme_cols.scss\";")
  out_cols <- gsub("styles/", "compiledcols/", f)
  out_cols <- gsub("_pygments.scss", "_colors.scss", out_cols)
  final <- sass::sass(comp,
    options = sass::sass_options(output_style = "compact"),
    output = out_cols,
    cache = FALSE
  )
}


# Prismjs ----

all_prism <- allcss[grepl("_prismjs", allcss)]
f <- all_prism[1]
for (f in all_prism) {
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

# HighlightJS ----

all_hljs <- allcss[grepl("_hljs", allcss)]
f <- all_hljs[1]
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
