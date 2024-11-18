
#' StartCCPhosApp
#'
#' Launch Shiny app
#'
#' @param CCPConnections List of DSConnection objects
#' @param CCPSiteSpecifications
#' @param CCPTestData List | Optional CCP test data
#'
#' @export
#'
#' @author Bastian Reiter
StartCCPhosApp <- function(CCPSiteSpecifications = NULL,
                           CCPTestData = NULL)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
    require(DataEditR)
    require(dsCCPhosClient)
    require(dplyr)
    require(DSI)
    require(DT)
    require(gt)
    require(plotly)
    require(purrr)
    require(shiny)
    require(shinyjs)
    require(shiny.router)
    require(shiny.semantic)
    require(stringr)
    require(waiter)


    # Set option to use themes for semantic CCS
    #options(semantic.themes = TRUE)

    #Worker <- shiny.worker::initialize_worker()

    # Since the app is deployed as a package, the folder for external resources (e.g. CSS files, static images) needs to be added manually
    shiny::addResourcePath('www', system.file("www", package = "CCPhosApp"))

    # Start CCPhos app
    shinyApp(ui = MainUIComponent(),
             server = MainServerComponent(CCPSiteSpecifications,
                                          CCPTestData))
}
