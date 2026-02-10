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
# Load critical edition data (lemmatized)
# ------------------------------------------------------------------------------

# tipitaka_long_critical: Lemma frequencies by nikaya
# This groups inflected forms by dictionary headword using DPD lemmatization
tipitaka_long_critical <- read.csv(
  "data-raw/critical/tipitaka_long.csv",
  stringsAsFactors = FALSE
)
# Ensure proper column types
tipitaka_long_critical$word <- as.character(tipitaka_long_critical$word)
tipitaka_long_critical$n <- as.integer(tipitaka_long_critical$n)
tipitaka_long_critical$total <- as.integer(tipitaka_long_critical$total)
tipitaka_long_critical$freq <- as.numeric(tipitaka_long_critical$freq)
tipitaka_long_critical$book <- as.character(tipitaka_long_critical$book)

# tipitaka_long_words: Surface form frequencies by nikaya (non-lemmatized)
# Useful for comparison with lemmatized data
tipitaka_long_words <- read.csv(
  "data-raw/critical/tipitaka_long_words.csv",
  stringsAsFactors = FALSE
)
tipitaka_long_words$word <- as.character(tipitaka_long_words$word)
tipitaka_long_words$n <- as.integer(tipitaka_long_words$n)
tipitaka_long_words$total <- as.integer(tipitaka_long_words$total)
tipitaka_long_words$freq <- as.numeric(tipitaka_long_words$freq)
tipitaka_long_words$book <- as.character(tipitaka_long_words$book)

# tipitaka_wide_critical: Lemma x nikaya frequency matrix
tipitaka_wide_critical <- read.csv(
  "data-raw/critical/tipitaka_wide.csv",
  row.names = 1,
  stringsAsFactors = FALSE,
  check.names = FALSE
)

# tipitaka_raw_critical: Full text per nikaya
tipitaka_raw_critical <- read.csv(
  "data-raw/critical/tipitaka_raw.csv",
  stringsAsFactors = FALSE
)
tipitaka_raw_critical$book <- as.character(tipitaka_raw_critical$book)
tipitaka_raw_critical$book_name <- as.character(tipitaka_raw_critical$book_name)
tipitaka_raw_critical$text <- as.character(tipitaka_raw_critical$text)

# ------------------------------------------------------------------------------
# Load sutta-level data
# ------------------------------------------------------------------------------

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

message("Saving tipitaka_long_critical...")
use_data(tipitaka_long_critical, overwrite = TRUE, compress = "xz")

message("Saving tipitaka_long_words...")
use_data(tipitaka_long_words, overwrite = TRUE, compress = "xz")

message("Saving tipitaka_wide_critical...")
use_data(tipitaka_wide_critical, overwrite = TRUE, compress = "xz")

message("Saving tipitaka_raw_critical...")
use_data(tipitaka_raw_critical, overwrite = TRUE, compress = "xz")

message("Saving tipitaka_suttas_long...")
use_data(tipitaka_suttas_long, overwrite = TRUE, compress = "xz")

message("Saving tipitaka_suttas_wide (sparse matrix)...")
use_data(tipitaka_suttas_wide, overwrite = TRUE, compress = "xz")

message("Done! Critical edition data files created.")
