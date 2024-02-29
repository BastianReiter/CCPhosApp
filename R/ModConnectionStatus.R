

# --- MODULE: ConnectionStatus ---

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @noRd
ModConnectionStatus_UI <- function(id)
{
    ns <- NS(id)

    tagList(fluidRow(
                      # Status Icon
                      uiOutput(ns("StatusIcon")),

                      # Status Text
                      textOutput(ns("StatusText")),

                      # Logout Button
                      action_button(ns("LogoutButton"),
                                    label = "Logout")))
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module server component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param input
#' @param output
#' @param session
#' @noRd
ModConnectionStatus_Server <- function(id)
{
    moduleServer(id,
                 function(input, output, session)
                 {
                      output$StatusIcon <- renderUI({ if (is.null(session$userData$CCPConnections())) { icon(class = "circle outline") }
                                                      if (!is.null(session$userData$CCPConnections())) { icon(class = "check") } })

                      output$StatusText <- renderText({ if (is.null(session$userData$CCPConnections())) { "No connection to CCP" }
                                                        if (!is.null(session$userData$CCPConnections())) { "Connected to CCP" } })

                      observe({ if (is.null(session$userData$CCPConnections())) { shinyjs::disable("LogoutButton") }
                                if (!is.null(session$userData$CCPConnections())) { shinyjs::enable("LogoutButton") } })

                      observe({ DSI::datashield.logout(session$userData$CCPConnections())
                                session$userData$CCPConnections(NULL) }) %>%
                          bindEvent(input$LogoutButton)

                 })
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module testing
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ModConnectionStatusApp <- function()
{
  ui <- fluidPage(
    ModConnectionStatus_UI("Test")
  )

  server <- function(input, output, session)
  {
      ModConnectionStatus_Server("Test")
  }

  shinyApp(ui, server)
}

# Run app
#ModConnectionStatusApp()


