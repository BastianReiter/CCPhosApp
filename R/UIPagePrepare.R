
#' UIPagePrepare
#'
#' @noRd
UIPagePrepare <- function()
{
    div(
        div(class = "ui placeholder segment",

            div(class = "ui two column grid",

                div(class = "column",

                    ModProcessingSteps_UI("Steps")),

                div(class = "column",

                    ModProcessingTerminal_UI("CheckServerRequirements",
                                             ButtonLabel = "Check server requirements"))),

            div(class = "ui vertical divider")),

    div(class = "ui divider"))


}
