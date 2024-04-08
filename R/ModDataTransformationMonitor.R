

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

            div(style = "display: grid;
                         grid-template-columns: 1fr 2fr;
                         grid-gap: 2em;
                         height: 100%;",

                uiOutput(outputId = ns("TransformationMonitor_Overview")),

                uiOutput(outputId = ns("TransformationMonitor_Details")))))
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
                      # Setting up loading behavior
                      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      ns <- session$ns
                      WaiterScreen <- Waiter$new(id = ns("WaiterScreenContainer"),
                                                 html = spin_3(),
                                                 color = transparent(.5))

                      LoadingOn <- function()
                      {
                          shinyjs::disable("SiteName")
                          shinyjs::disable("MonitorTableName")
                          shinyjs::disable("ShowNonOccurringValues")
                          WaiterScreen$show()
                      }

                      LoadingOff <- function()
                      {
                          shinyjs::enable("SiteName")
                          shinyjs::enable("MonitorTableName")
                          shinyjs::enable("ShowNonOccurringValues")
                          WaiterScreen$hide()
                      }


                      # Update input elements when data changes
                      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      observe({ updateSelectInput(session = getDefaultReactiveDomain(),
                                                  inputId = "SiteName",
                                                  choices = names(session$userData$CurationReports()))

                                updateSelectInput(session = getDefaultReactiveDomain(),
                                                  inputId = "MonitorTableName",
                                                  choices = names(session$userData$CurationReports()[[1]]$Transformation$Details))
                                 }) %>%
                          bindEvent(session$userData$CurationReports())


                      # Set up monitor data as reactive expression
                      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      MonitorData <- reactive({ req(session$userData$CurationReports)
                                                req(input$SiteName)
                                                req(input$MonitorTableName)

                                                if (!is.null(session$userData$CurationReports()))
                                                {
                                                    session$userData$CurationReports()[[input$SiteName]]$Transformation$Details[[input$MonitorTableName]] %>%
                                                        { if (input$ShowNonOccurringValues == FALSE) { filter(., IsOccurring == TRUE) } else {.} } %>%       # Filter for occurring values only, if option checked in UI
                                                        mutate(CellClass_Value_Raw = case_when(IsOccurring == FALSE & IsEligible_Raw == TRUE ~ "CellClass_Info",
                                                                                               IsOccurring == TRUE & IsEligible_Raw == TRUE ~ "CellClass_Success",
                                                                                               !is.na(Value_Raw) & IsEligible_Raw == FALSE ~ "CellClass_Failure",
                                                                                               is.na(Value_Raw) ~ "CellClass_Grey",
                                                                                               TRUE ~ "None"),
                                                               CellClass_Value_Harmonized = case_when(IsOccurring == TRUE & IsEligible_Harmonized == TRUE ~ "CellClass_Success",
                                                                                                      !is.na(Value_Harmonized) & IsEligible_Harmonized == FALSE ~ "CellClass_Failure",
                                                                                                      is.na(Value_Harmonized) ~ "CellClass_Grey",
                                                                                                      TRUE ~ "None"),
                                                               CellClass_Value_Recoded = case_when(IsOccurring == TRUE & IsEligible_Recoded == TRUE ~ "CellClass_Success",
                                                                                                   !is.na(Value_Recoded) & IsEligible_Recoded == FALSE ~ "CellClass_Failure",
                                                                                                   is.na(Value_Recoded) ~ "CellClass_Grey",
                                                                                                   TRUE ~ "None"),
                                                               CellClass_Value_Final = case_when(!is.na(Value_Final) ~ "CellClass_Success",
                                                                                                 is.na(Value_Final) ~ "CellClass_Grey",
                                                                                                 TRUE ~ "None"))
                                                }
                                              })


                      # Set up monitor data as reactive expression
                      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      MonitorDataOverview <- reactive({ req(MonitorData)


                                                # ValueSet_Raw <- MonitorData() %>%
                                                #                     select(Feature,
                                                #                            ends_with("_Raw"))
                                                #
                                                # ValueSet_Harmonized <- MonitorData() %>%
                                                #                             select(Feature,
                                                #                                    ends_with("_Harmonized")) %>%
                                                #                             distinct(pick(Feature, Value_Harmonized), .keep_all = TRUE)
                                                #
                                                # ValueSet_Recoded <- MonitorData() %>%
                                                #                         select(Feature,
                                                #                                ends_with("_Recoded")) %>%
                                                #                         distinct(pick(Feature, Value_Recoded), .keep_all = TRUE)
                                                #
                                                # ValueSet_Final <- MonitorData() %>%
                                                #                       select(Feature,
                                                #                              ends_with("_Final")) %>%
                                                #                       distinct(pick(Feature, Value_Final), .keep_all = TRUE)



                                              })




                      # Render reactive output: TransformationMonitor_Overview
                      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      output$TransformationMonitor_Overview <- renderUI({ req(MonitorData)

                                                                          # Assign loading behavior
                                                                          LoadingOn()
                                                                          on.exit(LoadingOff())



                                                                        })


                      # Render reactive output: TransformationMonitor_Details
                      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      output$TransformationMonitor_Details <- renderUI({  req(MonitorData)

                                                                          # Assign loading behavior
                                                                          LoadingOn()
                                                                          on.exit(LoadingOff())

                                                                          # Modify data for rendering purposes
                                                                          TableData <- MonitorData() %>%
                                                                                            select(Feature,
                                                                                                   Count_Raw,
                                                                                                   Value_Raw,
                                                                                                   Value_Harmonized,
                                                                                                   Value_Recoded,
                                                                                                   Value_Final,
                                                                                                   starts_with("CellClass"))

                                                                          if (!is.null(TableData))
                                                                          {
                                                                              DataFrameToHtmlTable(DataFrame = TableData,
                                                                                                   CategoryColumn = "Feature",
                                                                                                   CellClassColumns = c("CellClass_Value_Raw",
                                                                                                                        "CellClass_Value_Harmonized",
                                                                                                                        "CellClass_Value_Recoded",
                                                                                                                        "CellClass_Value_Final"),
                                                                                                   ColumnHorizontalAlign = "center",
                                                                                                   ColumnLabels = c(Count_Raw = "Count",
                                                                                                                    Value_Raw = "Raw",
                                                                                                                    Value_Harmonized = "Harmonized",
                                                                                                                    Value_Recoded = "Recoded",
                                                                                                                    Value_Final = "Final"),
                                                                                                   SemanticTableClass = "ui small compact celled structured table")
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


