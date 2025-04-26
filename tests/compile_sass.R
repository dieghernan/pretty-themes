test <- readLines("tests/dev.scss")


# test <- readLines("scss/template.scss")
comp <- sass::sass(test, output = "./tests/dev.css", cache = FALSE, 
                   options = sass::sass_options(output_style = "compact"))


testprism <- readLines("tests/devprism.scss")



compprism <- sass::sass(testprism, output = "./tests/devprism.css", cache = FALSE, 
                   options = sass::sass_options(output_style = "expanded"))


testhljs <- readLines("tests/devhljs.scss")



comphljs <- sass::sass(testhljs, output = "./tests/devhljs.css", cache = FALSE, 
                        options = sass::sass_options(output_style = "expanded"))

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
