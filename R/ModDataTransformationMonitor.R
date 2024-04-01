

# --- MODULE: DataTransformationMonitor ---

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @noRd
ModDataTransformationMonitor_UI <- function(id)
{
    ns <- NS(id)

    div(style = "display: grid;
                 grid-template-columns: 14em auto;
                 grid-gap: 2em;",


        div(selectInput(inputId = ns("SiteName"),
                        label = "Select Site",
                        choices = ""),

            selectInput(inputId = ns("MonitorTableName"),
                        label = "Select Table",
                        choices = ""),

            br(), br(),

            toggle(input_id = ns("ShowNonOccurringValues"),
                   label = "Show non-occurring eligible values",
                   is_marked = FALSE)),


        div(style = "position: relative;",

            div(id = ns("WaiterScreenContainer"),
                style = "position: absolute;
                         height: 100%;
                         width: 100%;
                         top: 0.5em;
                         left: 0;"),

            uiOutput(outputId = ns("TransformationMonitorTable"))))
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module server component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param input
#' @param output
#' @param session
#' @noRd
ModDataTransformationMonitor_Server <- function(id)
{
    require(dplyr)
    require(stringr)

    moduleServer(id,
                 function(input, output, session)
                 {
                      # Setting up loading screen with waiter package
                      ns <- session$ns
                      WaiterScreen <- Waiter$new(id = ns("WaiterScreenContainer"),
                                                 html = spin_3(),
                                                 color = transparent(.5))


                      observe({ updateSelectInput(session = getDefaultReactiveDomain(),
                                                  inputId = "SiteName",
                                                  choices = names(session$userData$CurationReports()))

                                updateSelectInput(session = getDefaultReactiveDomain(),
                                                  inputId = "MonitorTableName",
                                                  choices = names(session$userData$CurationReports()[[1]]$Transformation))
                                 }) %>%
                          bindEvent(session$userData$CurationReports())


                      MonitorData <- reactive({ req(session$userData$CurationReports)
                                                req(input$SiteName)
                                                req(input$MonitorTableName)

                                                if (!is.null(session$userData$CurationReports()))
                                                {
                                                    session$userData$CurationReports()[[input$SiteName]]$Transformation[[input$MonitorTableName]] %>%
                                                                mutate(CellClass_Value_Raw = case_when(IsOccurring == FALSE & IsEligible_Raw == TRUE ~ "CellClass_Info",
                                                                                                       IsOccurring == TRUE & IsEligible_Raw == TRUE ~ "CellClass_Success",
                                                                                                       !is.na(Value_Raw) & IsEligible_Raw == FALSE ~ "CellClass_Failure",
                                                                                                       is.na(Value_Raw) ~ "CellClass_Grey",
                                                                                                       TRUE ~ "None"),
                                                                       CellClass_Value_Transformed = case_when(IsOccurring == TRUE & IsEligible_Transformed == TRUE ~ "CellClass_Success",
                                                                                                               !is.na(Value_Transformed) & IsEligible_Transformed == FALSE ~ "CellClass_Failure",
                                                                                                               is.na(Value_Transformed) ~ "CellClass_Grey",
                                                                                                               TRUE ~ "None"),
                                                                       CellClass_Value_Final = case_when(!is.na(Value_Final) ~ "CellClass_Success",
                                                                                                         is.na(Value_Final) ~ "CellClass_Grey",
                                                                                                         TRUE ~ "None"))

                                                        # Data <- Data %>%
                                                        #             select(Feature,
                                                                    #        Raw,
                                                                    #        Transformed,
                                                                    #        Final,
                                                                    #        RowColor,
                                                                    #        IsEligible_Raw)

                                                } })


                      # Filter layer over MonitorData
                      MonitorDataFilter <- reactive({   req(MonitorData)

                                                        # Filter for occurring values only, if option checked in UI
                                                        if (input$ShowNonOccurringValues == FALSE)
                                                        {
                                                            MonitorData() %>%
                                                                filter(IsOccurring == TRUE)
                                                        }
                                                        else { MonitorData() }
                                                    })


                      output$TransformationMonitorTable <- renderUI({ req(MonitorDataFilter)

                                                                      # Set up loading behaviour
                                                                      shinyjs::disable("SiteName")
                                                                      shinyjs::disable("MonitorTableName")
                                                                      WaiterScreen$show()

                                                                      on.exit({ shinyjs::enable("SiteName")
                                                                                shinyjs::enable("MonitorTableName")
                                                                                WaiterScreen$hide() })

                                                                      if (!is.null(MonitorDataFilter()))
                                                                      {
                                                                          DataFrameToHtmlTable(DataFrame = MonitorDataFilter(),
                                                                                               SemanticTableClass = "ui small compact celled structured table",
                                                                                               CategoryColumn = "Feature",
                                                                                               CellClassColumns = c("CellClass_Value_Raw",
                                                                                                                    "CellClass_Value_Transformed",
                                                                                                                    "CellClass_Value_Final"))
                                                                      } })
                 })
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module testing
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ModDataTransformationMonitorApp <- function()
# {
#   ui <- fluidPage(
#     ModDataTransformationMonitor_UI("Test")
#   )
#
#   server <- function(input, output, session)
#   {
#       ModDataTransformationMonitor_Server("Test")
#   }
#
#   shinyApp(ui, server)
# }

# Run app
#ModDataTransformationMonitorApp()


