

# --- MODULE: CurationReport ---

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @noRd
ModCurationReport_UI <- function(id)
{
    ns <- NS(id)

    div(id = ns("CurationReportContainer"),
        #class = "ui scrollable segment",
        style = "height: 100%;
                 overflow: auto;",

        uiOutput(outputId = ns("UnlinkedEntries")),

        br(),

        uiOutput(outputId = ns("DiagnosisClassification")))
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module server component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param input
#' @param output
#' @param session
#' @noRd
ModCurationReport_Server <- function(id)
{
    moduleServer(id,
                 function(input, output, session)
                 {
                      output$UnlinkedEntries <- renderUI({  req(session$userData$CurationReport())

                                                            # Modify table data
                                                            TableData <- session$userData$CurationReport()$UnlinkedEntries

                                                            if (!is.null(TableData))
                                                            {
                                                               DataFrameToHtmlTable(DataFrame = as.data.frame(TableData),
                                                                                    ColContentHorizontalAlign = "center",
                                                                                    ColumnLabels = c(SiteName = "Site"),
                                                                                    ColumnMaxWidth = 14,
                                                                                    SemanticTableClass = "ui small compact celled structured table")
                                                            }
                                                         })

                      output$DiagnosisClassification <- renderUI({  req(session$userData$CurationReport())

                                                                    # Modify table data
                                                                    TableData <- session$userData$CurationReport()$DiagnosisClassification

                                                                    if (!is.null(TableData))
                                                                    {
                                                                       DataFrameToHtmlTable(DataFrame = as.data.frame(TableData),
                                                                                            ColContentHorizontalAlign = "center",
                                                                                            ColumnLabels = c(SiteName = "Site"),
                                                                                            SemanticTableClass = "ui small compact celled structured table")
                                                                    }
                                                                 })
                 })
}

