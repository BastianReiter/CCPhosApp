
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
require(shiny)

# Unpack CCPhos data
CurationReport <- CCPhosData

fluidPage(

    # Application title
    titlePanel("CCPhos Curation Monitor"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "SiteName",
                        label = "Select Site",
                        choices = names(CurationReport)),
            selectInput(inputId = "TableName",
                        label = "Select Table",
                        choices = list("Monitor_Diagnosis",
                                       "Monitor_Staging",
                                       "Monitor_SystemicTherapy"))
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tableOutput(outputId = "TestTable"),
            textOutput(outputId = "TestText")
        )
    )
)

}
