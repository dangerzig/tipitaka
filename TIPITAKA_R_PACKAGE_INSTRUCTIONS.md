# Tipitaka R Package Update Instructions

This document explains how to update the tipitaka R package to use the new critical edition data from the pali-canon Python library.

## Overview

The existing tipitaka R package (https://github.com/dangerzig/tipitaka) provides:
- `tipitaka_raw` - Full text per VRI volume
- `tipitaka_long` - Word frequencies (word, n, total, freq, book)
- `tipitaka_wide` - Word × book frequency matrix
- `pali_sort()` and related functions for Pāli alphabetical sorting

The update will:
1. Replace VRI-only data with critical edition data (based on PTS with corrections)
2. Add lemmatized versions (grouping inflected forms by dictionary headword)
3. Add sutta-level granularity (not just volume-level)
4. Maintain backwards compatibility with existing API

## Step 1: Generate Data Files

In the pali-canon directory, run:

```python
from pali import Canon

canon = Canon()
canon.export_tipitaka_data("../tipitaka/data-raw/critical/")
```

This generates:
- `tipitaka_raw.csv` - Full text per nikaya
- `tipitaka_long.csv` - Lemma frequencies by nikaya
- `tipitaka_long_words.csv` - Surface form frequencies by nikaya
- `tipitaka_wide.csv` - Lemma × nikaya matrix
- `tipitaka_suttas_long.csv` - Lemma frequencies by sutta
- `tipitaka_suttas_wide.csv` - Lemma × sutta matrix

## Step 2: Update R Package Data

### 2.1 Modify data-raw/DATASET.R

Add new data processing for critical edition:

```r
# Load critical edition data
tipitaka_long_critical <- read.csv("data-raw/critical/tipitaka_long.csv")
tipitaka_wide_critical <- read.csv("data-raw/critical/tipitaka_wide.csv", row.names = 1)
tipitaka_suttas_long <- read.csv("data-raw/critical/tipitaka_suttas_long.csv")

# Save as package data
usethis::use_data(tipitaka_long_critical, overwrite = TRUE)
usethis::use_data(tipitaka_wide_critical, overwrite = TRUE)
usethis::use_data(tipitaka_suttas_long, overwrite = TRUE)
```

### 2.2 Create New Data Documentation

In `R/tipitaka-docs.R`, add documentation for new datasets:

```r
#' Critical Edition Word Frequencies (Long Format)
#'
#' Lemma frequencies from the critical edition of the Pāli Canon.
#' Uses lemmatization from Digital Pāli Dictionary to group inflected forms.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{word}{Lemma (dictionary headword)}
#'   \item{n}{Count of this lemma in this nikaya}
#'   \item{total}{Total lemmas in this nikaya}
#'   \item{freq}{Frequency (n/total)}
#'   \item{book}{Nikaya abbreviation (dn, mn, sn, an, kn)}
#' }
#'
#' @source Critical edition based on PTS with corrections from SC/VRI comparison
"tipitaka_long_critical"

#' Sutta-Level Word Frequencies
#'
#' Lemma frequencies at sutta granularity for detailed analysis.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{word}{Lemma (dictionary headword)}
#'   \item{n}{Count in this sutta}
#'   \item{total}{Total lemmas in this sutta}
#'   \item{freq}{Frequency (n/total)}
#'   \item{sutta}{Sutta ID (e.g., "dn1", "mn1", "sn1.1")}
#'   \item{nikaya}{Nikaya abbreviation}
#' }
"tipitaka_suttas_long"
```

### 2.3 Backwards Compatibility

Keep existing datasets unchanged:
- `tipitaka_raw`, `tipitaka_long`, `tipitaka_wide` continue to use VRI data
- Add new `*_critical` and `*_suttas` variants

Or, update existing data and add `*_vri` variants for backwards compatibility:
- Rename current data to `tipitaka_long_vri`, etc.
- Use critical edition for main `tipitaka_long`
- Document the change in NEWS.md

## Step 3: Add New Functionality

### 3.1 Lemma Search Function

```r
#' Search for lemma occurrences
#'
#' @param lemma Character string of the lemma to search
#' @param data Dataset to search (default: tipitaka_suttas_long)
#' @return Data frame of occurrences with sutta and frequency info
#' @export
search_lemma <- function(lemma, data = tipitaka_suttas_long) {
  data[data$word == lemma, ]
}
```

### 3.2 Sutta Text Retrieval

```r
#' Get text of a specific sutta
#'
#' @param sutta_id Sutta ID (e.g., "dn1", "mn1")
#' @return Character string of sutta text
#' @export
get_sutta <- function(sutta_id) {
  # Implementation depends on how raw text is stored
  # May need to add tipitaka_suttas_raw dataset
}
```

## Step 4: Update Documentation

### 4.1 Update README.Rmd

Add examples showing new functionality:

```r
library(tipitaka)

# Lemma-based clustering (better than surface forms)
dist_m <- dist(tipitaka_wide_critical)
cluster <- hclust(dist_m)
plot(cluster)

# Sutta-level analysis
sutta_dist <- dist(tipitaka_suttas_wide)
sutta_cluster <- hclust(sutta_dist)

# Search for specific lemmas
dhamma_occurrences <- search_lemma("dhamma")
head(dhamma_occurrences)
```

### 4.2 Update Vignettes

Create or update vignette showing:
- Comparison of surface forms vs lemmas for clustering
- Sutta-level vs volume-level analysis
- How critical edition differs from VRI

## Step 5: Testing

1. Run `devtools::check()` to ensure package builds
2. Compare clustering results: old VRI data vs new critical edition
3. Verify backwards compatibility with existing code

## Step 6: CRAN Submission

1. Update version number in DESCRIPTION
2. Update NEWS.md with changes
3. Run `devtools::check(cran = TRUE)`
4. Submit via `devtools::release()`

## Data Structure Summary

| Dataset | Rows | Columns | Description |
|---------|------|---------|-------------|
| tipitaka_raw | 5 | book, book_name, text | Full text per nikaya |
| tipitaka_long | ~70k | word, n, total, freq, book | Lemma freq by nikaya |
| tipitaka_wide | 5 | book + ~10k words | Freq matrix (nikaya × lemma) |
| tipitaka_suttas_long | ~5M | word, n, total, freq, sutta, nikaya | Lemma freq by sutta |
| tipitaka_suttas_wide | ~5k | sutta + ~10k words | Freq matrix (sutta × lemma) |

## Key Differences from Original Package

1. **Text source**: PTS-based critical edition instead of VRI Chaṭṭha Saṅgāyana
2. **Lemmatization**: Groups inflected forms (e.g., "buddhassa", "buddho" → "buddha")
3. **Granularity**: Sutta-level data available, not just volume-level
4. **Corrections**: ~500 scribal errors corrected based on witness comparison
5. **Coverage**: All 5 nikāyas of Sutta Piṭaka (DN, MN, SN, AN, KN)

## Contact

Data generated from: https://github.com/dangerzig/pali-canon
Using the `pali` Python library's `export_tipitaka_data()` function.
