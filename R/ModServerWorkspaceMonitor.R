

# --- MODULE: ServerWorkspaceMonitor ---

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @noRd
ModServerWorkspaceMonitor_UI <- function(id)
{
    ns <- NS(id)

    div(style = "display: grid;
                 grid-template-columns: 1fr;
                 grid-gap: 1em;
                 height: 22em;",


        div(id = ns("ServerWorkspaceContainer"),
            class = "ui scrollable segment",
            style = "height: 100%;
                     overflow: auto;",

            div(class = "ui top attached label",
                "Server Workspace"),

            uiOutput(ns("ServerWorkspace"))))


        # div(id = ns("ServerObjectDetailsContainer"),
        #     class = "ui scrollable segment",
        #     stlye = "height: 100%;
        #              overflow: auto;",
        #
        #     div(class = "ui top attached label",
        #         "Server Object Details"),
        #
        #     uiOutput(ns("ServerObjectDetails"))))

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
                      output$ServerWorkspace <- renderUI({ DataFrameToHtmlTable(DataFrame = session$userData$ServerWorkspaceInfo(),
                                                                                SemanticTableClass = "ui small very compact selectable celled table",
                                                                                TurnLogicalIntoIcons = TRUE) })

                      output$ServerObjectDetails <- renderUI({ "- Under construction -" })
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


