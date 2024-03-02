

# --- MODULE: Processing Terminal ---

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param ButtonLabel
#' @noRd
ModProcessingTerminal_UI <- function(id,
                                     ButtonLabel)
{
    ns <- NS(id)

    tagList(action_button(ns("ProcessingTrigger"),
                          label = ButtonLabel),

            ModMessageMonitor_UI(ns("MonitorCheckServerRequirements")))
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module server component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

                    if (id == "CheckServerRequirements")
                    {
                        FunctionReturn <- reactiveVal(NULL)

                        observe({ FunctionReturn(dsCCPhosClient::CheckServerRequirements(DataSources = session$userData$CCPConnections())) }) %>%
                            bindEvent(input$ProcessingTrigger)


                        ModMessageMonitor_Server("MonitorCheckServerRequirements",
                                                 MessagesList = FunctionReturn)
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


