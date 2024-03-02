
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

    # Custom body CSS
    style = "margin: 0;
             background: rgb(255,255,255);
             background: linear-gradient(180deg, rgba(237,237,237,1) 20%, rgba(255,255,255,0) 50%, rgba(237,237,237,1) 80%);
             font-size: 100%;",

    # Add custom CSS file (this file is compiled via SASS at development stage)
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "styles/CCPhosStyle.min.css")),

    # Title shown in browser
    title = "CCPhos App",

    # Initiate use of shinyjs functionality
    shinyjs::useShinyjs(),

    # Initiate use of waiter package functionality
    waiter::use_waiter(),


    # Main grid hosting all other UI components
    grid(id = "MainGrid",

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

        #container_style = "gap: 20px;",      # Gap between grid areas

        area_styles = list(header = "padding: 10px;
                                     background: rgb(5,73,150);
                                     background: linear-gradient(90deg, rgba(5,73,150,1) 8%, rgba(255,255,255,0) 100%);
                                     color: #595959;",

                           leftside = "padding: 10px;",
                           main = "padding: 10px;",
                           rightside = "padding: 10px;"),



        #--- HEADER ------------------------------------------------------------
        header = split_layout(style = "display: flex;      /* Set up flexbox to use 'justify-conten: space-between' to enable free space between columns without specifying column width */
                                       justify-content: space-between;
                                       align-items: center;",

                              h1("CCPhosApp"),

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
        main = segment(

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
