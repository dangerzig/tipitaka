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
#' scripture for Theravadin Buddhists worldwide. This package
#' includes the VRI (Vipassana Research Institute) Chattha
#' Sangayana edition along with tools for working with Pali text.
#'
#' For a lemmatized critical edition of the Tipitaka with
#' sutta-level granularity, see the companion package
#' \pkg{tipitaka.critical}.
#'
#' @section Datasets:
#' \itemize{
#'   \item tipitaka_raw: the complete text of the Tipitaka (VRI)
#'   \item tipitaka_long: the complete Tipitaka in "long" form (VRI)
#'   \item tipitaka_wide: the complete Tipitaka in "wide" form (VRI)
#'   \item tipitaka_names: the names of each book of the Tipitaka
#'   \item sutta_pitaka: the names of each volume of the Sutta Pitaka
#'   \item vinaya_pitaka: the names of each volume of the Vinaya Pitaka
#'   \item abhidhamma_pitaka: the names of each volume of the Abhidhamma Pitaka
#'   \item pali_alphabet: the complete Pali alphabet in traditional order
#'   \item pali_stop_words: a set of "stop words" for Pali
#' }
#'
#' @section Tools:
#' Functions for working with Pali text:
#' \itemize{
#'   \item pali_lt: less-than function for Pali strings
#'   \item pali_gt: greater-than function for Pali strings
#'   \item pali_eq: equals function for Pali strings
#'   \item pali_sort: sorting function for vectors of Pali strings
#' }
#'
#' @name tipitaka
#' @useDynLib tipitaka, .registration = TRUE
"_PACKAGE"


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
#' \donttest{
#' # Clean up the Unicode characters to make things more readable:
#' tipitaka_names$name <-
#'   stringi::stri_unescape_unicode(tipitaka_names$name)
#' }
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
#' \donttest{
#' # Clean up the Unicode characters to make things more readable:
#' sutta_pitaka$name <-
#'   stringi::stri_unescape_unicode(sutta_pitaka$name)
#' }
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
#' \donttest{
#' # Clean up the Unicode characters to make things more readable:
#' vinaya_pitaka$name <-
#'   stringi::stri_unescape_unicode(vinaya_pitaka$name)
#' }
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
#' \donttest{
#' # Clean up the Unicode characters to make things more readable:
#' abhidhamma_pitaka$name <-
#'   stringi::stri_unescape_unicode(abhidhamma_pitaka$name)
#' }
#'
#' # Count all the words in the Abhidhamma Pitaka:
#' sum(tipitaka_long[tipitaka_long$book %in% abhidhamma_pitaka$book, "n"])
#'
"abhidhamma_pitaka"



#' Tentative set of "stop words" for Pali
#'
#' A list of all declinables and particles from the PTS
#' Pali-English Dictionary.
#'
#' @examples
#' # Show top content words in the Tipitaka (excluding stop words)
#' content_words <- tipitaka_long[!tipitaka_long$word %in% pali_stop_words$word, ]
#' head(content_words[order(-content_words$n), ], 10)
#'
#' @source \url{https://dsal.uchicago.edu/dictionaries/pali/}
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
