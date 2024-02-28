

# --- Module: Processing Terminal ---


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' Module ProcessingTerminal UI function
#'
#' @param id
#' @noRd
ModProcessingTerminal_UI <- function(id,
                                     ButtonLabel)
{
    ns <- NS(id)

    tagList(action_button(ns("ProcessingTrigger"),
                          label = ButtonLabel),
            textOutput(ns("ProcessingMonitor"))
    )
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module Server
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' Module ProcessingTerminal Server function
#'
#' @param id
#' @param input
#' @param output
#' @param session
#' @noRd
ModProcessingTerminal_Server <- function(id)
{

    moduleServer(id,
                 function(input, output, session)
                 {
                    w <- waiter::Waiter$new(id = "ProcessingMonitor")

                    #output$ProcessingMonitor <- renderText({ w$show() })


                    if (id == "CheckServerRequirements")
                    {
                        observeEvent(input$ProcessingTrigger,
                                     {
                                        Return <- dsCCPhosClient::CheckServerRequirements(DataSources = session$userData$CCPConnections)

                                        output$ProcessingMonitor <- renderText({ w$show()
                                                                                 paste0(unlist(Return), collapse = " ") })
                                     })
                    }

                 })
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


