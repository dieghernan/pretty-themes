all_pygments <- list.files("pygments", pattern = ".scss",
                           full.names = TRUE)

# No template 
all_pygments <- all_pygments[!grepl("template", all_pygments)]

f <- all_pygments[1]
for (f in all_pygments){
out_f <- basename(f) |> 
  tools::file_path_sans_ext() |> 
  paste0(".css") %>%
  file.path("./pygments", "css", .)
  in_f <- readLines(f)


  # test <- readLines("scss/template.scss")
  comp <- sass::sass(in_f, output = out_f, 
                     cache = FALSE,
                     options = sass::sass_options(output_style = "compact"))
  message()
  
}


