
#' StartCCPhosApp
#'
#' Launch Shiny app
#'
#' @param CCPConnections List of DSConnection objects
#' @param CCPTestData List | Optional CCP test data
#'
#' @export
#'
#' @author Bastian Reiter
StartCCPhosApp <- function(CCPCredentials = NULL,
                           CCPTestData)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
    require(dsCCPhosClient)
    require(DT)
    require(gt)
    require(shiny)
    require(shiny.router)
    require(shiny.semantic)
    #require(shiny.worker)
    require(waiter)


    #Worker <- shiny.worker::initialize_worker()


    shinyApp(ui = MainUIComponent(),
             server = MainServerComponent(CCPCredentials,
                                          CCPTestData))
}
