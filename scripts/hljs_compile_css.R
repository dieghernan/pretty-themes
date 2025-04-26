library(tidyverse)
all_prism <- list.files("hljs",
  pattern = ".scss",
  full.names = TRUE
)

# No template
all_prism <- all_prism[!grepl("template", all_prism)]

exc <- c("stackoverflow")

exc_f <- all_prism[grepl(exc, all_prism)]

for (f in exc_f) {
  out_f <- basename(f) |>
    tools::file_path_sans_ext() |>
    paste0(".css") %>%
    file.path("./prismjs", "css", .)
  file.copy(f, out_f, overwrite = TRUE)
}

all_prism <- all_prism[!grepl(exc, all_prism)]

for (f in all_prism) {
  out_f <- basename(f) |>
    tools::file_path_sans_ext() |>
    paste0(".css") %>%
    file.path("./prismjs", "css", .)
  in_f <- readLines(f)

  message(f)
  # test <- readLines("scss/template.scss")
  comp <- sass::sass(in_f,
    output = out_f,
    cache = FALSE
  )
}
