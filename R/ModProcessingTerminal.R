
#' Module ProcessingTerminal UI function
#'
#' @param id
#' @noRd
ModProcessingTerminal_UI <- function(id)
{
    tagList(action_button(NS(id, "ProcessingTrigger"),
                          label = "Test"),
            textOutput(NS(id, "ProcessingMonitor"))
    )
}


#' Module ProcessingTerminal Server function
#'
#' @param id
#' @param input
#' @param output
#' @param session
#' @noRd
ModProcessingTerminal_Server <- function(id,
                                         CCPTestData = reactiveVal(NULL))
{
    # Check if 'CCPTestData' is reactive
    stopifnot(is.reactive(CCPTestData))

    CCPConnections <- reactiveVal(NULL)

    moduleServer(id,
                 function(input, output, session)
                 {

                    observeEvent(eventExpr = input$ProcessingTrigger,
                                 handlerExpr = {
                                                  if (id == "EnterCredentials")
                                                  {

                                                  }
                                                  else if (id == "ConnectToCCP")
                                                  {
                                                      CCPConnections <- dsCCPhosClient::ConnectToVirtualCCP(CCPTestData = CCPTestData(),
                                                                                                            NumberOfSites = 3,
                                                                                                            NumberOfPatientsPerSite = 1000)
                                                      # Store Return in gloabl reactive variable CCPConnections
                                                      #CCPConnections(Return)
                                                  }
                                                  else if (id == "CheckServerRequirements")
                                                  {
                                                      Return <- dsCCPhosClient::CheckServerRequirements(DataSources = CCPConnections())

                                                      output$ProcessingMonitor <- renderText({ paste0(unlist(Return), collapse = " ") })
                                                  }
                                               })

                    return(reactiveVal(CCPConnections))
                 }
    )
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module testing
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ProcessingTerminalApp <- function()
{
  ui <- fluidPage(
    ModProcessingTerminal_UI("Connect")
  )

  server <- function(input, output, session)
  {
      ModProcessingTerminal_Server("Connect")
  }

  shinyApp(ui, server)
}

# Run app
#ProcessingTerminalApp()


