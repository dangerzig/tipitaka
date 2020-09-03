# Pali Helper Functions
#
# Here are some helper functions for working with Pali.
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'

library(stringr)
library(stringi)

# CRAN packages can't have Unicode characters, so the strings
# below are escaped using stringi::stri_escape_unicode(). Here
# are the originals for reference:
# pali_vowels <- c("a", "ā", "i", "ī", "u", "ū", "e", "o")
# pali_consonants <- c("k", "kh", "g", "gh", "ṅ",
#                      "c", "ch", "j", "jh", "ñ",
#                      "ṭ", "ṭh", "ḍ", "ḍh", "ṇ",
#                      "t", "th", "d", "dh", "n",
#                      "p", "ph", "b", "bh", "m",
#                      "y", "r", "l", "v", "s", "h", "ḷ", "ṃ")

pali_vowels <-
  c("a", "\u0101", "i", "\u012b", "u", "\u016b", "e", "o")
pali_consonants <-
  c("k", "kh", "g", "gh", "\u1e45",
    "c", "ch", "j", "jh", "\u00f1",
    "\u1e6d", "\u1e6dh", "\u1e0d", "\u1e0dh", "\u1e47",
    "t", "th", "d", "dh", "n",
    "p", "ph", "b", "bh", "m",
    "y", "r", "l", "v", "s", "h", "\u1e37", "\u1e43")

pali_alphabet <-c(pali_vowels, pali_consonants)

# This is just an internal helper function to break Pali words
# into a vector of letters, respecting the fact that 'dh',
# 'kh', etc. are considered single letters in Pali
explode <- function(pali_word) {
  if (stringr::str_length(pali_word) < 2) {
    return(stringr::str_sub(pali_word, 1, 1))
  }
  else if ((stringr::str_sub(pali_word, 2, 2) == "h") &
           (stringr::str_sub(pali_word, 1, 2) %in% pali_consonants)) {
    return(c(stringr::str_sub(pali_word, 1, 2),
             explode(stringr::str_sub(pali_word, 3))))
  }
  else {
    return(c(stringr::str_sub(pali_word, 1, 1),
             explode(stringr::str_sub(pali_word, 2))))
  }
}

#' Less-than (<) comparison function for Pali words
#'
#' Note that all Pali string comparisons are case-insensitive.
#' Also non-Pali characters are placed at the end of the
#' alphabet and are considered equivalent to each other.
#'
#' @param word1 A first Pali word as a string
#' @param word2 A second Pali words as a string
#' @return TRUE if word1 comes before word2 alphabetically
#' @export
pali_lt <- function(word1, word2) {
  temp1 <- explode(tolower(word1))
  temp2 <- explode(tolower(word2))
  for (i in c(1:length(temp1))) {
    if (i > length(temp2)) {
      return(FALSE)
    }
    else if (match(temp1[i], pali_alphabet,
                   nomatch = length(pali_alphabet) + 1) <
             match(temp2[i], pali_alphabet,
                   nomatch = length(pali_alphabet) + 1)) {
      return(TRUE)
    } else if (match(temp1[i], pali_alphabet,
                     nomatch = length(pali_alphabet) + 1) >
               match(temp2[i], pali_alphabet,
                     nomatch = length(pali_alphabet) + 1)) {
          return(FALSE)
    }
  }
  if (stringr::str_length(word1) < stringr::str_length(word2))
    return(TRUE)
  else
    return(FALSE)
}

#' Equal (==) comparison function for Pali words
#'
#' Note that all Pali string comparisons are case-insensitive.
#'
#' @param word1 A first Pali word as a string
#' @param word2 A second Pali word as a string
#' @return TRUE if word1 and word2 are the same
#' @export
pali_eq <- function(word1, word2) {
  return (tolower(word1) == tolower(word2))
}


#' Greater-than (>) comparison function for Pali words
#'
#' Note that all Pali string comparisons are case-insensitive.
#' #' Also non-Pali characters are placed at the end of the
#' alphabet and are considered equivalent to each other.
#'
#' @param word1 A first Pali word as a string
#' @param word2 A second Pali word as a string
#' @return TRUE if word1 comes after word2 alphabetically
#' @export
pali_gt <- function(word1, word2) {
  temp1 <- explode(tolower(word1))
  temp2 <- explode(tolower(word2))
  for (i in c(1:length(temp1))) {
    if (i > length(temp2)) {
      return(TRUE)
    }
    else if (match(temp1[i], pali_alphabet,
                   nomatch = length(pali_alphabet) + 1) >
             match(temp2[i], pali_alphabet,
                   nomatch = length(pali_alphabet) + 1)) {
      return(TRUE)
    } else if (match(temp1[i], pali_alphabet,
                     nomatch = length(pali_alphabet) + 1) <
               match(temp2[i], pali_alphabet,
                     nomatch = length(pali_alphabet) + 1)) {
      return(FALSE)
    }
  }
  if (stringr::str_length(word1) > stringr::str_length(word2))
    return(TRUE)
  else
    return(FALSE)
}

#' Sorting function for vectors of Pali words.
#'
#' Note that all Pali string comparisons are case-insensitive.
#' This algorithm is based on Quicksort, but creates lots of
#' intermediate data structures instead of doing swaps in place.
#' It is MUCH slower than the built-in sort, but respects Pali
#' alphabetical order. (It takes about 60 seconds to sort 10,000
#' random Pali words on my Mac; sort takes less than 1 sec!)
#'
#' @param word_list A vector of Pali words
#' @return A new vector of Pali words in Pali alphabetical order
#' @export
pali_sort <- function(word_list) {
  if (length(word_list) <= 1)
    return(word_list)
  pivot <- word_list[1]
  rest <- word_list[-1]
  pivot_less <- c()
  pivot_greater <- c()
  for (next_word in rest) {
    if (pali_lt(next_word, pivot)) {
      pivot_less <- c(pivot_less, next_word)
    }
    else {
      pivot_greater <- c(pivot_greater, next_word)
    }
  }
  return(c(pali_sort(pivot_less),
           pivot,
           pali_sort(pivot_greater)))
}


#' Make built-in Pali strings more readable.
#'
#' CRAN requires that all Pali strings be rendered in ASCII
#' characters, so letters with diacritics have to be represented
#' with Unicode escape codes (ie, "ā" becomes "\\u0101"). This
#' converts all those strings back to more readable forms. If
#' you call it with a string argument, it returns that string
#' with the Unicode escape codes converted to Pali characters.
#' If you call without any arguments, it simply converts the
#' built-in strings to more readble form.
#'
#' @param string A Pali string that has Unicode escape characters (optional)
#' @return The string converted to Pali characters, or nothing if no string is passed
#' @export
pali_string_fix <- function(string) {
  if (missing(string)) {
    pali_alphabet <<-
      stringi::stri_unescape_unicode(pali_alphabet)
    tipitaka_names$name <<-
      stringi::stri_unescape_unicode(tipitaka_names$name)
    sutta_pitaka$name <<-
      stringi::stri_unescape_unicode(sutta_pitaka$name)
    vinaya_pitaka$name <<-
      stringi::stri_unescape_unicode(vinaya_pitaka$name)
    abhidhamma_pitaka$name <<-
      stringi::stri_unescape_unicode(abhidhamma_pitaka$name)
  }
  else
    return(stringi::stri_unescape_unicode(string))
}

