# CHANGES IN printr VERSION 0.3

- Added `...` arguments to `knit_print` S3 methods to avoid warnings in `R CMD check`.

# CHANGES IN printr VERSION 0.2

- No longer calls the internal function `knitr:::trimws()`, which has been removed in **knitr** v1.35.

- Removed the `LazyData` field in the package DESCRIPTION.

# CHANGES IN printr VERSION 0.1

- Added methods for printing matrices, data frames, tables, help info, data/vignette lists, and package info.

