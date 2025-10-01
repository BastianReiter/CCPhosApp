
#' Widget.ProcessingMonitor
#'
#' Launch a Shiny app that facilitates interacting with output of processing monitoring, like data transformation tracks and data set checks.
#'
#' @param ServerSpecifications \code{data.frame} containing credentials for login
#' @param DSConnections \code{list} of \code{DSConnection} objects
#' @param RunAutonomously \code{logical} indicating whether the Shiny app is hosted by a background process (default) available as a URL via web browsers or - if set to \code{FALSE} - is hosted by the current running R session.
#' @param RunInViewer \code{logical} indicating whether the Shiny app should be run in the RStudio Viewer pane (Default: \code{FALSE})
#' @param EndProcessWhenClosingApp \code{logical} indicating whether the background process that runs the Shiny app (if it runs autonomously) should end when the app is closed (default) or should be preserved, in which case it should be ended manually.
#'
#' @return When 'RunAutonomously' is set to \code{TRUE} this function can return the background process to make it assignable to an R symbol. Otherwise it will run/return a \code{shinyApp} object.
#'
#' @export
#' @author Bastian Reiter
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Widget.ProcessingMonitor <- function(#--- Arguments for app itself ---
                                     ServerSpecifications = NULL,
                                     DSConnections = NULL,
                                     #--- Arguments for app wrapper ---
                                     EnableLiveConnection = TRUE,
                                     EndProcessWhenClosingApp = TRUE,
                                     RunAutonomously = TRUE,
                                     RunInViewer = FALSE,
                                     UseVirtualConnections = FALSE,
                                     ...)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
  require(assertthat)

  # --- For Testing Purposes ---#
  # DSConnections <- CCPConnections
  # ServerWorkspaceInfo <- dsCCPhosClient::GetServerWorkspaceInfo(DSConnections = DSConnections)

  # --- Argument Assertions ---
  assert_that(is.logical(EndProcessWhenClosingApp),
              is.logical(RunAutonomously),
              is.logical(RunInViewer))

  if (!is.null(ServerSpecifications)) assert_that(is.data.frame(ServerSpecifications))
  if (!is.null(ServerWorkspaceInfo)) assert_that(is.list(ServerWorkspaceInfo))

  # Check validity of 'DSConnections' or find them programmatically if none are passed
  DSConnections <- CheckDSConnections(DSConnections)

#-------------------------------------------------------------------------------

  # --- Preparational settings ---
  if (UseVirtualConnections == TRUE) { EnableLiveConnection == FALSE }
  if (EnableLiveConnection == TRUE) { DSConnections <- NULL }

  # If no 'ServerWorkspaceInfo' object is passed, get it programmatically
  if (is.null(ServerWorkspaceInfo) && EnableLiveConnection == FALSE) { ServerWorkspaceInfo <- GetServerWorkspaceInfo(DSConnections = DSConnections) }


  # Create the app initiating function (UI and server component resulting in a ShinyApp object)
  InitFunction <- function(...)
  {
      require(dsCCPhosClient)
      require(dplyr)
      require(DSI)
      require(DT)
      #require(gt)
      #require(plotly)
      require(purrr)
      require(shiny)
      require(shinyjs)
      require(shiny.semantic)
      require(stringr)
      require(waiter)


      # Since the app is deployed as a package, the folder for external resources (e.g. CSS files, static images) needs to be added manually
      shiny::addResourcePath('www', system.file("www", package = "CCPhosApp"))

      #-------------------------------------------------------------------------
      # Widget UI component
      #-------------------------------------------------------------------------
      UI <- function()
      {
          Layout <- function(ns)
          {
              div(h4(class = "ui dividing header",
                  "Server Explorer"),

                  div(style = "height: 40em;",

                      ModServerExplorer_UI(ns("ServerExplorer"))),

                  div(class = "ui divider"),

                  div(ModUnivariateExploration_UI(ns("UnivariateExploration"))))
           }

           # Call Widget frame module UI and pass widget-specific UI layout
           ModWidget_UI(id = "ServerExplorerWidget",
                        Title = "CCPhos Server Explorer",
                        WidgetMainUI = Layout)
      }

      #-------------------------------------------------------------------------
      # Widget Server Logic
      #-------------------------------------------------------------------------
      Server <- function(input, output, session)
      {
          # Hide waiter loading screen after initial app load has finished
          waiter::waiter_hide()

          # Define widget-specific server logic that is passed to widget frame module
          WidgetServerLogic <- function(session)
                               {
                                  # The called module returns a list of reactive values...
                                  Selection <- ModServerExplorer_Server(id = "ServerExplorer")
                                  # ... that is passed to another module
                                  ModUnivariateExploration_Server(id = "UnivariateExploration",
                                                                  Selection)
                                }

          # Call Widget frame module and pass widget-specific server logic
          ModWidget_Server(id = "ServerExplorerWidget",
                           WidgetServerLogic,
                           EnableLiveConnection)

          #---------------------------------------------------------------------

          # Initialize global objects
          session$userData$DSConnections <- reactiveVal(NULL)
          session$userData$ServerSpecifications <- reactiveVal(NULL)
          session$userData$ServerWorkspaceInfo <- reactiveVal(NULL)

          # output$TestMonitor <- renderText({  req(session$userData$ServerWorkspaceInfo())
          #                                     paste0(names(session$userData$ServerWorkspaceInfo()), collapse = ", ") })


          # 'ModInitialize' assigns content to session$userData objects at app start
          ModInitialize(id = "Initialize",
                        DSConnections = DSConnections,
                        ServerSpecifications = ServerSpecifications,
                        ServerWorkspaceInfo = ServerWorkspaceInfo)


          # If the option 'EndProcessWhenClosingApp' is TRUE, the following ensures that the background process is automatically ending when the app shuts down
          if (EndProcessWhenClosingApp == TRUE) { session$onSessionEnded(function() { stopApp() }) }
      }

      # Return Mini-App
      shiny::shinyApp(ui = UI,
                      server = Server)
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
