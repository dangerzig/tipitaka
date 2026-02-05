## Test environments
* local macOS, R 4.x
* devtools::check_win_release()
* GitHub Actions (ubuntu-latest, windows-latest, macOS-latest)

## R CMD check results
There were no ERRORs or WARNINGs.

There was 1 NOTE:

* checking installed package size ...
     installed size is ~15Mb
     sub-directories of 1Mb or more:
       data   ~14Mb

  This is primarily a data package containing the complete scriptures of Theravadin Buddhism (the Tipitaka or Pali Canon). The increased size in v1.0 is due to new lemmatized datasets that enable sutta-level text analysis. The data will change very infrequently.

## Major changes in v1.0

This is a major release adding:

1. **Critical edition data**: A lemmatized version of the Sutta Pitaka based on PTS with corrections from comparing SuttaCentral and VRI editions.

2. **Lemmatization**: All words are grouped by dictionary headword using the Digital Pali Dictionary, addressing the long-standing need for stemming noted in previous versions.

3. **Sutta-level granularity**: Word frequencies are now available for ~5,700 individual suttas, not just volume-level.

4. **C++ standard fix**: Removed explicit C++14 specification as requested by CRAN (C++17 default suffices).

All original VRI-based datasets remain unchanged for backwards compatibility.

## Downstream dependencies

There are currently no downstream dependencies for this package.
