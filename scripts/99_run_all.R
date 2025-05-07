styler::style_dir("scripts")

# Run all the scripts at once
all_rs_scripts <- list.files("./scripts",
  pattern = ".R$", full.names = TRUE
)

# Exclude this
all_rs_scripts <- all_rs_scripts[!grepl("99_run", all_rs_scripts)] |>
  sort()


nothing <- lapply(all_rs_scripts, function(x) {
  message(">>>> this is ", basename(x), " >>>>")
  source(x)
})





rstudioapi::applyTheme("Selenized Dark")
