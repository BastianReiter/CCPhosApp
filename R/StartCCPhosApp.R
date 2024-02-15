
#' StartCCPhosApp
#'
#' Launch Shiny app
#'
#' @export
#'
#' @author Bastian Reiter
StartCCPhosApp <- function()
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
    require(shiny)

    shinyApp(UIComponent(), ServerComponent())
}
