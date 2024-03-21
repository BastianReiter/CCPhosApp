
#' UIPageExplore
#'
#' @noRd
UIPageExplore <- function()
{
    div(id = "PageExplore",

        h4(class = "ui dividing header",
           "Data exploration"),


        ModServerWorkspaceMonitor_UI("Explore-ServerWorkspaceMonitor"),


        #-----------------------------------------------------------------------
        div(class = "ui divider"),
        #-----------------------------------------------------------------------


        ModUnivariateExploration_UI("UnivariateExploration"))
}
