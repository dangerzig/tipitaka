# This is the code to load and process the core Tipitaka files
# into R.


library(tidyverse) # For many things
library(tidytext) # For applying tidy to text files
library(stringi) # For Unicode stuff
library(devtools)

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
pali_alphabet <- c(pali_vowels, pali_consonants)

setwd("data-raw/")
# Now we load the Tiptaka itself
raw_files <- list.files(pattern = "*\\.mul\\.txt$")
tipitaka_raw <- map_df(raw_files, ~ tibble(text = read_file(.x)) %>%
                       mutate(file = basename(.x)))

# Now join to book names
tipitaka_names <- tibble(read.csv(file = "books.csv"))
tipitaka_raw <- left_join(tipitaka_raw,
                          select(tipitaka_names, -name), # skip name column
                          by = "file")
tipitaka_raw <- select(tipitaka_raw, -file) # drop the file name

# Now we start to build the "long" form::
tipitaka_long <- tipitaka_raw %>%
  unnest_tokens(word, text)

# Remove any "word" with digits in it:
tipitaka_long<-tipitaka_long[-grep("\\d+", tipitaka_long$word),]
# Remove apostrophes --  not sure if this is right!
tipitaka_long$word <- str_replace(tipitaka_long$word, "’", "")


# Count all occurrences of each unique word per file and total for each file
tipitaka_long <- tipitaka_long %>%
  count(book, word, sort = TRUE) %>%
  group_by(book) %>%
  add_count(wt = n, name = "total") %>%
  ungroup() %>%
  transform(freq = n/total)



# Pivot to "wide" format
tipitaka_wide <- pivot_wider(select(tipitaka_long, word, freq, book),
                          names_from = word,
                          values_from = freq,
                          values_fill = 0)
tipitaka_wide <- column_to_rownames(tipitaka_wide, var = "book")


# Get lists of the book of the various "baskets"
vinaya_pitaka <-
  select(tipitaka_names[grep("^vin[[:alnum:]]*\\.mul\\.txt$",
                             tipitaka_names$file), ],
         -file)
abhidhamma_pitaka <-
  select(tipitaka_names[grep("^abh[[:alnum:]]*\\.mul\\.txt$",
                              tipitaka_names$file), ],
         -file)
sutta_pitaka <-
  select(tipitaka_names[grep("^s[[:alnum:]]*\\.mul\\.txt$",
                              tipitaka_names$file), ],
         -file)

tipitaka_names <- select(tipitaka_names, -file) # drop the file name


# Also create a data set for the Mahāsatipaṭṭhāna Sutta
sati_sutta_raw <- tibble(text = read_file("sati.txt"))

sati_sutta_long <- sati_sutta_raw %>%
  unnest_tokens(word, text)

# Remove any "word" with digits in it:
sati_sutta_long <- sati_sutta_long[-grep("\\d+", sati_sutta_long$word),]
# Remove apostrophes --  not sure if this is right!
sati_sutta_long$word <- str_replace(sati_sutta_long$word, "’", "")

sati_sutta_long <- sati_sutta_long %>%
  count(word, sort = TRUE) %>%
  add_count(wt = n, name = "total") %>%
  transform(freq = n/total)

# Clean up these strings
tipitaka_names$name <- stringi::stri_escape_unicode(tipitaka_names$name)
sutta_pitaka$name <- stringi::stri_escape_unicode(sutta_pitaka$name)
vinaya_pitaka$name <- stringi::stri_escape_unicode(vinaya_pitaka$name)
abhidhamma_pitaka$name <- stringi::stri_escape_unicode(abhidhamma_pitaka$name)

use_data(tipitaka_raw, overwrite = TRUE)
use_data(tipitaka_long, overwrite = TRUE)
use_data(tipitaka_wide, overwrite = TRUE)
use_data(tipitaka_names, overwrite = TRUE)
use_data(sutta_pitaka, overwrite = TRUE)
use_data(vinaya_pitaka, overwrite = TRUE)
use_data(abhidhamma_pitaka, overwrite = TRUE)
use_data(sati_sutta_raw, overwrite = TRUE)
use_data(sati_sutta_long, overwrite = TRUE)
use_data(pali_alphabet, overwrite = TRUE)


