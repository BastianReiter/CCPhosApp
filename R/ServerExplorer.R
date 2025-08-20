
#' ServerExplorer
#'
#' Launch Module \code{ModServerExplorer} as a Shiny app.
#'
#' @param DSConnections \code{list} of \code{DSConnection} objects
#'
#' @export
#'
#' @author Bastian Reiter
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ServerExplorer <- function(ServerWorkspaceInfo = NULL,
                           DSConnections = NULL)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
  #require(DataEditR)
  require(dsCCPhosClient)
  require(dplyr)
  require(DSI)
  require(DT)
  #require(gt)
  #require(plotly)
  require(purrr)
  require(shiny)
  require(shinyjs)
  #require(shiny.router)
  require(shiny.semantic)
  require(stringr)
  require(waiter)


  # Check validity of 'DSConnections' or find them programmatically if none are passed
  DSConnections <- CheckDSConnections(DSConnections)

  # If no 'ServerWorkspaceInfo' object is passed, get it programmatically
  #if (is.null(ServerWorkspaceInfo)) { ServerWorkspaceInfo <- GetServerWorkspaceInfo(DSConnections = DSConnections) }

  ServerWorkspaceInfo <- GetServerWorkspaceInfo(DSConnections = DSConnections)

  # Since the app is deployed as a package, the folder for external resources (e.g. CSS files, static images) needs to be added manually
  shiny::addResourcePath('www', system.file("www", package = "CCPhosApp"))



  # Mini-App UI function
  UI <- function()
  {
      shiny.semantic::semanticPage(

          #textOutput(outputId = "TestMonitor"),

          ModServerExplorer_UI(id = "Test")
      )
  }


  # Mini-App server function
  Server <- function(input, output, session)
  {
      # Initialize global objects
      session$userData$DSConnections <- reactiveVal(NULL)
      session$userData$ServerWorkspaceInfo <- reactiveVal(NULL)


      # output$TestMonitor <- renderText({  req(session$userData$DSConnections())
      #                                     paste0(names(session$userData$DSConnections()), collapse = ", ") })

      # 'ModInitialize' assigns content to session$userData objects at app start
      ModInitialize(id = "Initialize",
                    DSConnections = DSConnections,
                    ServerWorkspaceInfo = ServerWorkspaceInfo)

      # Call module
      ModServerExplorer_Server(id = "Test")
  }


  # Start Mini-App
  shiny::shinyApp(ui = UI,
                  server = Server)
}
