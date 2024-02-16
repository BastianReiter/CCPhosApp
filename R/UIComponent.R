
#' UIComponent
#'
#' UI component of CCPhosApp
#'
#' @export
#'
#' @author Bastian Reiter
UIComponent <- function(CCPhosData)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{

require(gt)
require(shiny)
require(waiter)

# Unpack CCPhos data
CurationReport <- CCPhosData

fluidPage(

    #useWaiter()

    # Application title
    titlePanel("CCPhos Curation Monitor"),


    sidebarLayout(

        #--- SIDEBAR -----------------------------------------------------------
        sidebarPanel(

            actionButton(inputId = "btn_Run_ds.CurateData",
                         label = "Curate Data"),

            textOutput(outputId = "return_Run_ds.CurateData"),

            selectInput(inputId = "SiteName",
                        label = "Select Site",
                        choices = names(CurationReport)),

            selectInput(inputId = "MonitorTableName",
                        label = "Select Table",
                        choices = names(CurationReport[[1]]))
        ),

        #--- MAIN PANEL --------------------------------------------------------
        mainPanel(

            gt_output(outputId = "TestTable")
            #tableOutput(outputId = "TestTable")
        )
    )
)

}
