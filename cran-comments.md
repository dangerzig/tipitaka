## Test environments
* local macOS (aarch64-apple-darwin25.0.0), R 4.5.2

## R CMD check results
There were no ERRORs, WARNINGs, or NOTEs.

## Resubmission

This is a patch release (1.0.1) addressing example runtime feedback from the
previous review. All examples that trigger on-demand computation of derived
datasets are now wrapped in `\donttest{}`.

## Downstream dependencies

There are currently no downstream dependencies for this package.
