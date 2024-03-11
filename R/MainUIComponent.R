
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

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # MAIN GRID
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # Set margin 0 (default is 10 px)
    margin = "0",

    # Add custom CSS file
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "www/CCPhosStyle.css")),

    # Add extra JS to enable functionality of semantic accordion
    tags$script(language="javascript",
                "$(document).ready(function() { window.onload = function(){ $('.ui.accordion').accordion(); }; });"),

    # Title shown in browser
    title = "CCPhos App",

    # Initiate use of shinyjs functionality
    shinyjs::useShinyjs(),

    # Initiate use of waiter package
    waiter::useWaiter(),
    waiter::waiterShowOnLoad(html = spin_fading_circles()),

    #waiter::autoWaiter(),


    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # MAIN GRID
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    shiny.semantic::grid(id = "MainGrid",

        # Provide grid template (including definition of area names)
        grid_template = shiny.semantic::grid_template(

                              # --- Main grid layout for desktop devices ---
                              default = list(areas = rbind(c("header", "header", "header"),
                                                           c("leftside", "main", "rightside")),

                                             rows_height = c("minmax(100px, 10vh)", "86vh"),

                                             cols_width = c("1fr", "6fr", "1fr")),

                              # --- Main grid layout for mobile devices ---
                              mobile = list(areas = rbind(c("header", "header", "header"),
                                                          c("leftside", "main", "rightside")),

                                            rows_height = c("100px", "auto"),

                                            cols_width = c("1fr", "6fr", "1fr"))),

        #container_style = "height: 100vh",

        area_styles = list(header = "padding: 10px 2em;
                                     background: rgb(5,73,150);
                                     background: linear-gradient(90deg, rgba(5,73,150,1) 8%, rgba(255,255,255,1) 100%);
                                     color: #595959;",

                           leftside = "min-width: 10em;
                                       padding: 10px;",
                           main = "padding: 10px;",
                           rightside = "padding: 10px;"),



        #--- HEADER ------------------------------------------------------------
        header = split_layout(style = "display: flex;      /* Set up flexbox to use 'justify-content: space-between' to enable free space between columns without specifying column width */
                                       justify-content: space-between;
                                       align-items: center;",

                              img(src = "www/Logo_CCPhosApp.png",
                                  alt = "CCPhos App Logo",
                                  height = "80px"),

                              uiOutput(outputId = "ProjectNameOutput"),

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
        main = segment(class = "ui raised scrolling segment",
                       style = "height: 100%;
                                overflow: auto;",



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
