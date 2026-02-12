# On-demand computation of derived datasets
#
# tipitaka_long and tipitaka_wide are created as lazy promises via
# delayedAssign in .onLoad. They look like regular data objects to
# users but are computed from tipitaka_raw on first access.

#' Tipitaka in "long" form
#'
#' Every word of every volume of the Tipitaka, with one word per
#' volume per line. Computed from \code{tipitaka_raw} on first access.
#'
#' @format A data frame with the variables:
#' \describe{
#' \item{word}{Pali word}
#' \item{n}{Number of times this word appears in this book}
#' \item{total}{Total number of words in this book}
#' \item{freq}{Frequency with which this word appears in this book}
#' \item{book}{Abbreviated book name}
#' }
#'
#' @source Vipassana Research Institute, CST4, April 2020
#' @export
tipitaka_long <- NULL

#' Tipitaka in "wide" form
#'
#' Every word of every volume of the Tipitaka, with one word per
#' column and one book per line. Each cell is the frequency at
#' which that word appears in that book. Computed from
#' \code{tipitaka_raw} on first access.
#'
#' @source Vipassana Research Institute, CST4, April 2020
#' @export
tipitaka_wide <- NULL

.onLoad <- function(libname, pkgname) {
  ns <- parent.env(environment())
  delayedAssign("tipitaka_long",
    tryCatch(.compute_tipitaka_long(), error = function(e) NULL),
    eval.env = ns, assign.env = ns)
  delayedAssign("tipitaka_wide",
    tryCatch(.compute_tipitaka_wide(), error = function(e) NULL),
    eval.env = ns, assign.env = ns)
}

# Internal: compute tipitaka_long from tipitaka_raw
.compute_tipitaka_long <- function() {
  raw <- get("tipitaka_raw", envir = asNamespace("tipitaka"))
  rows <- lapply(seq_len(nrow(raw)), function(i) {
    text <- tolower(raw$text[i])
    words <- unlist(strsplit(text, "[^[:alpha:]']+"))
    words <- words[nchar(words) > 0]
    words <- words[!grepl("\\d", words)]
    words <- gsub("'", "", words)
    words <- words[nchar(words) > 0]
    tab <- table(words)
    total <- as.integer(sum(tab))
    data.frame(
      word = as.character(names(tab)),
      n = as.integer(tab),
      total = total,
      freq = as.numeric(tab) / total,
      book = raw$book[i],
      stringsAsFactors = FALSE
    )
  })
  result <- do.call(rbind, rows)
  result <- result[order(-result$n), ]
  rownames(result) <- NULL
  result
}

# Internal: compute tipitaka_wide from tipitaka_long
.compute_tipitaka_wide <- function() {
  long <- .compute_tipitaka_long()
  books <- sort(unique(long$book))
  words <- sort(unique(long$word))
  mat <- matrix(0, nrow = length(books), ncol = length(words),
                dimnames = list(books, words))
  idx <- cbind(match(long$book, books), match(long$word, words))
  mat[idx] <- long$freq
  as.data.frame(mat)
}
