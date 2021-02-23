#' @export
knit_print.sessionInfo <- function(x, ...) {
  if (missing(x))
    x <- sessionInfo()
  packagename <- function(x) {
    sha <- ifelse("GithubSHA1" %in% names(x),
                  paste(", GithubSHA1:", x$GithubSHA1),
                  "")
    sprintf("%s(%s%s)", x$Package, x$Version, sha)
  }
  otherpkg <- sapply(x$otherPkgs, FUN=packagename)
  namespacepkg <- sapply(x$loadedOnly, FUN=packagename)
  ret <-
    c(paste("*", c(x$R.version$version.string,
                   paste("Platform:", x$platform))),
      paste("* Locale:", paste(strsplit(x$locale, ";")[[1]], collapse=", ")),
      "* Packages",
      paste("    * Base:", paste(x$basePkgs, collapse=", ")),
      paste("    * Attached:", paste(otherpkg, collapse="; ")),
      paste("    * Namespaces (not attached):", paste(namespacepkg, collapse="; ")))
  knitr::asis_output(paste(ret, collapse="\n"))
}
