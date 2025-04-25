library(tidyverse)

# thTheme file created based on the VS Code settings
# https://github.com/jan-warchol/selenized/blob/master/editors/visual-studio-code/themes/selenized-dark.json
# Use Selenized Dark theme as reference and modify rest of templates
# based in the same color scheme

# Create db
# Specs from https://github.com/jan-warchol/selenized/blob/master/the-values.md
tb <- tibble(colnames = c(
  "bg_0", "bg_1", "bg_2", "dim_0", "fg_0", "fg_1", "red", "green", "yellow",
  "blue", "magenta", "cyan", "orange", "violet", "br_red", "br_green",
  "br_yellow", "br_blue", "br_magenta", "br_cyan", "br_orange", "br_violet"
))

tb$dark_spec <- c(
  "#103c48", "#184956", "#2d5b69", "#72898f", "#adbcbc", "#cad8d9", "#fa5750",
  "#75b938", "#dbb32d", "#4695f7", "#f275be", "#41c7b9", "#ed8649", "#af88eb",
  "#ff665c", "#84c747", "#ebc13d", "#58a3ff", "#ff84cd", "#53d6c7", "#fd9456",
  "#bd96fa"
) %>%
  toupper()

tb$black_spec <- c(
  "#181818", "#252525", "#3b3b3b", "#777777", "#b9b9b9", "#dedede", "#ed4a46",
  "#70b433", "#dbb32d", "#368aeb", "#eb6eb7", "#3fc5b7", "#e67f43", "#a580e2",
  "#ff5e56", "#83c746", "#efc541", "#4f9cfe", "#ff81ca", "#56d8c9", "#fa9153",
  "#b891f5"
) %>% toupper()

tb$light_spec <- c(
  "#fbf3db", "#ece3cc", "#d5cdb6", "#909995", "#53676d", "#3a4d53", "#d2212d",
  "#489100", "#ad8900", "#0072d4", "#ca4898", "#009c8f", "#c25d1e", "#8762c6",
  "#cc1729", "#428b00", "#a78300", "#006dce", "#c44392", "#00978a", "#bc5819",
  "#825dc0"
) %>%
  toupper()

tb$white_spec <- c(
  "#ffffff", "#ebebeb", "#cdcdcd", "#878787", "#474747", "#282828", "#d6000c",
  "#1d9700", "#c49700", "#0064e4", "#dd0f9d", "#00ad9c", "#d04a00", "#7f51d6",
  "#bf0000", "#008400", "#af8500", "#0054cf", "#c7008b", "#009a8a", "#ba3700",
  "#6b40c3"
) %>% toupper()



tb |> 
  select(colnames, spec = white_spec) |> 
  mutate(scss = paste0("$", colnames, ": ", spec, ";")) |> 
  select(scss) |> 
  clipr::write_clip()


# OkSolar

tb <- tibble(colnames = c(
  "bg_0", "bg_1", "bg_2", "dim_0", "fg_0", "fg_1", "red", "green", "yellow",
  "blue", "magenta", "cyan", "orange", "violet", "br_red", "br_green",
  "br_yellow", "br_blue", "br_magenta", "br_cyan", "br_orange", "br_violet"
))

tb$dark_spec <- c(
  "#103c48", "#184956", "#2d5b69", "#72898f", "#adbcbc", "#cad8d9", "#fa5750",
  "#75b938", "#dbb32d", "#4695f7", "#f275be", "#41c7b9", "#ed8649", "#af88eb",
  "#ff665c", "#84c747", "#ebc13d", "#58a3ff", "#ff84cd", "#53d6c7", "#fd9456",
  "#bd96fa"
) %>%
  toupper()

tb$oksolar_dark_spec <- c(
  "#002d38", "#093946", "#5b7279", "#657377", "#98a8a8", "#8faaab", "#f23749",
  "#819500", "#ac8300", "#2b90d8", "#dd459d", "#259d94", "#d56500", "#7d80d1",
  "#f23749", "#819500", "#ac8300", "#2b90d8", "#dd459d", "#259d94", "#d56500",
  "#7d80d1") %>% toupper()

tb$oksolar_light_spec <- c(
  "#f1e9d2", "#8faaab", "#98a8a8", "#657377", "#5b7279", "#093946",  "#f23749",
  "#819500", "#ac8300", "#2b90d8", "#dd459d", "#259d94", "#d56500", "#7d80d1",
  "#f23749", "#819500", "#ac8300", "#2b90d8", "#dd459d", "#259d94", "#d56500",
  "#7d80d1") %>% toupper()


tb |> 
  select(colnames, spec = oksolar_light_spec) |> 
  mutate(scss = paste0("$", colnames, ": ", spec, ";")) |> 
  select(scss) |> 
  clipr::write_clip()
