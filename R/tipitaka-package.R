#' @useDynLib tipitaka, .registration = TRUE
#' @name tipitaka
"_PACKAGE"

# Internal cache for computed data
.cache <- new.env(parent = emptyenv())

# Suppress R CMD check NOTE for LazyData globals
utils::globalVariables("tipitaka_raw")
