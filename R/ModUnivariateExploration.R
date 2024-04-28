

# --- MODULE: UnivariateExploration ---

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @noRd
ModUnivariateExploration_UI <- function(id)
{
    ns <- NS(id)

    div(class = "ui scrollable segment",
        style = "height: 100%;
                 overflow: auto;",

        div(class = "ui top attached label",
            "Univariate Exploration"),

    div(style = "display: grid;
                 grid-template-columns: 14em auto auto;
                 grid-gap: 2em;",

        # Left column
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        div(toggle(input_id = ns("AutoUpdate"),
                   label = "Auto-update rendering",
                   is_marked = FALSE),

            action_button(input_id = ns("UpdateButton"),
                          class = "ui icon button",
                          label = icon(class = "sync alternate"))),


        # Middle column
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        div(),


        # Right column
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        div(div(uiOutput(ns("StatisticsTable"))),

            br(),br(),

            div(plotOutput(ns("StatisticsPlot"))))))
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module server component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param input
#' @param output
#' @param session
#' @noRd
ModUnivariateExploration_Server <- function(id,
                                            ObjectSelection)
{
    moduleServer(id,
                 function(input, output, session)
                 {
                      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      # Setting up loading behavior
                      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      ns <- session$ns
                      WaiterScreen <- CreateWaiterScreen(ID = ns("WaiterScreenContainer"))

                      LoadingOn <- function()
                      {
                          shinyjs::disable("AutoUpdate")
                          shinyjs::disable("UpdateButton")
                          WaiterScreen$show()
                      }

                      LoadingOff <- function()
                      {
                          shinyjs::enable("AutoUpdate")
                          shinyjs::enable("UpdateButton")
                          WaiterScreen$hide()
                      }
                      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


                      # Create reactive expression that returns an expression triggering output rendering (by being bound to observe expression below)
                      TriggerUpdate <- reactive({ if (input$AutoUpdate == TRUE) { ObjectSelection$Element() } else { input$UpdateButton } })


                      observe({ req(session$userData$CCPConnections())
                                req(ObjectSelection)

                                LoadingOn()
                                on.exit(LoadingOff())

                                # if (input$AutoUpdate == TRUE)
                                # {
                                    SampleStatistics <- dsCCPhosClient::ds.GetSampleStatistics(TableName = ObjectSelection$Object(),
                                                                                               MetricFeatureName = ObjectSelection$Element(),
                                                                                               DataSources = session$userData$CCPConnections())

                                    output$StatisticsTable <- renderUI({ DataFrameToHtmlTable(DataFrame = SampleStatistics,
                                                                                              SemanticTableClass = "ui small very compact selectable celled table") })

                                    output$StatisticsPlot <- renderPlot({ dsCCPhosClient::MakeBoxPlot(SampleStatistics = SampleStatistics,
                                                                                                      AxisTitle_y = "Patient age at diagnosis",
                                                                                                      FillPalette = c("All" = CCPhosColors$MediumGrey,
                                                                                                                      "SiteA" = CCPhosColors$Primary,
                                                                                                                      "SiteB" = CCPhosColors$Secondary,
                                                                                                                      "SiteC" = CCPhosColors$Tertiary)) })
                                # }
                                # else
                                # {
                                #     output$StatisticsTable <- renderUI({ NULL })
                                #     output$StatisticsPlot <- renderUI({ NULL })
                                # }

                              }) %>%
                          bindEvent({ TriggerUpdate() })

                 })
}




