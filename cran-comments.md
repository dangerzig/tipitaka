## Test environments
* local macOS (aarch64-apple-darwin25.0.0), R 4.5.2

## R CMD check results
There were no ERRORs, WARNINGs, or NOTEs.

## Resubmission

This is a resubmission addressing the tarball size concern from the previous review.

Changes since previous submission:

1. **Tarball size reduction**: `tipitaka_long` and `tipitaka_wide` are now computed on demand from `tipitaka_raw` instead of being shipped as pre-built datasets. This substantially reduces the tarball size.

2. **C++ standard**: Removed explicit C++14 specification as C++17 (default) suffices.

3. **Dependencies simplified**: Moved dplyr, magrittr, stringi from Imports to Suggests.

## Downstream dependencies

There are currently no downstream dependencies for this package.
