# Pali stop words
#
# This is a tentaive set of "stop words" for Pali. The set is taken
# from the PTS Pali-English dictionary and represents all the
# indeclinables and particles.

library(tidyverse)

pali_stop_words <- read_lines("indecl.txt")
pali_stop_words <- tibble(pali_stop_words)
colnames(new_stop_words) = c("word")
pali_stop_words <- pali_stop_words %>%
  unique() %>%
  pali_sort()

colnames(pali_stop_words) = c("word")


use_data(pali_stop_words, overwrite = TRUE)
