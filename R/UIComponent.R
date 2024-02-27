
#' UIComponent
#'
#' UI component of CCPhosApp
#'
#' @export
#'
#' @author Bastian Reiter
UIComponent <- function()
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{

require(gt)
require(shiny)
require(shiny.router)
require(shiny.semantic)
require(waiter)


shiny.semantic::semanticPage(

    #useWaiter()

    # Application title
    titlePanel("CCPhos App"),


    sidebar_layout(

        #--- SIDEBAR -----------------------------------------------------------
        sidebar_panel(

            div(class = "ui fluid vertical menu",

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

            # Use shiny.router functionality to enable multi-page UI structure defined in Page() functions
            shiny.router::router_ui(route("/", PageStart()),
                                    route("prepare", PagePrepare()),
                                    route("explore", PageExplore()),
                                    route("analyze", PageAnalyze()),
                                    route("export", PageExport()))





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
