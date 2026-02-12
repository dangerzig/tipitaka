#' Tipitaka in "long" form
#'
#' Returns word frequency data for every volume of the Tipitaka,
#' with one word per volume per row. Computed from \code{tipitaka_raw}
#' on first call and cached for subsequent use.
#'
#' @return A data frame with columns: word, n, total, freq, book.
#' @export
#'
#' @examples
#' tl <- tipitaka_long()
#' head(tl)
#'
#' # Count total words across the Tipitaka
#' sum(unique(tl[, c("book", "total")])$total)
#'
tipitaka_long <- function() {
  if (is.null(.cache$tipitaka_long)) {
    .cache$tipitaka_long <- .compute_tipitaka_long()
  }
  .cache$tipitaka_long
}

#' Tipitaka in "wide" form
#'
#' Returns word frequency data for every volume of the Tipitaka as a
#' matrix with one word per column and one book per row. Each cell is
#' the frequency at which that word appears in that book. Computed from
#' \code{\link{tipitaka_long}} on first call and cached for subsequent use.
#'
#' @return A data frame with books as rows and words as columns.
#' @export
#'
#' @examples
#' tw <- tipitaka_wide()
#' # Hierarchical clustering of Tipitaka volumes
#' plot(hclust(dist(tw)))
#'
tipitaka_wide <- function() {
  if (is.null(.cache$tipitaka_wide)) {
    .cache$tipitaka_wide <- .compute_tipitaka_wide()
  }
  .cache$tipitaka_wide
}

# Internal: compute tipitaka_long from tipitaka_raw
.compute_tipitaka_long <- function() {
  rows <- lapply(seq_len(nrow(tipitaka_raw)), function(i) {
    text <- tolower(tipitaka_raw$text[i])
    # Tokenize: split on non-alphabetic characters (Unicode-aware)
    words <- unlist(strsplit(text, "[^[:alpha:]']+"))
    words <- words[nchar(words) > 0]
    # Remove words containing digits
    words <- words[!grepl("\\d", words)]
    # Remove apostrophes
    words <- gsub("'", "", words)
    words <- words[nchar(words) > 0]
    # Count occurrences
    tab <- table(words)
    total <- as.integer(sum(tab))
    data.frame(
      word = as.character(names(tab)),
      n = as.integer(tab),
      total = total,
      freq = as.numeric(tab) / total,
      book = tipitaka_raw$book[i],
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
  long <- tipitaka_long()
  books <- sort(unique(long$book))
  words <- sort(unique(long$word))
  mat <- matrix(0, nrow = length(books), ncol = length(words),
                dimnames = list(books, words))
  idx <- cbind(match(long$book, books), match(long$word, words))
  mat[idx] <- long$freq
  as.data.frame(mat)
}
