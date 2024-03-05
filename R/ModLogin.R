

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

    div(class = "ui segment",
        style = "background: #f9fafb;
                 border-color: rgba(34, 36, 38, 0.15);
                 box-shadow: 0 2px 25px 0 rgba(34, 36, 38, 0.05) inset;",

        h4(class = "ui dividing header",
           "Connect to CCP sites"),

        div(style = "padding: 2em 4em;
                     text-align: center",


            semantic_DTOutput(ns("TableCredentials")),

            action_button(ns("ButtonLogin"),
                          label = "Connect to CCP")),

        div(class = "ui horizontal divider", "Or"),

        div(style = "padding: 2em 4em;
                     text-align: center;",

            div(class = "ui form",

                div(class = "two fields",

                    div(class = "field",
                        tags$label("Number of sites"),
                        text_input(ns("NumberOfSites"),
                                   value = "3")),

                    div(class = "field",
                        tags$label("Number of patients per site"),
                        text_input(ns("NumberOfPatientsPerSite"),
                                   value = "1000"))),

                action_button(ns("ButtonLoginVirtual"),
                              label = "Connect to virtual CCP"))))
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
    require(shinyvalidate)

    moduleServer(id,
                 function(input, output, session)
                 {
                    #w <- waiter::Waiter$new(id = "ProcessingMonitor")

                    # --- Server logic real CCP connection ---

                    output$TableCredentials <- DT::renderDataTable(semantic_DT(dsCCPhosClient::CCPSiteCredentials,
                                                                               options = list(filters = "none",
                                                                                              editable = "all"))
                                                                   )


                    observe({
                              #waiter::Waiter$new(id = "ProcessingMonitor")$show()

                              session$userData$CCPConnections(dsCCPhosClient::ConnectToCCP(CCPSiteCredentials = session$userData$CCPCredentials))
                           }) %>%
                        bindEvent(input$ButtonLogin)


                    # --- Server logic virtual CCP connection ---

                    observe({ #waiter::Waiter$new(id = "ProcessingMonitor")$show()

                              session$userData$CCPConnections(dsCCPhosClient::ConnectToVirtualCCP(CCPTestData = session$userData$CCPTestData,
                                                                                                  NumberOfSites = as.integer(input$NumberOfSites),
                                                                                                  NumberOfPatientsPerSite = as.integer(input$NumberOfPatientsPerSite)))
                           }) %>%
                        bindEvent(input$ButtonLoginVirtual)
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


