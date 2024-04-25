

# --- MODULE: ServerWorkspaceMonitor ---

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param ShowObjectDetailTable
#' @noRd
ModServerWorkspaceMonitor_UI <- function(id,
                                         ShowObjectDetailTable = TRUE)
{
    ns <- NS(id)

    DisplayObjectDetails <- ifelse(ShowObjectDetailTable == TRUE,
                                   "display: block;",
                                   "display: none;")

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

            div(style = paste(DisplayObjectDetails,
                              "height: 100%;
                               overflow: auto;"),

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
                      ns <- session$ns

                      output$WorkspaceObjects <- renderUI({ DataWorkspaceOverview <- session$userData$ServerWorkspaceInfo()$Overview

                                                            ServerNames <- names(session$userData$CCPConnections())

                                                            HorizontalAlignArgument <- setNames(object = rep("center", times = length(ServerNames)),
                                                                                                nm = ServerNames)

                                                            DataFrameToHtmlTable(TableID = ns("TableWorkspaceObjects"),
                                                                                 DataFrame = DataWorkspaceOverview,
                                                                                 ColContentHorizontalAlign = HorizontalAlignArgument,
                                                                                 SemanticTableClass = "ui small very compact celled scrollable table",
                                                                                 TurnLogicalIntoIcon = TRUE) })

                      output$ObjectDetails <- renderUI({ DataObjectDetails <- session$userData$ServerWorkspaceInfo()$Details[[1]]$ContentOverview

                                                         # HorizontalAlignAttribute <- setNames(object = rep("center", times = length(ServerNames)),
                                                         #                                      nm = ServerNames)

                                                         DataFrameToHtmlTable(TableID = ns("TableObjectDetails"),
                                                                              DataFrame = DataObjectDetails,
                                                                              SemanticTableClass = "ui small very compact celled inverted grey scrollable table",
                                                                              TurnLogicalIntoIcon = TRUE) })


                      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      # Object selection behavior
                      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                      # SelectedObjectName <- reactiveVal({"None"})
                      #
                      #
                      #
                      #
                      # ToggleTableRowState <- function(TableID,
                      #                                 RowID,
                      #                                 StepState = "Native")
                      #                   {
                      #                       if (StepState == "Native")
                      #                       {
                      #                           shinyjs::removeCssClass(selector = paste0("#", TableID, " > div"), class = "TableRowNative")
                      #                           shinyjs::addCssClass(selector = paste0("#", StepID, " > div"), class = "TableRowSelected")
                      #
                      #                           # Enable mouse hover behavior
                      #                           shinyjs::onevent("hover",
                      #                                        id = StepID,
                      #                                        expr = { shinyjs::toggleCssClass(selector = paste0("#", StepID, " > div"), class = "StepHover") })
                      #
                      #                           # Enable click event
                      #                           shinyjs::onclick(id = StepID,
                      #                                            expr = { if (StepID == "Step_CheckServerRequirements") { SelectedProcessingStep("CheckServerRequirements") }
                      #                                                     if (StepID == "Step_LoadData") { SelectedProcessingStep("LoadData") }
                      #                                                     if (StepID == "Step_CurateData") { SelectedProcessingStep("CurateData") }
                      #                                                     if (StepID == "Step_AugmentData") { SelectedProcessingStep("AugmentData") } })
                      #                       }
                      #
                      #                       if (StepState == "Selected")
                      #                       {
                      #                           shinyjs::removeCssClass(selector = paste0("#", StepID, " > div"), class = "StepInaccessible")
                      #                           shinyjs::removeCssClass(selector = paste0("#", StepID, " > div"), class = "StepAccessible")
                      #                           shinyjs::addCssClass(selector = paste0("#", StepID, " > div"), class = "StepSelected")
                      #                       }
                      #                   }

                 })
}
