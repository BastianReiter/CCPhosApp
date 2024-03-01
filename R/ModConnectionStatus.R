

# --- MODULE: ConnectionStatus ---

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @noRd
ModConnectionStatus_UI <- function(id)
{
    ns <- NS(id)

    tagList(split_layout(style = "grid-template-columns: none;    /* Set to 'none', otherwise horizontal space would be evenly distributed (default) */
                                  justify-content: end;    /* Align grid items horizontally to the right side */
                                  align-items: center;",    # Align grid items vertically

                         cell_args = "padding: 10px;",

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
                      output$StatusIcon <- renderUI({ if (is.list(session$userData$CCPConnections())) { icon(class = "large green power off") }
                                                      else { icon(class = "large grey power off") } })

                      output$StatusText <- renderText({ if (is.list(session$userData$CCPConnections())) { "Connected to CCP" }
                                                        else { "No connection established" } })

                      observe({ if (is.list(session$userData$CCPConnections())) { shinyjs::enable("LogoutButton") }
                                else { shinyjs::disable("LogoutButton") } })

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


