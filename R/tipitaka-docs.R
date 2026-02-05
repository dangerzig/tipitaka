# Tipitaka (Pali Canon)
#
# This file documents the multiple versions of the complete
# Pali Canon of Therevadin Buddhism, also know (in Pali)
# as the Tipitaka, that are included in this package.
#
# It is provided in both "long" and "wide" formats, as each are
# useful for different types of analysis, and conversion
# between the two can be slow and error-prone.


#' tipitaka: A package for exploring the Pali Canon in R.
#'
#' The package tipitaka provides access to the complete Pali
#' Canon, or Tipitaka, from R. The Tipitaka is the canonical
#' scripture for Therevadin Buddhists worldwide. This package
#' includes both the original VRI (Vipassana Research Institute)
#' data and a new critical edition based on PTS with corrections.
#' The critical edition includes lemmatization (grouping inflected
#' forms by dictionary headword) and sutta-level granularity.
#'
#' @section VRI Data (Original):
#' The original datasets from the Chattha Sangayana Tipitaka:
#' \itemize{
#'   \item tipitaka_raw: the complete text of the Tipitaka (VRI)
#'   \item tipitaka_long: the complete Tipitaka in "long" form (VRI)
#'   \item tipitaka_wide: the complete Tipitaka in "wide" form (VRI)
#'   \item tipitaka_names: the names of each book of the Tipitaka
#'   \item sutta_pitaka: the names of each volume of the Sutta Pitaka
#'   \item vinaya_pitaka: the names of each volume of the Vinaya Pitaka
#'   \item abhidhamma_pitaka: the names of each volume of the Abhidhamma Pitaka
#'   \item sati_sutta_raw: the Mahasatipatthana Sutta text
#'   \item sati_sutta_long: the Mahasatipatthana Sutta in "long" form
#'   \item pali_alphabet: the complete Pali alphabet in traditional order
#'   \item pali_stop_words: a set of "stop words" for Pali
#' }
#'
#' @section Critical Edition Data (New):
#' Lemmatized data from the critical edition (Sutta Pitaka only):
#' \itemize{
#'   \item tipitaka_long_critical: lemma frequencies by nikaya
#'   \item tipitaka_wide_critical: lemma x nikaya frequency matrix
#'   \item tipitaka_raw_critical: full text per nikaya
#'   \item tipitaka_long_words: surface form frequencies by nikaya
#'   \item tipitaka_suttas_long: lemma frequencies by sutta
#'   \item tipitaka_suttas_wide: lemma x sutta frequency matrix
#' }
#'
#' @section Tools:
#' Functions for working with Pali text:
#' \itemize{
#'   \item pali_lt: less-than function for Pali strings
#'   \item pali_gt: greater-than function for Pali strings
#'   \item pali_eq: equals function for Pali strings
#'   \item pali_sort: sorting function for vectors of Pali strings
#'   \item search_lemma: search for lemma occurrences across suttas
#' }
#'
#' @docType package
#' @name tipitaka
#' @useDynLib tipitaka
NULL


#' Tipitaka text in raw form
#'
#' The unprocessed text of the Tipitaka, with one row per volume.
#'
#' @format A tibble with the variables:
#' \describe{
#' \item{text}{Text of each Tipitaka volume}
#' \item{book}{Abbreviated book name of each volume}
#' }
#'
#' @source Vipassana Research Institute, CST4, April 2020
"tipitaka_raw"


#' Tipitaka in "long" form
#'
#' Every word of every volume of the Tipitaka, with one word per
#' volume per line.
#'
#' @format A tibble with the variables:
#' \describe{
#' \item{word}{Pali word}
#' \item{n}{Number of time this word appears in this book}
#' \item{total}{Ttal number of words in this book}
#' \item{freq}{Frequency with which this word appears in this book}
#' \item{book}{Abbreviated book name}
#' }
#'
#' @source Vipassana Research Institute, CST4, April 2020
"tipitaka_long"


#' Tipitaka in "wide" form
#'
#' Every word of every volume of the Tipitaka, with one word per
#' column and one book per line. Each cell is the frequency at
#' which that word appears in that book.
#'
#'
#' @source Vipassana Research Institute, CST4, April 2020
"tipitaka_wide"


#' Names of each book of the Tipitaka, both abbreviated and
#' in full. These are easier to read if you call \code{pali_string_fix() first}.
#'
#' @format A tibble with the variables:
#' \describe{
#'   \item{book}{Abbreviated title}
#'   \item{name}{Full title}
#' }
#'
#' @examples
#' # Clean up the Unicode characters to make things more readble:
#' tipitaka_names$name <-
#'   stringi::stri_unescape_unicode(tipitaka_names$name)
#'
"tipitaka_names"


#' All the books of the Sutta Pitaka
#'
#' A subset of tipitaka_names consisting of only the books of
#' the Sutta Pitaka. These are easier to read if you call
#' \code{stringi::stri_unescape_unicode} first.
#'
#' @format A tibble with the variables:
#' \describe{
#'   \item{book}{Abbreviated title}
#'   \item{name}{Full title}
#' }
#'
#' @examples
#' # Clean up the Unicode characters to make things more readble:
#' sutta_pitaka$name <-
#'   stringi::stri_unescape_unicode(sutta_pitaka$name)
#' # Count all the words in the Suttas:
#' sum(
#'   unique(
#'     tipitaka_long[tipitaka_long$book %in% sutta_pitaka$book, "total"]))
#'
#' # Count another way:
#' sum(tipitaka_long[tipitaka_long$book %in% sutta_pitaka$book, "n"])
#'
#' # Create a tibble of just the Suttas
#' sutta_wide <-
#'   tipitaka_wide[row.names(tipitaka_wide) %in% sutta_pitaka$book,]
#'
"sutta_pitaka"


#' All the books of the Vinaya Pitaka
#'
#' A subset of tipitaka_names consisting of only the books of
#' the Vinaya Pitaka. These are easier to read if you call
#' \code{stringi::stri_unescape_unicode} first.
#'
#' @format A tibble with the variables:
#' \describe{
#'   \item{book}{Abbreviated title}
#'   \item{name}{Full title}
#'}
#'
#' @examples
#' # Clean up the Unicode characters to make things more readble:
#' vinaya_pitaka$name <-
#'   stringi::stri_unescape_unicode(vinaya_pitaka$name)
#'
#' # Count all the words in the Vinaya Pitaka:
#' sum(tipitaka_long[tipitaka_long$book %in% vinaya_pitaka$book, "n"])
#'
"vinaya_pitaka"


#' All the books of the Abhidhamma Pitaka
#'
#' A subset of tipitaka_names consisting of only the books of
#' the Abhidhamma Pitaka. These are easier to read if you call
#' \code{pali_string_fix() first}.
#'
#' @format A tibble with the variables:
#' \describe{
#'
#'   \item{book}{Abbreviated title}
#'   \item{name}{Full title}
#'}\
#'
#' @examples
#' # Clean up the Unicode characters to make things more readble:
#' abhidhamma_pitaka$name <-
#'   stringi::stri_unescape_unicode(abhidhamma_pitaka$name)
#'
#' # Count all the words in the Abhidhamma Pitaka:
#' sum(tipitaka_long[tipitaka_long$book %in% abhidhamma_pitaka$book, "n"])
#'
"abhidhamma_pitaka"



#' Mahāsatipatthāna Sutta in "long" form
#'
#' The Mahāsatipatthāna Sutta or Discourse on the Establishing
#' of Mindfulness in "long" form.
#'
#' @source Vipassana Research Institute, CST4, April 2020
"sati_sutta_long"

#' Mahāsatipatthāna Sutta text in raw form
#'
#' The unprocessed text of the Mahāsatipatthāna Sutta
#'
#' @format A tibble with the variable:
#' \describe{
#' \item{text}{Complete text}
#' }
#'
#' @source Vipassana Research Institute, CST4, April 2020
"sati_sutta_raw"


#' Tentative set of "stop words" for Pali
#'
#' A list of all declinables and particles from the PTS
#' Pali-English Dictionary.
#'
#' @examples
#' # Find most common words in the Mahāsatipatthāna Sutta excluding stop words
#' library(dplyr)
#' sati_sutta_long %>%
#'   anti_join(pali_stop_words, by = "word") %>%
#'   arrange(desc(freq))
#'
#' @source \url{https://dsalsrv04.uchicago.edu/dictionaries/pali/}
"pali_stop_words"


#' Pali alphabet in order
#'
#' @format The Pali alphabet in traditional order.
#'
#' @examples
#' # Returns TRUE because a comes before b in Pali:
#' match("a", pali_alphabet) < match("b", pali_alphabet)
#' # Returns FALSE beceause c comes before b in Pali
#' match("b", pali_alphabet) < match("c", pali_alphabet)
#'
"pali_alphabet"


# =============================================================================
# Critical Edition Datasets
# =============================================================================

#' Critical Edition Lemma Frequencies (Long Format)
#'
#' Lemma frequencies from the critical edition of the Pali Canon (Sutta Pitaka).
#' Uses lemmatization from Digital Pali Dictionary to group inflected forms
#' by dictionary headword (e.g., "buddhassa", "buddho" -> "buddha").
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
#' @source Critical edition based on PTS with corrections from SC/VRI comparison.
#'   Generated using the pali-canon Python library.
#'
#' @examples
#' # Find most common lemmas in Digha Nikaya
#' dn_lemmas <- tipitaka_long_critical[tipitaka_long_critical$book == "dn", ]
#' head(dn_lemmas[order(-dn_lemmas$freq), ])
#'
"tipitaka_long_critical"


#' Critical Edition Word Frequencies (Surface Forms)
#'
#' Surface form (non-lemmatized) word frequencies from the critical edition.
#' Useful for comparing with lemmatized data or for analyses where
#' inflected forms should be kept separate.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{word}{Surface form (as appears in text)}
#'   \item{n}{Count of this word in this nikaya}
#'   \item{total}{Total words in this nikaya}
#'   \item{freq}{Frequency (n/total)}
#'   \item{book}{Nikaya abbreviation (dn, mn, sn, an, kn)}
#' }
#'
#' @source Critical edition based on PTS with corrections from SC/VRI comparison.
#'
"tipitaka_long_words"


#' Critical Edition Frequency Matrix (Wide Format)
#'
#' Lemma x nikaya frequency matrix from the critical edition.
#' Each row is a nikaya, each column is a lemma, and values are frequencies.
#' Useful for clustering, PCA, and other multivariate analyses.
#'
#' @format A data frame with nikayas as row names and lemmas as columns.
#'   Values are word frequencies (proportions).
#'
#' @source Critical edition based on PTS with corrections from SC/VRI comparison.
#'
#' @examples
#' # Hierarchical clustering of nikayas based on vocabulary
#' dist_m <- dist(tipitaka_wide_critical)
#' hc <- hclust(dist_m)
#' plot(hc, main = "Nikaya Clustering by Vocabulary")
#'
"tipitaka_wide_critical"


#' Critical Edition Raw Text
#'
#' Full text of each nikaya from the critical edition.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{book}{Nikaya abbreviation (dn, mn, sn, an, kn)}
#'   \item{book_name}{Full nikaya name}
#'   \item{text}{Complete text of the nikaya}
#' }
#'
#' @source Critical edition based on PTS with corrections from SC/VRI comparison.
#'
"tipitaka_raw_critical"


#' Sutta-Level Lemma Frequencies
#'
#' Lemma frequencies at sutta granularity for detailed analysis.
#' Allows analysis of individual suttas rather than entire nikayas.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{word}{Lemma (dictionary headword)}
#'   \item{n}{Count of this lemma in this sutta}
#'   \item{total}{Total lemmas in this sutta}
#'   \item{freq}{Frequency (n/total)}
#'   \item{sutta}{Sutta ID (e.g., "dn1", "mn1", "sn1.1")}
#'   \item{nikaya}{Nikaya abbreviation (dn, mn, sn, an, kn)}
#' }
#'
#' @source Critical edition based on PTS with corrections from SC/VRI comparison.
#'
#' @examples
#' # Find all suttas containing the lemma "nibbana"
#' nibbana <- tipitaka_suttas_long[tipitaka_suttas_long$word == "nibbana", ]
#' head(nibbana[order(-nibbana$freq), ])
#'
#' # Or use the search_lemma() function:
#' # search_lemma("nibbana")
#'
"tipitaka_suttas_long"


#' Sutta-Level Frequency Matrix (Wide Format)
#'
#' Lemma x sutta frequency matrix for detailed multivariate analysis.
#' Each row is a sutta, each column is a lemma, and values are frequencies.
#'
#' @format A data frame with sutta IDs as row names and lemmas as columns.
#'   Values are word frequencies (proportions).
#'
#' @source Critical edition based on PTS with corrections from SC/VRI comparison.
#'
#' @note This dataset is large (~5,765 suttas x ~11,410 lemmas).
#'
#' @examples
#' # Cluster suttas from Digha Nikaya
#' dn_suttas <- tipitaka_suttas_wide[grep("^dn", rownames(tipitaka_suttas_wide)), ]
#' dist_m <- dist(dn_suttas)
#' hc <- hclust(dist_m)
#' plot(hc, main = "DN Sutta Clustering")
#'
"tipitaka_suttas_wide"

