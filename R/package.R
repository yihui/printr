#' Print R objects in \pkg{knitr} documents nicely
#'
#' The main documentation of this package is the package vignette
#' \file{printr-intro.html}. Please check out \code{vignette('printr', package =
#' 'printr')}.
#' @name printr
#' @aliases printr-package
#' @importFrom knitr asis_output kable knit_print
NULL

# unregister S3 methods in this package
unregister_S3 = function() {
  if (!('knitr' %in% loadedNamespaces())) return()
  objs = ls(asNamespace('printr'))
  s3env = getFromNamespace('.__S3MethodsTable__.', 'knitr')
  rm(list = intersect(objs, ls(s3env)), envir = s3env)
}

# remove S3 methods when the package is unloaded
.onUnload = function(libpath) unregister_S3()
