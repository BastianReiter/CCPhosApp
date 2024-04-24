

# --- MODULE: ServerWorkspaceMonitor ---

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @noRd
ModServerWorkspaceMonitor_UI <- function(id)
{
    ns <- NS(id)

    div(id = ns("ServerWorkspaceMonitorContainer"),
        class = "ui scrollable segment",
        style = "height: 100%;
                 overflow: auto;
                 margin: 0;",

        div(class = "ui top attached label",
            "Server R Session Workspace"),

        div(style = "display: grid;
                     grid-template-columns: auto auto;
                     grid-gap: 1em;
                     margin: 0;",

            div(style = "height: 100%;
                         overflow: auto;",

                uiOutput(ns("WorkspaceObjects"))),

            div(style = "height: 100%;
                         overflow: auto;",

                uiOutput(ns("ObjectDetails")))))

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
                      output$WorkspaceObjects <- renderUI({ DataWorkspaceOverview <- session$userData$ServerWorkspaceInfo()$Overview

                                                            ServerNames <- names(session$userData$CCPConnections())

                                                            HorizontalAlignArgument <- setNames(object = rep("center", times = length(ServerNames)),
                                                                                                 nm = ServerNames)

                                                            DataFrameToHtmlTable(DataFrame = DataWorkspaceOverview,
                                                                                 ColContentHorizontalAlign = HorizontalAlignArgument,
                                                                                 SemanticTableClass = "ui small very compact selectable celled scrollable table",
                                                                                 TurnLogicalIntoIcon = TRUE) })

                      output$ObjectDetails <- renderUI({ DataObjectDetails <- session$userData$ServerWorkspaceInfo()$Details[[1]]$ContentOverview

                                                         # HorizontalAlignAttribute <- setNames(object = rep("center", times = length(ServerNames)),
                                                         #                                      nm = ServerNames)

                                                         DataFrameToHtmlTable(DataFrame = DataObjectDetails,
                                                                              SemanticTableClass = "ui small very compact celled inverted grey scrollable table",
                                                                              TurnLogicalIntoIcon = TRUE) })

                 })
}
