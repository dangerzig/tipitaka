# tipitaka 1.0.0

## Changes

* `tipitaka_long` and `tipitaka_wide` are now computed on demand from `tipitaka_raw` via `tipitaka_long()` and `tipitaka_wide()`, reducing the package tarball size.

* Removed C++14 specification from SystemRequirements as C++17 (the default) suffices. This addresses CRAN's deprecation of C++11/C++14 specifications.

* Moved several packages from Imports to Suggests (dplyr, magrittr, stringi) since they are only used in examples.

* Removed `sati_sutta_long` and `sati_sutta_raw` demo datasets.

## Related Packages

A companion package `tipitaka.critical` provides a lemmatized critical edition of the complete Tipitaka (all three pitakas) based on a five-witness collation with sutta-level granularity. Install with:

```r
install.packages("tipitaka.critical")
```

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

The last of these is an annoyance in the VRI data and should be fixed in a future release.
