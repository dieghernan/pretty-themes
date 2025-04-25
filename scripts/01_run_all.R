# Run all the scripts at once
all_rs_scripts <- list.files("./scripts", 
                             pattern = ".R$", full.names = TRUE)

# Exclude this
all_rs_scripts <- all_rs_scripts[!grepl("01_run", all_rs_scripts)]

lapply(all_rs_scripts, source)

allt <- rstudioapi::getThemes()

allt["cran"]
allt["cobalt2"]
allt["skeletor"]
allt[grep("oksol", names(allt))]
allt[grep("seleni", names(allt))]
allt[grep("github", names(allt))]

rstudioapi::applyTheme("Selenized Dark")
