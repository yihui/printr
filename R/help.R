#" browseVignettes()
#' @export
knit_print.browseVignettes = function(x, options) {
  if (length(x) == 0) return('No vignettes found')
  x = do.call(rbind, x)
  x = x[, c('Package', 'PDF', 'Title'), drop = FALSE]
  colnames(x)[2] = 'Vignette'  # not necessarily PDF
  x = if (length(unique(x[, 1])) == 1) {
    x[, -1, drop = FALSE]  # the package column is redundant
  } else {
    x[order(x[, 1]), , drop = FALSE]  # order by package names
  }
  knit_print(x, options)
}

#" ?foo / help(foo)
#' @export
knit_print.help_files_with_topic = function(x, options) {
  n = length(x)
  topic = attr(x, 'topic')
  if (n == 0) return(paste(
    "No documentation for '", topic, "' in specified packages and libraries",
    sep = ''
  ))
  base = basename(file <- as.character(x))
  pkg  = basename(dirname(dirname(file)))
  if (n > 1) return(paste(
    "Help on topic '", topic, "' was found in the following packages:\n\n",
    paste('  *', pkg, collapse = '\n'), sep = ''
  ))

  db = tools::Rd_db(pkg)
  Rd = db[[which(base == sub('[.]Rd$', '', basename(names(db))))]]
  Rd = extract_Rd(Rd, options$printr.help.sections)

  to = knitr::pandoc_to()
  if (is.null(to)) {
    type = knitr:::out_format()
    if (type == 'html') type = 'HTML' else if (type != 'latex') type = 'txt'
  } else {
    type = if (to %in% c('html', 'markdown')) 'HTML' else {
      # it seems \bold in \usepackage{Rd} conflicts with a certain package in
      # the Pandoc template, so unfortunately we cannot use latex format here

      # if (type %in% c('latex', 'beamer')) 'latex' else
      'txt'
    }
  }

  # call tools::Rd2[txt,HTML,latex]
  convert = getFromNamespace(paste('Rd', type, sep = '2'), 'tools')
  out = capture.output(convert(Rd))
  out = paste(out, collapse = '\n')
  # only need the body fragment (Rd2HTML(fragment = TRUE) does not really work)
  if (type == 'HTML') {
    out = gsub('.*?<body>(.*)</body>.*', '<div class="r-help-page">\\1</div>', out)
    if (!is.null(to)) out = sprintf('```{=html}\n%s\n```', out)
  }

  out = trimws(out)
  # I do not know where _\b came from in the text mode...
  if (type == 'txt') gsub('_\b', '', out) else asis_output(out)
}

extract_Rd = function(Rd, section) {
  if (length(section) == 0) return(Rd)
  # extract the section names, and remove the leading backslash
  sections = sub('^\\\\', '', unlist(lapply(Rd, attr, 'Rd_tag')))
  section  = c('title', 'name', section)  # title and name are required
  Rd[which(!(sections %in% section))] = NULL
  Rd
}

#" help.search()
#' @export
knit_print.hsearch = function(x, options) {
  # case-insensitive matching of column names (e.g. R 3.2.0 uses 'Topic' but R
  # 3.1.x uses 'topic')
  j = match(tolower(c('Package', 'topic', 'Type', 'title')), tolower(names(x$matches)))
  out = x$matches[, j, drop = FALSE]
  if (nrow(out) == 0) return('No results found')
  colnames(out) = sub('^(.)', '\\U\\1', colnames(out), perl = TRUE)  # sigh...
  # if all types are the same, just remove this column
  if (length(unique(out[, 'Type'])) <= 1) out = out[, -3, drop = FALSE]
  # remove duplicate rows
  out = out[!duplicated(out), , drop = FALSE]
  rownames(out) = NULL
  knit_print(out, options)
}

#" library(help = foo)
#' @export
knit_print.packageInfo = function(x, options) {
  sub('^\n', '', paste(format(x), collapse = '\n'))
}

#" data()/vignette()
#' @export
knit_print.packageIQR = function(x, options) {
  if (nrow(x$results) == 0) return(paste(x$title, 'not found'))
  out = x$results[, c('Package', 'Item', 'Title'), drop = FALSE]
  title = x$title
  if (length(unique(out[, 1])) == 1) {
    title = paste(title, 'in', out[1, 1])
    out = out[, -1, drop = FALSE]
  }
  if (is.null(options$printr.table.caption)) options$printr.table.caption = title
  knit_print(out, options, row.names = FALSE)
}
