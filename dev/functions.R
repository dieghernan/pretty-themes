read_tmtheme <- function(input) {
  require(xml2)
  require(tidyverse)



  tmtheme <- read_xml(input)

  tm_lst <- tmtheme |> as_list()

  # Metadata
  meta_l <- tm_lst$plist$dict

  meta_n <- meta_l[names(meta_l) == "key"] |> unlist()
  meta_n <- meta_n[meta_n != "settings"]
  meta_val <- meta_l[names(meta_l) == "string"] |> unlist()

  meta_df <- tibble(
    section = "tmTheme Metadata",
    name = meta_n,
    value = meta_val
  )

  array_lst <- tmtheme |>
    xml_find_first("//array") |>
    xml_find_all(".//dict") |>
    as_list()


  # Base preproc
  array <- tm_lst$plist$dict$array

  # Top level vars
  topl <- lapply(array, function(x) {
    "string" %in% names(x)
  }) |>
    unlist() |>
    unname()


  # Top level
  topv <- array[!topl]$dict$dict
  nms_top <- names(topv)
  then <- topv[nms_top == "key"] |> unlist()
  vl <- topv[nms_top == "string"] |> unlist()

  top_df <- tibble(
    section = "Top-level config",
    name = then,
    value = vl
  )

  x <- array[2][[1]]
  specs <- lapply(array[topl], function(x) {
    # No spec
    thisloop <- x
    nms_no <- names(thisloop)

    # Don't want dict
    no_spec <- thisloop[nms_no == "key"] |> unlist()
    no_spec <- no_spec[no_spec != "settings"]
    vals_no_spec_init <- thisloop[nms_no == "string"]
    vals_no_spec <- lapply(vals_no_spec_init, function(y) {
      if (length(y) == 0) {
        return("")
      }

      return(unlist(y))
    }) |> unlist()

    names(vals_no_spec) <- no_spec
    df_top <- as_tibble_row(vals_no_spec)





    # Specification
    specs <- thisloop$dict |> lapply(function(x) {
      if (length(x) == 0) {
        return("NULL")
      }
      x
    })

    # Spec df
    if (length(specs) == 0) {
      df_spec <- tibble(foreground = "")
    } else {
      # Spec df
      nm <- names(specs)
      val <- specs[nm == "string"] |> unlist()
      names(val) <- specs[nm == "key"] |> unlist()

      df_spec <- as_tibble_row(val)
    }


    bind_cols(df_top, df_spec)
  }) |>
    bind_rows()

  specs[specs == "NULL"] <- NA
  # Do unnesting
  scopes <- specs$scope

  newsc <- lapply(scopes, function(x) {
    this <- str_split(x, " |,", simplify = TRUE) |> unlist()
    this[this != ""]
  })
  specs$scope <- newsc

  specs_end <- specs |>
    unnest(cols = scope)
  specs_end$section <- "Scopes"

  # Final df
  template <- tibble(
    section = "Delete",
    name = "Delete",
    scope = NA,
    value = NA,
    foreground = NA,
    background = NA,
    fontStyle = NA
  )

  end <- bind_rows(template, meta_df, top_df, specs_end)
  end[end$name != "Delete", ]
  alln <- names(end)
  end <- end %>%
    mutate(across(all_of(alln), str_squish))

  end
}


tmtheme2vscode <- function(tminput, output){
  
  # Based in https://github.com/microsoft/vscode-generator-code/blob/6e3f05ab46b6186e588094517764fdf42f21d094/generators/app/generate-colortheme.js#L237C18-L261C2
  mapping <- read_csv("dev/mapping_themes.csv")
  
  get_tmTheme <- read_tmtheme(tminput)
  
  nm <- get_tmTheme |> filter(name == "name") |> pull(value)
  au <- get_tmTheme |> filter(name == "author") |> pull(value)
  thejson <- list(name = nm, author = au)
  
  colorss <- get_tmTheme |> 
    filter(section == "Top-level config") |> 
    select(tm = name, color = value) |> 
    inner_join(mapping) |> 
    select(name = vscode, color)
  
  col_l <- colorss$color |> unlist()
  names(col_l) <- colorss$name |>  unlist()
  col_l <- as.list(col_l)
  
  fg <- col_l$editor.foreground |> unlist() |> tolower()
  tokencols <- get_tmTheme |> 
    filter(section == "Scopes") |> 
    mutate(foreground = ifelse(tolower(foreground) == fg, NA, foreground)) |> 
    select(name, scope, foreground, background, fontStyle) 
  
  tokencols$index <- seq_len(nrow(tokencols))
  tok_g <- tokencols |> 
    group_by(name, foreground, background, fontStyle) |> 
    summarise(sc = paste0(scope, collapse = ", "), minr = min(index)) |> 
    arrange(minr)
  
  
  tok <- list()
  # Create list for tokens
  tok[[1]] <- list(settings = list(background = col_l$editor.background,
                                   foreground = col_l$editor.foreground))
  toJSON(tok,  auto_unbox = TRUE, pretty = TRUE)
  
  ntok <- seq_len(nrow(tok_g))
  
  i <- 1
  for (i in ntok) {
    thiscope <- tok_g[i,]
    thistok <- list(name = thiscope$name, 
                    scope = thiscope$sc,
                    settings = list())
    
    
    dictt <- list()
    fg <- thiscope$foreground |>  unlist()
    bg <- thiscope$background |>  unlist()
    fnt <- thiscope$fontStyle |>  unlist()
    if(!is.na(fg)){
      dictt <- c(dictt, list(foreground = fg))
    }
    if(!is.na(bg)){
      dictt <- c(dictt, list(background = bg))
    }
    if(!is.na(fnt)){
      dictt <- c(dictt, list(fontStyle = fnt))
    }
    if(length(dictt) > 0){
      thistok$settings <- dictt 
      tok [[i+1]] <- thistok
    }
  }
  toJSON(tok, pretty = TRUE)
  
  vs_l <- c(list(tokenColors = tok),list(colors = col_l), thejson)
  
  write_json(vs_l, path = output, auto_unbox = TRUE, pretty = TRUE)
  return(invisible(NULL))
}
