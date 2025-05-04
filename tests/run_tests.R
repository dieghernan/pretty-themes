theme_to_test <- "_panda"

test <- readLines(file.path(
  "src", "styles",
  paste0(theme_to_test, "_pygments.scss")
))

comp <- sass::sass(test,
  output = "./tests/dev.css", cache = FALSE,
  options = sass::sass_options(output_style = "compact")
)


testprism <- readLines(file.path(
  "src", "styles",
  paste0(theme_to_test, "_prismjs.scss")
))

compprism <- sass::sass(testprism,
  output = "./tests/devprism.css",
  cache = FALSE,
  options = sass::sass_options(output_style = "expanded")
)



testhljs <- readLines(file.path(
  "src", "styles",
  paste0(theme_to_test, "_hljs.scss")
))


comphljs <- sass::sass(testhljs,
  output = "./tests/devhljs.css", cache = FALSE,
  options = sass::sass_options(output_style = "expanded")
)



# #
# #
# # test <- readLines("scss/template.scss")
# theme <- readLines("scss/cran.scss")
#
# comp <- sass::sass(theme, output = "./css/cran.css", cache = FALSE,
#                    options = sass::sass_options(output_style = "compact"))
#
#
#
#
#
