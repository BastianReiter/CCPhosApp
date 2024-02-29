
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

    # Add custom CSS (this file is compiled via SASS at development stage)
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "styles/CCPhosStyle.min.css")),

    # Title shown in browser
    title = "CCPhos App",

    # Initiate use of shinyjs functionality
    shinyjs::useShinyjs(),

    # Initiate use of waiter package functionality
    waiter::use_waiter(),


    # Main grid hosting all other UI components
    grid(

        id = "MainGrid",

        # Provide grid template (including definition of area names)
        grid_template = shiny.semantic::grid_template(

                              # --- Main grid layout for desktop devices ---
                              default = list(areas = rbind(c("header", "header", "header"),
                                                           c("leftside", "main", "rightside")),

                                             rows_height = c("100px", "auto"),

                                             cols_width = c("1fr", "4fr", "1fr")),

                              # --- Main grid layout for mobile devices ---
                              mobile = list(areas = rbind(c("header", "header", "header"),
                                                          c("leftside", "main", "rightside")),

                                            rows_height = c("70px", "auto"),

                                            cols_width = c("1fr", "4fr", "1fr"))),

        #container_style = "",

        area_styles = list(header = paste0("background: ", dsCCPhosClient::CCPhosColors$Primary, ";",
                                           "color: white;")),



        #--- HEADER ------------------------------------------------------------
        header = div(h1("CCPhos App"),
                     ModConnectionStatus_UI("ConnectionStatus")),


        #--- LEFT SIDE COLUMN --------------------------------------------------
        leftside = div(

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
                   href = route_link("export"))),

                textOutput(outputId = "TestMonitor")
            ),


        #--- MAIN PANEL --------------------------------------------------------
        main = div(

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
        ),


        #--- RIGHT SIDE COLUMN -------------------------------------------------
        rightside = div()
    )
)

}
