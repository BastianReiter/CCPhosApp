
#' UIPagePrepare
#'
#' @noRd
UIPagePrepare <- function()
{
    div(h4(class = "ui dividing header",
           "Data preparation"),

        div(class = "ui segment",
            style = "background: #f9fafb;
                     border-color: rgba(34, 36, 38, 0.15);
                     box-shadow: 0 2px 25px 0 rgba(34, 36, 38, 0.05) inset;",

            div(class = "ui two column grid",

                div(class = "column",

                    div(class = "ui segments",
                        uiOutput("Step_Connect"),
                        uiOutput("Step_CheckServerRequirements"),
                        uiOutput("Step_LoadData"),
                        uiOutput("Step_CurateData"),
                        uiOutput("Step_AugmentData"))),

                div(class = "column",
                    id = "TerminalContainer",

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
                                                                 ButtonLabel = "Start data augmentation"))))),

            div(class = "ui vertical divider")),

    div(class = "ui divider"))


}
