allt <- list.files("./dist/rstheme", pattern = ".rstheme", full.names = TRUE)

for (t in allt) {
  rstudioapi::addTheme(t, force = TRUE, apply = FALSE)
}
