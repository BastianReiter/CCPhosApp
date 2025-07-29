

# --- MODULE: ADSTableMonitor ---

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @noRd
ModADSTableMonitor_UI <- function(id)
{
    ns <- NS(id)

    div(id = ns("ADSTableMonitorContainer"),
        style = "",

        div(style = "display: grid;
                     grid-template-columns: 1fr 3fr 1fr;",

            div(),

            div(class = "ui segment",
                style = "margin: 2em;",

                div(class = "ui top attached label",
                    "ADS Table Details"),

                uiOutput(outputId = ns("TableDetails"))),

            div()))
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module server component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param input
#' @param output
#' @param session
#' @noRd
ModADSTableMonitor_Server <- function(id)
{
    require(dplyr)
    require(purrr)
    require(stringr)

    moduleServer(id,
                 function(input, output, session)
                 {
                      ns <- session$ns

                      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                      # Render reactive output: Table details
                      #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                      # Dynamically create empty UI elements to be filled further down
                      output$TableDetails <- renderUI({   req(session$userData$ADSTableCheck())

                                                          TableOutputList <- list()

                                                          TableNames <- names(session$userData$ADSTableCheck()$FeatureExistence)

                                                          # Using for-loop instead of purrr-functionality because there is no map-function that can access both names and index of list items
                                                          for (i in 1:length(TableNames))
                                                          {
                                                              TableOutput <- div(style = "margin-top: 1em;",
                                                                                 div(class = "ui small grey ribbon label",
                                                                                     TableNames[i]),
                                                                                 div(style = "width: 1000px; overflow: auto;",
                                                                                     uiOutput(outputId = ns(paste0("TableDetails_", i)))))

                                                              TableOutputList <- list(TableOutputList,
                                                                                      TableOutput)
                                                          }

                                                          # Convert into tagList for html output
                                                          do.call(tagList, TableOutputList)
                                                      })


                      HTMLTableList_TableDetails <- reactive({  req(session$userData$ADSTableCheck())

                                                                # Process data from 'ADSTableCheck' to get a list of data.frames (one per ADS table) that contain table details info
                                                                TableList <- session$userData$ADSTableCheck()[c("TableRowCounts",
                                                                                                                "FeatureExistence",
                                                                                                                "FeatureTypes",
                                                                                                                "NonMissingValueRates")] %>%
                                                                                list_transpose() %>%
                                                                                map(\(TableData) CreateTableMonitor(TableData))      # Call custom function 'CreateTableMonitor()'

                                                                # Turn prepared data.frames into HTML table code
                                                                HTMLTables <- TableList %>%
                                                                                  map(function(TableData)
                                                                                      {
                                                                                          DataFrameToHtmlTable(DataFrame = TableData$TableDetails,
                                                                                                               ColContentHorizontalAlign = "center",
                                                                                                               ColumnLabels = c(SiteName = "Site"),
                                                                                                               HeaderColspans = TableData$HeaderColspans,
                                                                                                               SemanticTableCSSClass = "ui small compact inverted scrollable structured table",
                                                                                                               TurnLogicalsIntoIcons = TRUE,
                                                                                                               TurnNAsIntoBlanks = TRUE)
                                                                                      })
                                                              })


                      output[["TableDetails_1"]] <- renderUI({ req(HTMLTableList_TableDetails); HTMLTableList_TableDetails()[[1]] })
                      output[["TableDetails_2"]] <- renderUI({ req(HTMLTableList_TableDetails); HTMLTableList_TableDetails()[[2]] })
                      output[["TableDetails_3"]] <- renderUI({ req(HTMLTableList_TableDetails); HTMLTableList_TableDetails()[[3]] })
                      output[["TableDetails_4"]] <- renderUI({ req(HTMLTableList_TableDetails); HTMLTableList_TableDetails()[[4]] })
                      output[["TableDetails_5"]] <- renderUI({ req(HTMLTableList_TableDetails); HTMLTableList_TableDetails()[[5]] })

                 })
}

