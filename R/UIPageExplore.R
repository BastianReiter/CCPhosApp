
#' UIPageExplore
#'
#' @noRd
UIPageExplore <- function()
{
    div(id = "PageExplore",

        h4(class = "ui dividing header",
           "Data exploration"),


        div(style = "height: 26em;",

            ModServerWorkspaceMonitor_UI("Explore-ServerWorkspaceMonitor")),


        #-----------------------------------------------------------------------
        div(class = "ui divider"),
        #-----------------------------------------------------------------------


        div(style = "height: 60em;",

            ModUnivariateExploration_UI("UnivariateExploration")))
}
