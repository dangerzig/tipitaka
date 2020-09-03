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
#' scriptire for Therevadin Buddhists worldwide. This version
#' is largely taken from the Chaṭṭha Saṅgāyana Tipiṭaka
#' version 4.0 com;iled by the Vispassana Research Institute,
#' although edits have been made to conform to the numbering
#' used by the Pali Text Society. This package provides both
#' data and tools to facilitate the analysis of these ancient
#' Pali texts.
#'
#' @section Data:
#' Several data sets are included:
#' \itemize{
#'   \item tipitaka_raw: the complete text of the Tipitaka
#'   \item tipitaka_long: the complete Tipitaka in "long" form
#'   \item tipitaka_wide: the complete Tipitaka in "wide" form
#'   \item tipitaka_names: the names of each book of the Tipitaka
#'   \item sutta_pitaka: the names of each volume of the Sutta Pitaka
#'   \item vinaya_pitaka: the names of each volume of the Vinaya Pitaka
#'   \item abhidhamma_pitaka: the names of each volume of the Abhidhamma Pitak
#'   \item sati_sutta_raw: the Mahāsatipaṭṭhāna Sutta text
#'   \item sati_sutta_long: the Mahāsatipaṭṭhāna Sutta in "long" form
#'   \item pali_alphabet: the complete pali alphabet in traditional order
#'   \item pali_stop_words: a set of "stop words" for Pali
#'   }
#'
#' @section Tools:
#' A few useful functions are provided for working with Pali text:
#' \itemize{
#'   \item pali_lt: less-than function for Pali strings
#'   \item pali-gt: greater-than function for Pali strings
#'   \item pali-eq: equals function for Pali strings
#'   \item pali-sort: sorting function for vectors of pali strings
#' }
#'
#' @docType package
#' @name tipitaka
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
#' @source Vipassana Research Institute, CST4
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
#' @source Vipassana Research Institute, CST4
"tipitaka_long"


#' Tipitaka in "wide" form
#'
#' Every word of every volume of the Tipitaka, with one word per
#' column and one book per line. Each cell is the frequency at
#' which that word appears in that book.
#'
#'
#' @source Vipassana Research Institute, CST4
"tipitaka_wide"


#' Names of each book of the Tipitaka, both abbreviated and
#' in full.
#'
#' @format A tibble with the variables:
#' \describe{
#'   \item{book}{Abbreviated title}
#'   \item{name}{Full title}
#' }
#'
"tipitaka_names"


#' All the books of the Sutta Pitaka
#'
#' A subset of tipitaka_names consisting of only the books of
#' the Sutta Pitaka.
#'
#' @format A tibble with the variables:
#' \describe{
#'   \item{book}{Abbreviated title}
#'   \item{name}{Full title}
#'}
"sutta_pitaka"


#' All the books of the Vinaya Pitaka
#'
#' A subset of tipitaka_names consisting of only the books of
#' the Vinaya Pitaka.
#'
#' @format A tibble with the variables:
#' \describe{
#'   \item{book}{Abbreviated title}
#'   \item{name}{Full title}
#'}
"vinaya_pitaka"


#' All the books of the Abhidhamma Pitaka
#'
#' A subset of tipitaka_names consisting of only the books of
#' the Abhidhamma Pitaka.
#'
#' @format A tibble with the variables:
#' \describe{
#'
#'   \item{book}{Abbreviated title}
#'   \item{name}{Full title}
#'}
"abhidhamma_pitaka"



#' Mahāsatipaṭṭhāna Sutta in "long" form
#'
#' The Mahāsatipaṭṭhāna Sutta or Discourse on the Establishing
#' of Mindfulness in "long" form.
#'
#' @source Vipassana Research Institute, CST4
"sati_sutta_long"

#' Mahāsatipaṭṭhāna Sutta text in raw form
#'
#' The unprocessed text of the Mahāsatipaṭṭhāna Sutta
#'
#' @format A tibble with the variable:
#' \describe{
#' \item{text}{Complete text}
#' }
#'
#' @source Vipassana Research Institute, CST4
"sati_sutta_raw"


#' Tentative set of "stop words" for Pali
#'
#' A list of all declinables and particles from the PTS
#' Pali-English Dictionary.
#'
#' @source \url{https://dsalsrv04.uchicago.edu/dictionaries/pali/}
"pali_stop_words"


#' Pali alphabet in order
#'
#' @format The Pali alphabet in traditional order.
"pali_alphabet"

