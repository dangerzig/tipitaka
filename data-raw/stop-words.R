# Pali stop words
#
# This is a tentaive set of "stop words" for Pali. The set is taken
# from the PTS Pali-English dictionary and represents all the
# indeclinables and particles.

library(tidyverse)

pali_stop_words <- read_lines("indecl.txt")
pali_stop_words <- tibble(pali_stop_words)
colnames(pali_stop_words) = c("word")
pali_stop_words$word <- pali_sort(unique(pali_stop_words$word))

colnames(pali_stop_words) = c("word")


use_data(pali_stop_words, overwrite = TRUE)
