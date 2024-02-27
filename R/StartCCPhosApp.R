
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
StartCCPhosApp <- function(TestData = NULL)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
    require(shiny)
    #require(shiny.worker)

    #Worker <- shiny.worker::initialize_worker()

    # CCPTestData <- reactive(NULL)
    #
    # if (!is.null(TestData)) { CCPTestData(TestData) }


    ui <- UIComponent()

    server <- ServerComponent(TestData)

    shinyApp(ui, server)
}
