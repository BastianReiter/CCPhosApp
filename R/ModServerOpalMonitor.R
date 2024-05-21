

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

        DTOutput(ns("ServerOpalMonitor")))
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
                      output$ServerOpalMonitor <- renderDT({  req(session$userData$ServerOpalInfo())

                                                              DataServerOpalInfo <- session$userData$ServerOpalInfo() %>%
                                                                                        select(-NotAvailableAt) %>%
                                                                                        ConvertLogicalToIcon()

                                                              DT::datatable(data = DataServerOpalInfo,
                                                                            class = "ui small compact table",
                                                                            editable = FALSE,
                                                                            escape = FALSE,
                                                                            filter = "none",
                                                                            options = list(info = FALSE,
                                                                                           ordering = FALSE,
                                                                                           paging = FALSE,
                                                                                           searching = FALSE),
                                                                            rownames = FALSE,
                                                                            selection = list(mode = "none"),
                                                                            style = "semanticui")
                                                            })
                 })
}

