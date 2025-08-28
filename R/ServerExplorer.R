
#' ServerExplorer
#'
#' Launch Module \code{ModServerExplorer} as a Shiny app in a background process so it runs independently from hosting R session.
#'
#' @param ServerWorkspaceInfo \code{list} containing the previously obtained results of \code{dsCCPhosClient::GetServerWorkspaceInfo()}. Default is \code{NULL}, which means these info data are obtained by the app itself.
#' @param DSConnections \code{list} of \code{DSConnection} objects
#' @param RunAutonomously \code{logical} indicating whether the Shiny app is hosted by a background process (default) available as a URL via web browsers or - if set to \code{FALSE} - is hosted by the current running R session.
#' @param RunInViewer \code{logical} indicating whether the Shiny app should be run in the RStudio Viewer pane (Default: \code{FALSE})
#' @param EndProcessWhenClosingApp \code{logical} indicating whether the background process that runs the Shiny app (if it runs autonomously) should end when the app is closed (default) or should be preserved, in which case it should be ended manually.
#'
#' @result When 'RunAutonomously' is set to \code{TRUE} this function can return the background process to make it assignable to an R symbol. Otherwise it will run/return a \code{shinyApp} object.
#'
#' @export
#' @author Bastian Reiter
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ServerExplorer <- function(#--- Arguments for app itself ---
                           ServerWorkspaceInfo = NULL,
                           DSConnections = NULL,
                           #--- Arguments for app wrapper ---
                           EndProcessWhenClosingApp = TRUE,
                           RunAutonomously = TRUE,
                           RunInViewer = FALSE,
                           ...)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
  # --- For Testing Purposes ---#
  # DSConnections <- CCPConnections
  # ServerWorkspaceInfo <- dsCCPhosClient::GetServerWorkspaceInfo(DSConnections = DSConnections)

  # Check validity of 'DSConnections' or find them programmatically if none are passed
  DSConnections <- CheckDSConnections(DSConnections)

  # If no 'ServerWorkspaceInfo' object is passed, get it programmatically
  if (is.null(ServerWorkspaceInfo)) { ServerWorkspaceInfo <- GetServerWorkspaceInfo(DSConnections = DSConnections) }

#-------------------------------------------------------------------------------

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

      # Mini-App UI function
      UI <- function()
      {
          shiny.semantic::semanticPage(

              #textOutput(outputId = "TestMonitor"),

              div(h4(class = "ui dividing header",
                     "Server Explorer"),

                  div(style = "height: 40em;",

                      ModServerExplorer_UI("ServerExplorer")),

                  #-------------------------------------------------------------
                  div(class = "ui divider"),
                  #-------------------------------------------------------------

                  div(ModUnivariateExploration_UI("UnivariateExploration")))
          )
      }

      # Mini-App server function
      Server <- function(input, output, session)
      {
          WaiterScreen <- CreateWaiterScreen(ID = "WaiterScreenContainer")

          # Initialize global objects
          session$userData$DSConnections <- reactiveVal(NULL)
          session$userData$ServerWorkspaceInfo <- reactiveVal(NULL)

          # output$TestMonitor <- renderText({  req(session$userData$DSConnections())
          #                                     paste0(names(session$userData$DSConnections()), collapse = ", ") })

          # 'ModInitialize' assigns content to session$userData objects at app start
          ModInitialize(id = "Initialize",
                        DSConnections = DSConnections,
                        ServerWorkspaceInfo = ServerWorkspaceInfo)

          # --- Call module server logic ---
          Selection <- ModServerExplorer_Server(id = "ServerExplorer")
          SelectedObject <- Selection$Object
          SelectedElement <- Selection$Element

          ModUnivariateExploration_Server(id = "UnivariateExploration",
                                          Selection)


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
