## Test environments
* local macOS (aarch64-apple-darwin25.0.0), R 4.5.2

## R CMD check results
There were no ERRORs or WARNINGs.

There was 1 NOTE:

* checking installed package size ...
     installed size is ~13.6Mb
     sub-directories of 1Mb or more:
       data   ~13Mb

  This is primarily a data package containing the complete scriptures of Theravadin Buddhism (the Tipitaka or Pali Canon). The size is due to lemmatized word frequency datasets and full text for ~5,700 individual suttas. The sutta-level frequency matrix is stored as a sparse matrix (dgCMatrix) to minimize size. The data will change very infrequently.

## Resubmission

This is a resubmission. The previous version on CRAN is 0.1.2.

Changes since 0.1.2:

1. **C++ standard fix**: Removed explicit C++14 specification from SystemRequirements, as CRAN now deprecates C++11/C++14 specifications and C++17 is the default. Also added proper routine registration via `useDynLib(tipitaka, .registration = TRUE)`.

2. **Major new feature - Critical edition data**: Added a lemmatized critical edition of the Sutta Pitaka based on a five-witness collation (PTS/GRETIL, SuttaCentral, VRI, BJT, Thai). Where multiple witnesses agree against PTS and the PTS reading is not a valid Pali word, the text is corrected. All words are lemmatized by dictionary headword using the Digital Pali Dictionary (99.78% token-level coverage). Seven new datasets provide full text, lemma frequencies, and frequency matrices at both nikaya and individual sutta level.

3. **New function**: `search_lemma()` for searching lemma occurrences across all suttas.

4. **Dependency changes**: Added Matrix to Depends (for sparse matrix storage of sutta-level data). Moved dplyr, magrittr, and stringi from Imports to Suggests (only used in examples). Removed cpp11 from Imports (only needed in LinkingTo).

All original VRI-based datasets remain unchanged for backwards compatibility.

## Downstream dependencies

There are currently no downstream dependencies for this package.
