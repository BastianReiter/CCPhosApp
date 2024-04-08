

# --- MODULE: ServerOpalMonitor ---

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @noRd
ModServerOpalMonitor_UI <- function(id)
{
    ns <- NS(id)

    div(id = ns("ServerOpalMonitorContainer"),
        class = "ui scrollable segment",
        style = "height: 100%;
                 overflow: auto;
                 margin: 0;",

        div(class = "ui top attached label",
            "Server Opal Monitor"),

        uiOutput(ns("ServerOpalMonitor")))
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module server component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param input
#' @param output
#' @param session
#' @noRd
ModServerOpalMonitor_Server <- function(id)
{
    moduleServer(id,
                 function(input, output, session)
                 {
                      output$ServerOpalMonitor <- renderUI({  if(!is.null(session$userData$ServerOpalInfo()))
                                                              {
                                                                  DataServerOpalInfo <- session$userData$ServerOpalInfo() %>%
                                                                                            select(-IsAvailableEverywhere,
                                                                                                   -NotAvailableAt)

                                                                  DataFrameToHtmlTable(DataFrame = DataServerOpalInfo,
                                                                                       SemanticTableClass = "ui small very compact selectable celled table",
                                                                                       TurnLogicalIntoIcon = TRUE)
                                                              } })
                 })
}

