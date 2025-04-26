allt <- list.files("./rstheme", pattern = ".rstheme", full.names = TRUE)

for (t in allt) {
  rstudioapi::addTheme(t, force = TRUE, apply = FALSE)
}

rstudioapi::applyTheme("Selenized Dark")
