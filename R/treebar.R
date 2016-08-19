#' Interactive Zoomable Treemap Bar Charts
#'
#' htmlwidget based off Chris Given's
#' \href{http://bl.ocks.org/cmgiven/4541f6de7b6fbef482aaa43f3a71f8d4}{Treemap Bar}
#'
#' @param data \code{string} json data of a four level d3.js hierarchy.
#'   inflexible now but will improve
#' @param ... additional arguments currently supports 
#'   id, name, and tile for customizing your chart
#'
#' @import htmlwidgets
#'
#' @export
treebar <- function(data=NULL, ..., width = NULL, height = NULL, elementId = NULL) {

  # forward options using x
  x = list(
    data = data,
    options = list(...)
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'treebar',
    x,
    width = width,
    height = height,
    package = 'treebar',
    elementId = elementId
  )
}

#' Shiny bindings for treebar
#'
#' Output and render functions for using treebar within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a treebar
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name treebar-shiny
#'
#' @export
treebarOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'treebar', width, height, package = 'treebar')
}

#' @rdname treebar-shiny
#' @export
renderTreebar <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, treebarOutput, env, quoted = TRUE)
}
