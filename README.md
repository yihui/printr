# printr

<!-- badges: start -->
[![R-CMD-check](https://github.com/yihui/printr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/yihui/printr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

This is a companion package to [**knitr**](https://yihui.org/knitr). Its main
purpose is to extend the S3 generic function `knit_print()` in **knitr**, which
is the default value of the chunk option `render`, as explained in the vignette
[knit_print.html](https://cran.r-project.org/package=knitr/vignettes/knit_print.html).

You can install the stable version from CRAN or the development version from my personal repo:

```r
# CRAN version
install.packages('printr')

# or the dev version
install.packages(
  'printr',
  repos = c('https://yihui.r-universe.dev', 'https://cran.rstudio.com')
)
```

To enable the printing methods defined in this package, just `library(printr)`
in a code chunk (in the beginning) of your **knitr** document. Then some objects
will be printed differently with what you would have seen in a normal R console.
For example:

- matrices, data frames, and contingency tables are printed as tables (LaTeX,
  HTML, or Markdown, depending on your output format)
- the help page (from `?foo` or `help(foo)`) can be rendered as HTML, LaTeX, or
  plain text, and you can also specify which section(s) of the help page to
  include in the output
- the results from `browseVignettes()`, `help.search()`, `data()`, and
  `vignette()` are rendered as tables
- the package information from `library(help = 'foo')` is rendered as plain text

For more information, please check out the [package
vignette](https://yihui.org/printr/):

```r
vignette('printr', package = 'printr')
```

You are welcome to contribute more S3 methods to this package, and you may want
to read the existing methods in this package before you get started. In most
cases, I guess you will end up rendering either plain text (see
`knit_print.packageInfo` for example) or tables (see `knit_print.matrix`) in the
output.
