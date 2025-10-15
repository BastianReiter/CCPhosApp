

# --- MODULE: ServerOpalMonitor ---

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @noRd
#-------------------------------------------------------------------------------
ModServerOpalMonitor_UI <- function(id)
#-------------------------------------------------------------------------------
{
  ns <- NS(id)

  div(id = ns("ServerOpalMonitorContainer"),
      #class = "ui scrollable segment",
      style = "height: 100%;
               overflow: auto;",

      uiOutput(outputId = ns("ServerOpalMonitor")))
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module server component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @noRd
#-------------------------------------------------------------------------------
ModServerOpalMonitor_Server <- function(id)
#-------------------------------------------------------------------------------
{
  moduleServer(id,
               function(input, output, session)
               {
                  output$ServerOpalMonitor <- renderUI({  req(session$userData$ServerOpalInfo())

                                                          # Modify table data
                                                          TableData <- session$userData$ServerOpalInfo() %>%
                                                                            select(-CheckOpalTableAvailability)

                                                          if (!is.null(TableData))
                                                          {
                                                             DataFrameToHtmlTable(DataFrame = TableData,
                                                                                  ColContentHorizontalAlign = "center",
                                                                                  ColumnLabels = c(SiteName = "Site"),
                                                                                  SemanticTableCSSClass = "ui small compact celled structured table",
                                                                                  TurnLogicalsIntoIcons = TRUE)
                                                          }
                                                        })
               })
}

