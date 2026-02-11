## Test environments
* local macOS (aarch64-apple-darwin25.0.0), R 4.5.2

## R CMD check results
There were no ERRORs or WARNINGs.

There was 1 NOTE:

* checking installed package size ...

  This is primarily a data package containing the complete scriptures of Theravadin Buddhism (the Tipitaka or Pali Canon) from the Vipassana Research Institute's Chattha Sangayana edition. The data will change very infrequently.

## Resubmission

This is a resubmission addressing the tarball size concern from the previous review. The tarball has been substantially reduced by moving the lemmatized critical edition data to a separate companion package (tipitaka.critical). This package now contains only the original VRI datasets and Pali text tools.

Changes since previous submission:

1. **Tarball size reduction**: Moved all critical edition datasets to the companion package tipitaka.critical. Package now contains only original VRI data.

2. **C++ standard**: Removed explicit C++14 specification as C++17 (default) suffices.

3. **Dependencies simplified**: Moved dplyr, magrittr, stringi from Imports to Suggests.

## Downstream dependencies

There are currently no downstream dependencies for this package.
