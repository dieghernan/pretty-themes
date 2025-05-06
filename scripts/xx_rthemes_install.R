recreate <- list.files("scripts", "^rtheme", full.names = TRUE)

lapply(recreate, source)

allt <- list.files("./dist/rstheme", pattern = ".rstheme", full.names = TRUE)

for (t in allt) {
  rstudioapi::addTheme(t, force = TRUE, apply = FALSE)
}

rstudioapi::applyTheme("Selenized Dark")
