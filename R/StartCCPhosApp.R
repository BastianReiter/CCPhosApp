
#' StartCCPhosApp
#'
#' Launch Shiny app
#'
#' @param CCPhosData List | Data collected by dsCCPhosClient
#'
#' @export
#'
#' @author Bastian Reiter
StartCCPhosApp <- function(CCPConnections,
                           CCPhosData)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
    require(shiny)

    ui <- UIComponent(CCPhosData)

    server <- ServerComponent(CCPConnections. = CCPConnections,
                              CCPhosData)

    shinyApp(ui, server)
}
