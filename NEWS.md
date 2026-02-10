# tipitaka 1.0.0

## New Features

### Critical Edition Data
Added a new critical edition of the Sutta Pitaka based on a five-witness collation of PTS (via GRETIL), SuttaCentral, VRI (Chattha Sangayana), Buddha Jayanti Tipitaka (BJT), and the Thai Royal Edition (Syam Rattha). Key improvements:

* **Lemmatization**: All text is lemmatized using the Digital Pali Dictionary, grouping inflected forms by dictionary headword (e.g., "buddhassa", "buddho" -> "buddha"). This addresses the long-standing stemming issue noted in previous versions.

* **Sutta-level granularity**: New datasets provide word frequencies at the individual sutta level, not just volume level.

* **Corrections from five witnesses**: Where multiple witnesses (SC, VRI, BJT) agree against PTS and the PTS reading is not a valid Pali word per DPD, the text is corrected and the original PTS reading recorded.

### New Datasets
* `tipitaka_long_critical` - Lemma frequencies by nikaya
* `tipitaka_wide_critical` - Lemma x nikaya frequency matrix
* `tipitaka_raw_critical` - Full text per nikaya
* `tipitaka_long_words` - Surface form (non-lemmatized) frequencies
* `tipitaka_suttas_raw` - Full text per individual sutta
* `tipitaka_suttas_long` - Lemma frequencies by individual sutta
* `tipitaka_suttas_wide` - Lemma x sutta frequency matrix

### New Functions
* `search_lemma()` - Search for lemma occurrences across all suttas

## Breaking Changes
* Removed `sati_sutta_long` and `sati_sutta_raw` datasets. The same data (and better, lemmatized) can now be extracted from the critical edition: `tipitaka_suttas_long[tipitaka_suttas_long$sutta == "dn22", ]`

## Backwards Compatibility
All other original VRI-based datasets (`tipitaka_raw`, `tipitaka_long`, `tipitaka_wide`, etc.) remain unchanged and available.

## Bug Fixes
* Removed explicit C++14 specification from SystemRequirements as C++17 (the default) suffices. This addresses CRAN's deprecation of C++11/C++14 specifications.

## Notes
The critical edition currently covers only the Sutta Pitaka (DN, MN, SN, AN, KN). The original VRI data continues to provide coverage of the Vinaya and Abhidhamma Pitakas.

# tipitaka 0.1.2

* Added 'LazyDataCompression: xz' to DESCRIPTION as requested to save space

# tipitaka 0.1.1

* `pali_sort` is now written in C++ and is about 400-500x faster than the  previous R version.

# tipitaka 0.1.0

* Added a `NEWS.md` file to track changes to the package.

## Known issues

### Volume numbering (VRI data)
Numbering of VRI Tipitaka volumes is a bit of a mess. This is due to CST4 and PTS using somewhat different systems. Here is where things stand:

* Volume numbering within the *Vinaya Pitaka* has been adjusted to match the PTS order.
* Volume numbering within the *Abhidhamma Pitaka* is consistent between the two editions and is unchanged.
* Volume numbering within the *Dīgha Nikāya* is also consistent between the two.
* Volumes of the *Khuddaka Nikāya* are listed under their separate titles rather than by number, as is the norm for these works.
* Volume division and numbering within the *Majjhima Nikāya*, *Samyutta Nikāya*, and *Anguttara Nikāya* is **inconsistent** and has been left according to the CST4.

The last of these is an annoyance in the VRI data and should be fixed in a future release. Note that the new critical edition datasets use a consistent sutta-level ID scheme that avoids this issue.
