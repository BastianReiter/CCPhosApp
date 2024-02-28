
#' MainUIComponent
#'
#' Main UI component of CCPhosApp
#'
#' @noRd
#' @author Bastian Reiter
MainUIComponent <- function()
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{

shiny.semantic::semanticPage(

    # Initiate dependencies for use of waiter package
    waiter::use_waiter(),

    # Application title
    titlePanel("CCPhos App"),


    sidebar_layout(

        #--- SIDEBAR -----------------------------------------------------------
        sidebar_panel(

            div(class = "ui fluid vertical menu",

                a(class = "item",
                  icon("wrench"),
                  "START",
                  href = route_link("/")),

                a(class = "item",
                  icon("wrench"),
                  "PREPARE",
                  href = route_link("prepare")),

                a(class = "item",
                   icon("wrench"),
                   "EXPLORE",
                   href = route_link("explore")),

                a(class = "item",
                   icon("wrench"),
                   "ANALYZE",
                   href = route_link("analyze")),

                a(class = "item",
                   icon("wrench"),
                   "EXPORT",
                   href = route_link("export"))
                )

        ),

        #--- MAIN PANEL --------------------------------------------------------
        main_panel(

            # Use shiny.router functionality to enable multi-page UI structure defined in UIPage() functions
            shiny.router::router_ui(route("/", UIPageStart()),
                                    route("prepare", UIPagePrepare()),
                                    route("explore", UIPageExplore()),
                                    route("analyze", UIPageAnalyze()),
                                    route("export", UIPageExport()))





            # textOutput(outputId = "return_Run_ds.CurateData"),
            #
            # selectInput(inputId = "SiteName",
            #             label = "Select Site",
            #             choices = names(CurationReport)),
            #
            # selectInput(inputId = "MonitorTableName",
            #             label = "Select Table",
            #             choices = names(CurationReport[[1]])))

            # gt_output(outputId = "TestTable")
            # tableOutput(outputId = "TestTable")
            # )
        )
    )
)

}
