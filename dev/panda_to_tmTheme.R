library(tidyverse)
library(xml2)



init_panda <- read_xml("./vendor/panda/Panda.tmTheme") |>
  as_list()


array <- init_panda$plist$dict$array
length(array)
initsettings <- array[[1]]

# Fill the template
setting <- list(
  dict = initsettings
)
rest <- array[-1]



ntot <- seq_len(length(rest))


i <- 1
for (i in ntot) {
  one <- rest[i]
  message(one$scope)
  dict <- list(
    key = list("name"),
    string = list("")
  )

  onl <- list(
    dict = c(dict, one$dict)
  )


  message(i)
  message(dput(onl))
  setting <- c(setting, onl)
}




build <- init_panda

build$plist$dict$array <- list(setting)

out_f <- paste0("dev/testpanda.tmTheme")

build |>
  xml2::as_xml_document() |>
  write_xml(out_f)
