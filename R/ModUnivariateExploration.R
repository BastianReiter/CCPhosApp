

# --- MODULE: UnivariateExploration ---

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @noRd
ModUnivariateExploration_UI <- function(id)
{
    ns <- NS(id)

    div(style = "display: grid;
                 grid-template-columns: 14em auto;
                 grid-gap: 2em;",

    # Left column
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    div(selectInput(inputId = ns("TableName"),
                    label = "Select Table",
                    choices = "ADS_Patients"),

        br(),

        selectInput(inputId = ns("FeatureName"),
                    label = "Select Feature",
                    choices = "PatientAgeAtDiagnosis"),

        br(),

        action_button(input_id = ns("ExploreButton"),
                      label = "Explore")),

    # Middle column
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    # Right column
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    div(div(uiOutput(ns("StatisticsTable"))),

        br(),br(),

        div(plotOutput(ns("StatisticsPlot")))))
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module server component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param input
#' @param output
#' @param session
#' @noRd
ModUnivariateExploration_Server <- function(id)
{
    moduleServer(id,
                 function(input, output, session)
                 {
                      observe({ SampleStatistics <- dsCCPhosClient::ds.GetSampleStatistics(TableName = input$TableName,
                                                                                           MetricFeatureName = input$FeatureName,
                                                                                           DataSources = session$userData$CCPConnections())
                                output$StatisticsTable <- renderUI({ DataFrameToHtmlTable(DataFrame = SampleStatistics,
                                                                                          SemanticTableClass = "ui small very compact selectable celled table") })

                                output$StatisticsPlot <- renderPlot({ dsCCPhosClient::MakeBoxPlot(SampleStatistics = SampleStatistics,
                                                                                                  AxisTitle_y = "Patient age at diagnosis",
                                                                                                  FillPalette = c("All" = CCPhosColors$MediumGrey,
                                                                                                                  "SiteA" = CCPhosColors$Primary,
                                                                                                                  "SiteB" = CCPhosColors$Secondary,
                                                                                                                  "SiteC" = CCPhosColors$Tertiary)) })
                                }) %>%
                          bindEvent(input$ExploreButton)

                 })
}




