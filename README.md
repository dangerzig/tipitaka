
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tipitaka

<!-- badges: start -->

<!-- badges: end -->

The goal of tipitaka is to allow students and reserachers to apply the
tools of computational linguistics to the ancient Buddhist texts known
as the Tipitaka or Pali Canon.

The Tipitaka is the canonical scripture of Theravadin Buddhists
worldside. It purports to record the direct teachings of the historical
Buddha. It was first recorded in written form in what is now Sri Lanka,
likely around 100 BCE.

The tipitaka package primarily consists of the texts of the Tipitaka in
various electronic forms, plus a few simple functions and data
structures for working with the Pali language.

The version of the Tipitaka included here is based on what’s known as
the Chattha Sangāyana Tipiṭaka version 4.0 (aka, CST4) published by the
Vipassana Research Institute and received from them in April 2020. I
have made a few edits to the CST4 files in creating this package:

  - Where volumes were split across multiple files, they are here are
    combined as a single volume

  - Where volume numbering was inconsistent with the widely-used Pali
    Text Society (PTS) scheme, I have tried to conform with PTS.

  - A very few typos that were found while processing have been
    corrected.

There is no universal script for Pali; traditionally each Buddhist
country ususes its own script to write Pali phoneticaly. This package
uses the Roman script and the diacritical system developed by the PTS.
However, note that the Pali alphabet does NOT follow the alphabetical
ordering of English or other Roman-script languages. For this reason,
tipitaka includes `pali_alphabet` giving the full Pali alphabet in
order, and the functions, `pali_lt`, `pali_gt`, `pali_eq`, and
`pali_sort` for comparing and sorting Pali strings.

## Installation

You can install the released version of tipitaka from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("tipitaka")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("dangerzig/tipitaka")
```

## Example

You can use tipitaka to do clustering analysis of the various books of
the Pali Canon. For example:

<img src="man/figures/README-dendogram-1.png" width="100%" />

You can also create traditional k-means clusters and visualize these
using packages like `factoextra`:

<img src="man/figures/README-kmeans-1.png" width="100%" />

You can also explore the topics of various parts of the Tipitaka using
packges like `wordcloud`:

<img src="man/figures/README-wordclouds-1.png" width="100%" />

Finally, we can look at word frequency by rank:
<img src="man/figures/README-freq-by-word-1.png" width="100%" />
