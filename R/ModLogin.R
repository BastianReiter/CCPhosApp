

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

        #-----------------------------------------------------------------------
        # Connect to CCP
        #-----------------------------------------------------------------------

        div(style = "padding: 2em 4em;
                     text-align: center",

            div(class = "ui form",

                div(class = "inline field",
                    div(class = "ui right pointing label primary",
                        "Project name"),
                    text_input(ns("ProjectName"))),

                semantic_DTOutput(ns("TableCredentials")),

                br(),

                checkbox_input(input_id = "CheckTermsOfUse",
                               label = "I have read and agree to the CCP terms of use.",
                               is_marked = FALSE),

                br(),br(),

                action_button(ns("ButtonLogin"),
                              class = "ui blue button",
                              style = "box-shadow: 0 0 10px 10px white;",
                              label = "Connect to CCP"))),

        #-----------------------------------------------------------------------
        div(class = "ui horizontal divider", "Or"),
        #-----------------------------------------------------------------------

        #-----------------------------------------------------------------------
        # Connect to virtual CCP
        #-----------------------------------------------------------------------

        br(),br(),

        div(style = "display: grid;
                     grid-template-columns: auto 30em auto;",

            div(),

            div(class = "ui form",
                style = "text-align: center;",

                div(class = "fields",

                    div(class = "field",
                        tags$label("Number of virtual sites"),
                        text_input(ns("NumberOfSites"),
                                   value = "3")),

                    div(class = "field",
                        tags$label("Number of patients per site"),
                        text_input(ns("NumberOfPatientsPerSite"),
                                   value = "1000"))),

                action_button(ns("ButtonLoginVirtual"),
                              label = "Connect to virtual CCP")),

            div()))
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

                    output$TableCredentials <- DT::renderDT(semantic_DT(dsCCPhosClient::CCPSiteCredentials,
                                                                        options = list(dom = "t",
                                                                                       editable = TRUE)))

                    observe({
                              #waiter::Waiter$new(id = "ProcessingMonitor")$show()

                              session$userData$ProjectName(input$ProjectName)
                              session$userData$CCPConnections(dsCCPhosClient::ConnectToCCP(CCPSiteCredentials = session$userData$CCPCredentials()))
                           }) %>%
                        bindEvent(input$ButtonLogin)


                    # --- Server logic virtual CCP connection ---

                    observe({ #waiter::Waiter$new(id = "ProcessingMonitor")$show()

                              session$userData$ProjectName("Virtual")
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


