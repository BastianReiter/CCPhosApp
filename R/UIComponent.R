
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

# Unpack CCPhos data
CurationReport <- CCPhosData

fluidPage(

    # Application title
    titlePanel("CCPhos Curation Monitor"),


    sidebarLayout(

        #--- SIDEBAR -----------------------------------------------------------
        sidebarPanel(

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
