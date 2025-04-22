library(tidyverse)

# # Clean inputs
# 
# # tmTheme
# tm_ddbb <- read_csv2("data/inputs/tm_ddbb.csv", locale = locale(encoding = "windows-1252"))
# tm_ddbb$tm_scope <- gsub("?", "", tm_ddbb$tm_scope)
# tm_ddbb |>
#   mutate(tm_desc = str_to_sentence(tm_desc),
#          tm_desc = str_squish(tm_desc),
#          tm_sublime_recommended = !is.na(tm_sublime_recommended),
#          tm_scope = str_squish(tm_scope),
#          pygmn_css = str_squish(pygmn_css)) |>
#   distinct() |>
#   print() |>
#   write_csv("data/tm_ddbb.csv")
# 
# 
# # Pygments
# pyg_ddbb <- read_csv2("data/inputs/pygments_ddbb.csv", locale = locale(encoding = "windows-1252"))
# 
# 
# 
# pyg_ddbb |>
#   mutate(pygmn_desc = str_to_sentence(pygmn_desc),
#          pygmn_desc = str_squish(pygmn_desc),
#          tm_scope = str_squish(tm_scope),
#          pygmn_css = str_squish(pygmn_css)) |>
#   print() |>
#   write_csv("data/pygments_ddbb.csv")
# 
# 
# 
# # Pandoc
# read_csv2("data/inputs/pandoc_ddbb.csv", locale = locale(encoding = "windows-1252")) |> 
#   mutate(pandoc_desc = str_squish(pandoc_desc),
#          pandoc_css = str_squish(pandoc_css),
#          pygmn_css = str_squish(pygmn_css),
#          tm_scope = str_squish(tm_scope))  |> 
#   write_csv("data/pandoc_ddbb.csv")
# 
# 


tm_ddbb <- read_csv("data/tm_ddbb.csv")
pyg_ddbb <- read_csv("data/pygments_ddbb.csv")
pandoc_ddbb <- read_csv("data/pandoc_ddbb.csv")

clipr::write_clip(tm_ddbb)

pyg_ddbb <- pyg_ddbb |> 
  arrange(tm_scope) |> 
  select(tm_scope) |> 
  distinct() |>  pull()
pyg_ddbb

full_ddbb <- tm_ddbb |> select(tm_scope, 
                               pygmn_css) |> 
  full_join(pyg_ddbb |>  select(tm_scope, pygmn_css))  |>
  left_join(pandoc_ddbb |> 
              filter(!is.na(tm_scope)) |>
              select(pandoc_css, tm_scope)
  ) |> 
  distinct() 


full_ddbb[(full_ddbb$pygmn_css == "sc" & !is.na(full_ddbb$pygmn_css)),"pandoc_css"] <- "ch"


