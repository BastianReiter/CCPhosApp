
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

                        uiOutput("StepConnect"),

                        uiOutput("StepServerRequirements"),

                        uiOutput("StepLoadData"),

                        uiOutput("StepCurateData"),

                        uiOutput("StepAugmentData"))),


                    # shiny.semantic::steps(id = "ProcessingSteps",
                    #                       class = "vertical",
                    #                       steps_list = list(
                    #
                    #                           single_step(id = "StepConnect",
                    #                                       title = "Connect to CCP",
                    #                                       #description = "Connect to CCP",
                    #                                       icon_class = "door open",
                    #                                       step_class = "step"),
                    #
                    #                           single_step(id = "StepServerRequirements",
                    #                                       title = "Check server requirements",
                    #                                       #description = "Check server requirements",
                    #                                       icon_class = "glasses",
                    #                                       step_class = "disabled step"),
                    #
                    #                           single_step(id = "StepLoadData",
                    #                                       title = "Load data",
                    #                                       description = "From Opal DB into R session",
                    #                                       icon_class = "database",
                    #                                       step_class = "disabled step"),
                    #
                    #                           single_step(id = "StepCurateData",
                    #                                       title = "Data curation",
                    #                                       description = "Transform raw into curated data",
                    #                                       icon_class = "wrench",
                    #                                       step_class = "disabled step"),
                    #
                    #                           single_step(id = "StepAugmentData",
                    #                                       title = "Data augmentation",
                    #                                       description = "Transform into augmented data",
                    #                                       icon_class = "magic",
                    #                                       step_class = "disabled step")))),

                div(class = "column",

                    ModProcessingTerminal_UI("CheckServerRequirements",
                                             ButtonLabel = "Check server requirements"))),

                    # shinyjs::hidden(ModProcessingTerminal_UI("LoadData",
                    #                          ButtonLabel = "Load data")),
                    #
                    # ModProcessingTerminal_UI("CurateData",
                    #                          ButtonLabel = "Start data curation"),
                    #
                    # ModProcessingTerminal_UI("AugmentData",
                    #                          ButtonLabel = "Start data augmentation"))),

            div(class = "ui vertical divider")),

    div(class = "ui divider"))


}
