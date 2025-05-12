library(tidyverse)
library(xml2)
library(jsonlite)
source("dev/functions.R")

# tminput <- "dist/tmTheme/cran.tmTheme"
# output <- "./dist/vscode/cran-color-theme.json"

# tminput <- "dist/tmTheme/Skeletor.tmTheme"
# output <- "./dist/vscode/skeletor-color-theme.json"

tminput <- "dist/tmTheme/StackOverflow Dark.tmTheme"
output <- "./dist/vscode/stackoverflow-dark-color-theme.json"

tminput <- "./dist/tmTheme/Selenized White.tmTheme"
outdir <- "./dist/rstheme"
tmtheme2vscode(tminput, output)
