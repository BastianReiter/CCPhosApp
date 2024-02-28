
#' UIPagePrepare
#'
#' @noRd
UIPagePrepare <- function()
{

    Page <- div(

                titlePanel("CCPhos Prepare Data"),

                grid(grid_template = shiny.semantic::grid_template(

                                          default = list(areas = rbind(c("DivSteps", "DivStepMonitor"),
                                                                       c("Main", "Main")),

                                                         rows_height = c("auto", "auto"),

                                                         cols_width = c("auto", "auto"))),

                     DivSteps = ModProcessingSteps_UI("Steps"),

                     DivStepMonitor = div(ModProcessingTerminal_UI("CheckServerRequirements",
                                                                   ButtonLabel = "Check server requirements")),

                     Main = div()

                ),

                div(class = "ui divider")

            )
}
