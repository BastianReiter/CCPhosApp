
#' StartCCPhosApp
#'
#' Launch Shiny app
#'
#' @param CCPConnections \code{list} of \code{DSConnection} objects
#' @param CCPSiteSpecifications
#' @param CCPTestData \code{list} - Optional CCP test data
#' @param RDSTableCheckData \code{list} - Optional RDSTableCheck data
#' @param CurationReportData \code{list} - Optional CurationReport data
#'
#' @export
#'
#' @author Bastian Reiter
StartCCPhosApp <- function(CCPConnections = NULL,
                           CCPSiteSpecifications = NULL,
                           CCPTestData = NULL,
                           RDSTableCheckData = NULL,
                           CurationReportData = NULL)
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
    shiny::shinyApp(ui = MainUIComponent(),
                    server = MainServerComponent(CCPSiteSpecifications,
                                                 CCPTestData,
                                                 RDSTableCheckData,
                                                 CurationReportData))
}
