
input <- "tmTheme/cobalt2.tmTheme"

read_tmtheme <- function(input){
require(xml2)
require(tidyverse)


  
tmtheme <- read_xml(input)

tm_lst <- tmtheme |> as_list()

# Metadata
meta_l <- tm_lst$plist$dict

meta_n <- meta_l[names(meta_l) == "key"] |> unlist()
meta_n <- meta_n[meta_n != "settings"]
meta_val <- meta_l[names(meta_l) == "string"] |> unlist()

meta_df <- tibble(section = "tmTheme Metadata",

  name = meta_n,
                 value = meta_val)

array_lst <- tmtheme |> xml_find_first("//array") |> 
  xml_find_all(".//dict") |> 
  as_list()


# Base preproc
array <- tm_lst$plist$dict$array

# Top level vars
topl <- lapply(array, function(x){
  "string" %in% names(x)
}) |>  unlist() |> unname()


# Top level
topv <- array[!topl]$dict$dict
nms_top <- names(topv)
then <- topv[nms_top == "key"] |> unlist()
vl <- topv[nms_top == "string"] |> unlist()

top_df <- tibble(       section = "Top-level config",

  name = then,
       value = vl)

specs <- lapply(array[topl], function(x){

# No spec
  thisloop <- x
nms_no <- names(thisloop)

# Don't want dict
no_spec <- thisloop[nms_no == "key"] |> unlist() 
no_spec <- no_spec[no_spec != "settings"]
vals_no_spec <- thisloop[nms_no == "string"] |> unlist()
names(vals_no_spec) <- no_spec
df_top <- as_tibble_row(vals_no_spec)





# Specification
specs <- thisloop$dict |> lapply(function(x){
  if(length(x) == 0) return("NULL")
  x
})

# Spec df 
nm <- names(specs)
val <- specs[nm == "string"] |> unlist()
names(val) <- specs[nm == "key"] |> unlist()

df_spec <- as_tibble_row(val)

bind_cols(df_top, df_spec)
}) |> 
  bind_rows()

specs[specs == "NULL"] <- NA
# Do unnesting
scopes <- specs$scope

newsc <- lapply(scopes, function(x){
  this <- str_split(x, " |,", simplify = TRUE) |> unlist()
  this[this != ""]
})
specs$scope <- newsc

specs_end <- specs |> 
  unnest(cols = scope)
specs_end$section <- "Scopes"

# Final df
template <- tibble(section = "Delete",
  name = "Delete",
                   scope = NA,
                   value = NA,
                   foreground = NA,
                   background = NA,
                   fontStyle = NA
                   )

end <- bind_rows(template, meta_df, top_df, specs_end)
end[end$name != "Delete", ]
}


parsed_theme <- read_tmtheme(input)
clipr::write_clip(parsed_theme)

