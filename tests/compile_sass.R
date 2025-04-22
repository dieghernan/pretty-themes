test <- readLines("tests/dev.scss")


# test <- readLines("scss/template.scss")
comp <- sass::sass(test, output = "./tests/dev.css", cache = FALSE, 
                   options = sass::sass_options(output_style = "compact"))

# 
# 
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
