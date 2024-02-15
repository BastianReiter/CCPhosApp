
#' StartCCPhosApp
#'
#' Launch Shiny app
#'
#' @param CCPhosData List | Data collected by dsCCPhosClient
#'
#' @export
#'
#' @author Bastian Reiter
StartCCPhosApp <- function(CCPhosData)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
    require(shiny)

    ui <- UIComponent(CCPhosData)
    server <- ServerComponent(CCPhosData)

    shinyApp(ui, server)
}
