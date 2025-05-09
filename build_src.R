source("scripts/99_run_all.R")
lintr::lint_dir("./scripts")

styler::style_dir("dev")

