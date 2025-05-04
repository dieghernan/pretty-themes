input <- "./vendor/night-owl/notest.tmTheme"

# See also (Rstudio Only)
# tm <- .rs.parseTmTheme(input)
#
# supportedScopes <- list()
# supportedScopes[["keyword"]] <- "keyword"
# supportedScopes[["keyword.operator"]] <- "keyword.operator"
# supportedScopes[["keyword.other.unit"]] <- "keyword.other.unit"
# supportedScopes[["constant"]] <- "constant"
# supportedScopes[["constant.language"]] <- "constant.language"
# supportedScopes[["constant.library"]] <- "constant.library"
# supportedScopes[["constant.numeric"]] <- "constant.numeric"
# supportedScopes[["constant.character"]] <- "constant.character"
# supportedScopes[["constant.character.escape"]] <- "constant.character.escape"
# supportedScopes[["constant.character.entity"]] <- "constant.character.entity"
# supportedScopes[["constant.other"]] <- "constant.other"
# supportedScopes[["support"]] <- "support"
# supportedScopes[["support.function"]] <- "support.function"
# supportedScopes[["support.function.dom"]] <- "support.function.dom"
# supportedScopes[["support.function.firebug"]] <- "support.firebug"
# supportedScopes[["support.function.constant"]] <- "support.function.constant"
# supportedScopes[["support.constant"]] <- "support.constant"
# supportedScopes[["support.constant.property-value"]] <- "support.constant.property-value"
# supportedScopes[["support.class"]] <- "support.class"
# supportedScopes[["support.type"]] <- "support.type"
# supportedScopes[["support.other"]] <- "support.other"
# supportedScopes[["function"]] <- "function"
# supportedScopes[["function.buildin"]] <- "function.buildin"
# supportedScopes[["storage"]] <- "storage"
# supportedScopes[["storage.type"]] <- "storage.type"
# supportedScopes[["invalid"]] <- "invalid"
# supportedScopes[["invalid.illegal"]] <- "invalid.illegal"
# supportedScopes[["invalid.deprecated"]] <- "invalid.deprecated"
# supportedScopes[["string"]] <- "string"
# supportedScopes[["string.regexp"]] <- "string.regexp"
# supportedScopes[["comment"]] <- "comment"
# supportedScopes[["comment.documentation"]] <- "comment.doc"
# supportedScopes[["comment.documentation.tag"]] <- "comment.doc.tag"
# supportedScopes[["variable"]] <- "variable"
# supportedScopes[["variable.language"]] <- "variable.language"
# supportedScopes[["variable.parameter"]] <- "variable.parameter"
# supportedScopes[["meta"]] <- "meta"
# supportedScopes[["meta.tag.sgml.doctype"]] <- "xml-pe"
# supportedScopes[["meta.tag"]] <- "meta.tag"
# supportedScopes[["meta.selector"]] <- "meta.selector"
# supportedScopes[["entity.other.attribute-name"]] <- "entity.other.attribute-name"
# supportedScopes[["entity.name.function"]] <- "entity.name.function"
# supportedScopes[["entity.name"]] <- "entity.name"
# supportedScopes[["entity.name.tag"]] <- "entity.name.tag"
# supportedScopes[["markup.heading"]] <- "markup.heading"
# supportedScopes[["markup.heading.1"]] <- "markup.heading.1"
# supportedScopes[["markup.heading.2"]] <- "markup.heading.2"
# supportedScopes[["markup.heading.3"]] <- "markup.heading.3"
# supportedScopes[["markup.heading.4"]] <- "markup.heading.4"
# supportedScopes[["markup.heading.5"]] <- "markup.heading.5"
# supportedScopes[["markup.heading.6"]] <- "markup.heading.6"
# supportedScopes[["markup.list"]] <- "markup.list"
# supportedScopes[["collab.user1"]] <- "collab.user1"
# supportedScopes[["marker-layer.active_debug_line"]] <- "marker-layer .active_debug_line"
# # Add one scope
# supportedScopes[["support.function.builtin.shell"]] <- "support.function.builtin.shell"
#
# this <- .rs.extractStyles(tm, supportedScopes)
# this$styles



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
parsed_theme <- read_tmtheme(input)

clipr::write_clip(parsed_theme)
