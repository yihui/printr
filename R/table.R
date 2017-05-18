#' @export
knit_print.matrix = function(x, options, ...) {
  res = paste(c('', '', kable(
    x, options$printr.table.format, caption = options$printr.table.caption, ...
  )), collapse = '\n')
  asis_output(res)
}
#' @export
knit_print.data.frame = knit_print.matrix

#' @export
knit_print.table = function(x, options) {
  if (any(dim(x) == 0)) return('Empty table')
  d = length(dim(x))
  if (d <= 1) {
    x = matrix(c(x), nrow = 1, dimnames = list(NULL, names(x)))
  } else if (d == 2) {
    class(x) = 'matrix'
  } else {
    # TODO: there might be better ways to represent such high-dimensional tables
    x = do.call(
      as.data.frame,
      c(list(x = x, stringsAsFactors = FALSE), options$printr.table2df.args)
    )
    m = ncol(x); n = nrow(x)
    # order from first to last column instead of the opposite (default)
    x = x[do.call(order, as.list(x[, -m])), ]
    # remove duplicate entries
    x[, -m] = matrix(apply(x[, -m], 2, function(z) {
      z[c(FALSE, z[-1] == z[-n])] = ''
      z
    }), nrow = n)
    rownames(x) = NULL
  }
  if (d == 2) {
    knit_print(
      x, options, row.names = TRUE,
      rownames.name = paste(names(dimnames(x)), collapse = '/')
    )
  } else {
    knit_print(x, options)
  }
}
