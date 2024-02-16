
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

require(dsCCPhosClient)
require(gt)
require(shiny)

# Unpack CCPhos data
CurationReport <- CCPhosData


# Call of Shiny server component
function(input, output, session)
{

    Site <- reactive({ input$SiteName })
    MonitorTable <- reactive({ input$MonitorTableName })
    MonitorData <- reactive({ CurationReport[[Site()]][[MonitorTable()]] })

    output$TestTable <- render_gt({ tryCatch(
                                        if (!is.null(MonitorData()))
                                        {
                                            MonitorData() %>%
                                                 gt(groupname_col = "Feature") %>%
                                                 dsCCPhosClient::gtTheme_CCP(TableAlign = "left", ShowNAs = TRUE, TableWidth = "80%") %>%
                                                 tab_style(locations = cells_body(rows = (Value != "NA" & IsValueEligible == TRUE & Final > 0)),
                                                           style = cell_fill(color = "green")) %>%
                                                 tab_style(locations = cells_body(rows = (Value != "NA" & IsValueEligible == TRUE & Final == 0)),
                                                           style = cell_fill(color = "lightgreen")) %>%
                                                 tab_style(locations = cells_body(rows = (Value == "NA" | is.na(Value))),
                                                           style = cell_fill(color = "gray")) %>%
                                                 tab_style(locations = cells_body(columns = c(Value, IsValueEligible, Transformed),
                                                                                  rows = (Value != "NA" & IsValueEligible == FALSE & Transformed > 0 & Final == 0)),
                                                           style = cell_fill(color = "red")) %>%
                                                 tab_style(locations = cells_body(columns = c(Value, IsValueEligible, Raw, Transformed),
                                                                                  rows = (Value != "NA" & IsValueEligible == FALSE & Raw > 0 & Transformed == 0)),
                                                           style = cell_fill(color = "orange"))
                                          },
                                          error = function(error) { print(paste0("The table can not be printed. Error message: ", error)) }) })
}
}
