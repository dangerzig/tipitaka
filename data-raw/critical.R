# This script processes the critical edition data files and creates
# the package datasets for the lemmatized Tipitaka data.
#
# The critical edition is based on PTS with corrections from comparing
# SuttaCentral and VRI editions.

library(usethis)
library(Matrix)

# Set working directory to package root
# (This script should be run from the package root directory)

# ------------------------------------------------------------------------------
# Re-save VRI datasets with xz compression (smaller in tarball)
# ------------------------------------------------------------------------------

message("Re-saving VRI datasets with xz compression...")
for (nm in c("tipitaka_raw", "tipitaka_long", "tipitaka_wide")) {
  e <- new.env()
  load(file.path("data", paste0(nm, ".rda")), envir=e)
  save(list=nm, file=file.path("data", paste0(nm, ".rda")), envir=e, compress="xz")
  message("  ", nm, ": ", file.size(file.path("data", paste0(nm, ".rda"))), " bytes")
}

# ------------------------------------------------------------------------------
# Load sutta-level data
# ------------------------------------------------------------------------------

# tipitaka_suttas_raw: Full text per sutta
tipitaka_suttas_raw <- read.csv(
  "data-raw/critical/tipitaka_suttas_raw.csv",
  stringsAsFactors = FALSE
)
tipitaka_suttas_raw$sutta <- as.character(tipitaka_suttas_raw$sutta)
tipitaka_suttas_raw$nikaya <- as.character(tipitaka_suttas_raw$nikaya)
tipitaka_suttas_raw$text <- as.character(tipitaka_suttas_raw$text)

# tipitaka_suttas_long: Lemma frequencies at sutta granularity
tipitaka_suttas_long <- read.csv(
  "data-raw/critical/tipitaka_suttas_long.csv",
  stringsAsFactors = FALSE
)
tipitaka_suttas_long$word <- as.character(tipitaka_suttas_long$word)
tipitaka_suttas_long$n <- as.integer(tipitaka_suttas_long$n)
tipitaka_suttas_long$total <- as.integer(tipitaka_suttas_long$total)
tipitaka_suttas_long$freq <- as.numeric(tipitaka_suttas_long$freq)
tipitaka_suttas_long$sutta <- as.character(tipitaka_suttas_long$sutta)
tipitaka_suttas_long$nikaya <- as.character(tipitaka_suttas_long$nikaya)

# tipitaka_suttas_wide: Sutta x lemma frequency matrix (sparse)
# The wide CSV is 815MB with 99.3% zeros. Instead of reading it, we build
# a sparse matrix directly from tipitaka_suttas_long (already loaded above).
# As a dgCMatrix with xz compression, this is ~1.2MB.
message("Building tipitaka_suttas_wide as sparse matrix...")
sutta_ids <- sort(unique(tipitaka_suttas_long$sutta))
lemma_ids <- sort(unique(tipitaka_suttas_long$word))

tipitaka_suttas_wide <- sparseMatrix(
  i = match(tipitaka_suttas_long$sutta, sutta_ids),
  j = match(tipitaka_suttas_long$word, lemma_ids),
  x = tipitaka_suttas_long$freq,
  dims = c(length(sutta_ids), length(lemma_ids)),
  dimnames = list(sutta_ids, lemma_ids)
)

# ------------------------------------------------------------------------------
# Save as package data with xz compression
# ------------------------------------------------------------------------------

message("Saving tipitaka_suttas_raw...")
use_data(tipitaka_suttas_raw, overwrite = TRUE, compress = "xz")

message("Saving tipitaka_suttas_long...")
use_data(tipitaka_suttas_long, overwrite = TRUE, compress = "xz")

message("Saving tipitaka_suttas_wide (sparse matrix)...")
use_data(tipitaka_suttas_wide, overwrite = TRUE, compress = "xz")

message("Done! Critical edition data files created.")
