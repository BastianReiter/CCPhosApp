

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
            "Opal Database"),

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

                                                                  ServerNames <- names(session$userData$CCPConnections())

                                                                  HorizontalAlignArgument <- setNames(object = rep("center", times = length(ServerNames)),
                                                                                                      nm = ServerNames)

                                                                  DataFrameToHtmlTable(DataFrame = DataServerOpalInfo,
                                                                                       ColContentHorizontalAlign = HorizontalAlignArgument,
                                                                                       SemanticTableClass = "ui small very compact celled table",
                                                                                       TurnLogicalIntoIcon = TRUE)
                                                              } })
                 })
}

