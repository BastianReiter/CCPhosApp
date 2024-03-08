

# --- MODULE: ServerWorkspaceMonitor ---

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @noRd
ModServerWorkspaceMonitor_UI <- function(id)
{
    ns <- NS(id)

    div(id = ns("ServerObjectsContainer"),
        class = "ui scrollable segment",
        style = "height: 100%;
                 overflow: auto;",

        div(class = "ui top attached label",
            "Server Workspace"),

        uiOutput(ns("ServerObjects")))

}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module server component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param input
#' @param output
#' @param session
#' @noRd
ModServerWorkspaceMonitor_Server <- function(id)
{
    moduleServer(id,
                 function(input, output, session)
                 {
                      output$ServerObjects <- renderUI({ DataFrameToHtmlTable(DataFrame = session$userData$ServerWorkspaceInfo(),
                                                                              SemanticTableClass = "ui small very compact selectable celled table")



                                                        # ListRows <- purrr::modify(.x = session$userData$ServerWorkspaceInfo()$ObjectName,
                                                        #                            function(objectname)
                                                        #                            {
                                                        #                                 paste0("div(class = 'item', ",
                                                        #                                        "'", objectname, "'",
                                                        #                                        ")")
                                                        #                            })
                                                        #
                                                        #  HtmlCallString <- paste0("div(class = 'ui selection list', ",
                                                        #                           paste0(ListRows, collapse = ", "),
                                                        #                           ")")
                                                        #
                                                        #  eval(parse(text = HtmlCallString))


                                                         })
                 })
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module testing
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ModServerWorkspaceMonitorApp <- function()
# {
#   ui <- fluidPage(
#     ModServerWorkspaceMonitor_UI("Test")
#   )
#
#   server <- function(input, output, session)
#   {
#       ModServerWorkspaceMonitor_Server("Test")
#   }
#
#   shinyApp(ui, server)
# }

# Run app
#ModServerWorkspaceMonitorApp()


