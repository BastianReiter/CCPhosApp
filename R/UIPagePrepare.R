
#' UIPagePrepare
#'
#' @noRd
UIPagePrepare <- function()
{

    div(id = "PagePrepare",

        h4(class = "ui dividing header",
           "Data preparation"),

        div(class = "ui accordion",      # Note: For this to work extra JS script is necessary (see MainUIComponent())

            div(class = "active title",
                icon(class = "dropdown icon"),
                "Processing Terminal"),

            div(class = "active content",

                div(class = "ui segment",
                    style = "background: #f9fafb;
                             border-color: rgba(34, 36, 38, 0.15);
                             box-shadow: 0 2px 25px 0 rgba(34, 36, 38, 0.05) inset;
                             height: 30em;",

                    div(style = "display: grid;
                                 height: 100%;
                                 grid-template-columns: 20em auto;
                                 background: none;",

                        div(style = "display: grid;
                                     align-content: center;",

                            uiOutput("Step_Connect"),
                            uiOutput("Step_CheckServerRequirements"),
                            uiOutput("Step_LoadData"),
                            uiOutput("Step_CurateData"),
                            uiOutput("Step_AugmentData")),

                        div(id = "TerminalContainer",
                            style = "height: 100%;
                                     padding: 0 1em 0 2em;",

                            shinyjs::hidden(div(id = "Terminal_CheckServerRequirements",
                                                ModProcessingTerminal_UI("CheckServerRequirements",
                                                                         ButtonLabel = "Check server requirements"))),

                            shinyjs::hidden(div(id = "Terminal_LoadData",
                                                ModProcessingTerminal_UI("LoadData",
                                                                         ButtonLabel = "Load data"))),

                            shinyjs::hidden(div(id = "Terminal_CurateData",
                                                ModProcessingTerminal_UI("CurateData",
                                                                         ButtonLabel = "Start data curation"))),

                            shinyjs::hidden(div(id = "Terminal_AugmentData",
                                                ModProcessingTerminal_UI("AugmentData",
                                                                         ButtonLabel = "Start data augmentation")))))))),


        #-----------------------------------------------------------------------
        div(class = "ui divider"),
        #-----------------------------------------------------------------------


        div(class = "ui accordion",      # Note: For this to work extra JS script is necessary (see MainUIComponent())

            div(class = "active title",
                icon(class = "dropdown icon"),
                "Server Monitor"),

            div(class = "active content",

                div( # Child of 'active content' in accordion has to be a container div. Can not be the grid div directly, this leads to loss of grid structure when accordion functionality is performed.
                    div(style = "display: grid;
                                 grid-template-columns: 1fr 1fr;
                                 grid-gap: 1em;
                                 height: 22em;",

                        ModServerOpalMonitor_UI("ServerOpalMonitor"),

                        ModServerWorkspaceMonitor_UI("Prepare-ServerWorkspaceMonitor"))))),


        #-----------------------------------------------------------------------
        div(class = "ui divider"),
        #-----------------------------------------------------------------------


        div(class = "ui accordion",

            div(class = "active title",
                icon(class = "dropdown icon"),
                "Data Transformation Monitor"),

            div(class = "active content",

                div(style = "height: 30em;",

                    ModDataTransformationMonitor_UI("DataTransformationMonitor")))),



        # tabset(tabs = list(list(menu = "Validation Reports", content = uiOutput("TabContentValidationReports"), id = "Tab_ValidationReports"),
        #                    list(menu = "Transformation Monitors", content = uiOutput("TabContentTransformationMonitors"), id = "Tab_TransformationMonitors")),
        #        active = "Tab_TransformationMonitors")



    )
}
