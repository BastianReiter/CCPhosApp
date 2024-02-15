
#' ServerComponent
#'
#' Server component of CCPhosApp
#'
#' @export
#'
#' @author Bastian Reiter
ServerComponent <- function(CCPhosData)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
require(shiny)

# Unpack CCPhos data
CurationReport <- CCPhosData

function(input, output, session)
{
    MonitorTable <- reactive({CurationReport[[input$SiteName]][[input$TableName]]})

    output$TestTable <- renderTable({
                                      MonitorTable()
                                    })
}
}
