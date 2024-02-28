

# --- Module: Login ---


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' Module Login UI function
#'
#' @param id
#' @noRd
ModLogin_UI <- function(id)
{
    ns <- NS(id)


    tagList(action_button(ns("LoginButton"),
                          label = "Connect to CCP"),

            action_button(ns("LoginButton_Virtual"),
                          label = "Connect to virtual CCP"),



            textOutput(ns("ProcessingMonitor"))
    )
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module Server
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' Module Login Server function
#'
#' @param id
#' @param input
#' @param output
#' @param session
#' @noRd
ModLogin_Server <- function(id)
{
    moduleServer(id,
                 function(input, output, session)
                 {
                    #w <- waiter::Waiter$new(id = "ProcessingMonitor")

                    output$ProcessingMonitor <- renderText({length(session$userData$CCPTestData)})

                    observeEvent(input$LoginButton,
                                 {
                                    #waiter::Waiter$new(id = "ProcessingMonitor")$show()

                                    session$userData$CCPConnections <- dsCCPhosClient::ConnectToCCP(CCPSiteCredentials = session$userData$CCPCredentials)
                                 })

                    observeEvent(input$LoginButton_Virtual,
                                 {
                                    #waiter::Waiter$new(id = "ProcessingMonitor")$show()

                                    session$userData$CCPConnections <- dsCCPhosClient::ConnectToVirtualCCP(CCPTestData = session$userData$CCPTestData,
                                                                                                           NumberOfSites = 3,
                                                                                                           NumberOfPatientsPerSite = 1000)
                                 })
                 })
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module testing
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

LoginApp <- function()
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
#LoginApp()


