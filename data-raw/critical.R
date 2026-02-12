## Re-save VRI datasets with xz compression (smaller tarball)
##
## Run from ~/tipitaka:
##   Rscript data-raw/critical.R

library(usethis)

message("Re-saving VRI datasets with xz compression...")
for (nm in c("tipitaka_raw")) {
  e <- new.env()
  load(file.path("data", paste0(nm, ".rda")), envir=e)
  save(list=nm, file=file.path("data", paste0(nm, ".rda")), envir=e, compress="xz")
  message("  ", nm, ": ", file.size(file.path("data", paste0(nm, ".rda"))), " bytes")
}

message("Done!")
