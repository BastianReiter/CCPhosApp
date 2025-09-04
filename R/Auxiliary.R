
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# AUXILIARY FUNCTIONS within CCPhosApp package
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' AssertIfNotNull
#'
#' Shorthand for \code{asserthat::assert_that} that only checks condition if argument is not NULL (as is the case for some optional arguments)
#'
#' @param Argument The object passed to the function as argument
#' @param AssertionCall \code{call} - The assertion expression passed to \code{assertthat::assert_that}
#'
#' @noRd
#'
#-------------------------------------------------------------------------------
AssertIfNotNull <- function(Argument,
                            AssertionCall)
{
  require(assertthat)

  if (!is.null(Argument))
  {
      eval(expr = parse(text = paste0("assert_that(", deparse(AssertionCall), ")")),
           envir = parent.frame())
  }
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' ColorToRGBCSS
#'
#' Turn hexadecimal color code into a string of CSS code of the form 'rgba(r, g, b, a)'.
#' Can be used with vectors.
#'
#' @param Color \code{character} - Vector of hexadecimal color code
#' @param Alpha \code{double} - Optional alpha value vector - Default: 1
#' @param RenderNATransparent \code{logical} - Indicating whether \code{NA} values for \code{Color} result in a totally transparent color
#'
#' @author Bastian Reiter
#-------------------------------------------------------------------------------
ColorToRGBCSS <- function(Color,
                          Alpha = 1,
                          RenderNATransparent = TRUE)
{
  Scalar <- function(color, alpha)
            {
                RGB <- col2rgb(color)
                if (RenderNATransparent == TRUE & is.na(color)) { Alpha <- 0 } else { Alpha <- alpha }      # If color is NA, set alpha value 0 (making resulting color effectively non-existent)
                paste0("rgba(", RGB[["red", 1]], ", ", RGB[["green", 1]], ", ", RGB[["blue", 1]], ", ", Alpha, ")")
            }

  Vectorize(Scalar)(Color, Alpha)
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' ConvertLogicalToIcon
#'
#' @param DataFrame \code{data.frame} or \code{tibble}
#'
#' @return \code{data.frame}
#' @export
#' @author Bastian Reiter
#-------------------------------------------------------------------------------
ConvertLogicalToIcon <- function(DataFrame)
{
  require(dplyr)
  require(shiny.semantic)

  if (!is.null(DataFrame))
  {
      DataFrame %>%
          mutate(across(.cols = where(is.logical),
                        .fns = ~ case_match(.x,
                                            TRUE ~ as.character(shiny.semantic::icon(class = "small green check")),
                                            FALSE ~ as.character(shiny.semantic::icon(class = "small red times")))))
  }
  else { return(NULL) }
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' CreateWaiterScreen
#'
#' @param ID \code{string}
#'
#' @return Waiter object
#' @noRd
#-------------------------------------------------------------------------------
CreateWaiterScreen <- function(ID)
{
  waiter::Waiter$new(id = ID,
                     html = spin_3(),
                     color = transparent(.5))
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
