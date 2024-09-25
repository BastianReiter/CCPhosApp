

# --- MODULE: RDSTableMonitor ---

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @noRd
ModRDSTableMonitor_UI <- function(id)
{
    ns <- NS(id)

    div(id = ns("RDSTableMonitorContainer"),
        style = "",

        uiOutput(outputId = ns("TableStatus")),

        div(style = "display: grid;
                     grid-template-columns: 1fr 3fr 1fr;",

            div(),

            div(class = "ui segment",
                style = "margin: 2em;",

                div(class = "ui top attached label",
                    "RDS Table Feature Status"),

                uiOutput(outputId = ns("FeatureStatus"))),

            div()))
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module server component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param input
#' @param output
#' @param session
#' @noRd
ModRDSTableMonitor_Server <- function(id)
{
    require(dplyr)
    require(purrr)

    moduleServer(id,
                 function(input, output, session)
                 {
                      ns <- session$ns

                      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      # Render reactive output: Table status overview
                      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      output$TableStatus <- renderUI({  req(session$userData$RDSTableCheck())

                                                            # Modify table data
                                                            TableData <- session$userData$RDSTableCheck()$TableStatus %>%
                                                                              select(-CheckRDSTables)

                                                            if (!is.null(TableData))
                                                            {
                                                               DataFrameToHtmlTable(DataFrame = TableData,
                                                                                    ColContentHorizontalAlign = "center",
                                                                                    ColumnLabels = c(SiteName = "Site"),
                                                                                    SemanticTableClass = "ui small compact celled structured table",
                                                                                    TurnColorValuesIntoDots = TRUE)
                                                            }
                                                        })


                      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      # Render reactive output: Table feature status details
                      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                      # Dynamically create empty UI elements to be filled further down
                      output$FeatureStatus <- renderUI({  req(session$userData$RDSTableCheck())

                                                          TableOutputList <- list()

                                                          TableList <- session$userData$RDSTableCheck()$FeatureStatus

                                                          # Using for-loop instead of purrr-functionality because there is no map-function that can access both names and index of list items
                                                          for (i in 1:length(TableList))
                                                          {
                                                              TableOutput <- div(style = "margin-top: 1em;",
                                                                                 div(class = "ui small grey ribbon label",
                                                                                     names(TableList)[i]),
                                                                                 div(style = "width: 1000px; overflow: auto;",
                                                                                     uiOutput(outputId = ns(paste0("FeatureStatus_", i)))))

                                                              TableOutputList <- list(TableOutputList,
                                                                                      TableOutput)
                                                          }

                                                          # Convert into tagList for html output
                                                          do.call(tagList, TableOutputList)
                                                      })


                      TableList_FeatureStatus <- reactive({ req(session$userData$RDSTableCheck())

                                                            HTMLTables <- session$userData$RDSTableCheck()$FeatureStatus %>%
                                                                              map(function(TableData)
                                                                                  {
                                                                                      # Turn data frame into html object
                                                                                      DataFrameToHtmlTable(DataFrame = TableData,
                                                                                                           ColContentHorizontalAlign = "center",
                                                                                                           ColumnLabels = c(SiteName = "Site"),
                                                                                                           SemanticTableClass = "ui small compact inverted scrollable structured table",
                                                                                                           TurnLogicalIntoIcon = TRUE)
                                                                                  })
                                                          })

                      output[["FeatureStatus_1"]] <- renderUI({ req(TableList_FeatureStatus); TableList_FeatureStatus()[[1]] })
                      output[["FeatureStatus_2"]] <- renderUI({ req(TableList_FeatureStatus); TableList_FeatureStatus()[[2]] })
                      output[["FeatureStatus_3"]] <- renderUI({ req(TableList_FeatureStatus); TableList_FeatureStatus()[[3]] })
                      output[["FeatureStatus_4"]] <- renderUI({ req(TableList_FeatureStatus); TableList_FeatureStatus()[[4]] })
                      output[["FeatureStatus_5"]] <- renderUI({ req(TableList_FeatureStatus); TableList_FeatureStatus()[[5]] })
                      output[["FeatureStatus_6"]] <- renderUI({ req(TableList_FeatureStatus); TableList_FeatureStatus()[[6]] })
                      output[["FeatureStatus_7"]] <- renderUI({ req(TableList_FeatureStatus); TableList_FeatureStatus()[[7]] })
                      output[["FeatureStatus_8"]] <- renderUI({ req(TableList_FeatureStatus); TableList_FeatureStatus()[[8]] })
                      output[["FeatureStatus_9"]] <- renderUI({ req(TableList_FeatureStatus); TableList_FeatureStatus()[[9]] })
                      output[["FeatureStatus_10"]] <- renderUI({ req(TableList_FeatureStatus); TableList_FeatureStatus()[[10]] })
                      output[["FeatureStatus_11"]] <- renderUI({ req(TableList_FeatureStatus); TableList_FeatureStatus()[[11]] })
                      output[["FeatureStatus_12"]] <- renderUI({ req(TableList_FeatureStatus); TableList_FeatureStatus()[[12]] })

                 })
}

