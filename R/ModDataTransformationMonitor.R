

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
                        choices = "")),

        div(style = "position: relative;",

            div(id = ns("WaiterScreenContainer"),
                style = "position: absolute;
                         height: 100%;
                         width: 100%;
                         top: 0.5em;
                         left: 0;"),

            gt_output(outputId = ns("TestTable"))))

            #uiOutput(ns("TransformationMonitorTable")))



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
    moduleServer(id,
                 function(input, output, session)
                 {
                      # Setting up loading screen with waiter package
                      ns <- session$ns
                      WaiterScreen <- Waiter$new(id = ns("WaiterScreenContainer"),
                                                 html = spin_3(),
                                                 color = transparent(.5))

                      #output$TransformationMonitorTable <- renderUI({})

                      observe({ updateSelectInput(session = getDefaultReactiveDomain(),
                                                      inputId = "SiteName",
                                                      choices = names(session$userData$CurationReports()))

                                updateSelectInput(session = getDefaultReactiveDomain(),
                                                  inputId = "MonitorTableName",
                                                  choices = names(session$userData$CurationReports()[[1]]$Transformation))
                                 }) %>%
                          bindEvent(session$userData$CurationReports())


                      #MonitorData <- reactive({ session$userData$CurationReports()[[input$SiteName]][[input$MonitorTableName]] })

                      output$TestTable <- render_gt({ # Set up loading behaviour
                                                      shinyjs::disable("SiteName")
                                                      shinyjs::disable("MonitorTableName")
                                                      WaiterScreen$show()

                                                      on.exit({ shinyjs::enable("SiteName")
                                                                shinyjs::enable("MonitorTableName")
                                                                WaiterScreen$hide() })

                                                      MonitorData <- session$userData$CurationReports()

                                                      tryCatch(
                                                          if (!is.null(MonitorData))
                                                          {
                                                              MonitorData[[input$SiteName]]$Transformation[[input$MonitorTableName]] %>%
                                                                   gt(groupname_col = "Feature") %>%
                                                                   dsCCPhosClient::gtTheme_CCP(TableAlign = "left", ShowNAs = TRUE, TableWidth = "80%") %>%
                                                                   tab_style(locations = cells_body(rows = (Value != "NA" & IsValueEligible == TRUE & Final > 0)),
                                                                             style = cell_fill(color = "green")) %>%
                                                                   tab_style(locations = cells_body(rows = (Value != "NA" & IsValueEligible == TRUE & Final == 0)),
                                                                             style = cell_fill(color = "lightgreen")) %>%
                                                                   tab_style(locations = cells_body(rows = (Value == "NA" | is.na(Value))),
                                                                             style = cell_fill(color = "gray")) %>%
                                                                   tab_style(locations = cells_body(columns = c(Value, IsValueEligible, Transformed),
                                                                                                    rows = (Value != "NA" & IsValueEligible == FALSE & Transformed > 0 & Final == 0)),
                                                                             style = cell_fill(color = "red")) %>%
                                                                   tab_style(locations = cells_body(columns = c(Value, IsValueEligible, Raw, Transformed),
                                                                                                    rows = (Value != "NA" & IsValueEligible == FALSE & Raw > 0 & Transformed == 0)),
                                                                             style = cell_fill(color = "orange"))
                                                            },
                                                            error = function(error) { print(paste0("The table can not be printed. Error message: ", error)) }) })
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


