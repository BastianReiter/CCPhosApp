
#' StartCCPhosApp
#'
#' Launch Shiny app
#'
#' @param DSConnections \code{list} of \code{DSConnection} objects
#' @param ServerSpecifications
#' @param CCPTestData \code{list} - Optional CCP test data
#' @param RDSTableCheckData \code{list} - Optional RDSTableCheck data
#' @param CurationReportData \code{list} - Optional CurationReport data
#'
#' @export
#'
#' @author Bastian Reiter
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
StartCCPhosApp <- function(#--- Arguments for app itself ---
                           ADSTableCheckData = NULL,
                           CCPTestData = NULL,
                           CDSTableCheckData = NULL,
                           CurationReportData = NULL,
                           DSConnections = NULL,
                           RDSTableCheckData = NULL,
                           ServerSpecifications = NULL,
                           ServerWorkspaceInfo = NULL,
                           #--- Arguments for app wrapper ---
                           EndProcessWhenClosingApp = TRUE,
                           RunAutonomously = TRUE,
                           RunInViewer = FALSE,
                           ...)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
  # Create the app initiating function (UI and server component resulting in a ShinyApp object)
  InitFunction <- function(...)
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
                      server = MainServerComponent(...))
  }

  # Either use CCPhosApp::RunAutonomousApp() to run the app in a separate background process or run it in the hosting session
  if (RunAutonomously == TRUE)
  {
      RunAutonomousApp(ShinyAppInitFunction = InitFunction,
                       AppArguments = list(...),
                       RunInViewer = RunInViewer)
  } else {

      # This returns the app itself
      InitFunction(...)
  }
}
