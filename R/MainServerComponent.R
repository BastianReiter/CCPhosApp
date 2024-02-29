
#' MainServerComponent
#'
#' Main server component of CCPhosApp
#'
#' @return Returns the main server function for the Shiny app
#'
#' @noRd
#' @author Bastian Reiter
MainServerComponent <- function(CCPCredentials,
                                CCPTestData)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{

# require(dsCCPhosClient)
# require(gt)
# require(shiny)
# require(shiny.router)
# require(waiter)


# Main server function
function(input, output, session)
{

    # Initiate router to enable multi-page appearance
    shiny.router::router_server()

    # Initialize global objects
    session$userData$CCPConnections <- reactiveVal(NULL)
    session$userData$CCPCredentials <- reactiveVal(NULL)
    session$userData$CCPTestData <- NULL

    # Call module that optionally assigns content to session$userData objects at app start
    ModInitialize(id = "Initialize",
                  CCPCredentials,
                  CCPTestData)


    # --- Call module: Connection Status ---
    ModConnectionStatus_Server(id = "ConnectionStatus")


    # --- Call module: Login ---
    ModLogin_Server(id = "Login")


    ModProcessingTerminal_Server(id = "CheckServerRequirements")


    output$TestMonitor <- renderText({typeof(session$userData$CCPConnections())})



    # onStart = function() {
    #   cat("Doing application setup\n")
    #
    #   onStop(function() {
    #     cat("Doing application cleanup\n")
    #       if(session$userData$CCPConnections != "None") {DSI::datashield.logout(session$userData$CCPConnections) }
    #   })
    # }






    # Run_ds.CurateData <- function(CCPConnections.. = CCPConnections.)
    # {
    #     dsCCPhosClient::ds.CurateData(RawDataSetName = "RawDataSet",
    #                                   OutputName = "CurationOutput",
    #                                   DataSources = CCPConnections..)
    # }
    #
    # observeEvent(eventExpr = input$btn_Run_ds.CurateData,
    #              handlerExpr = {
    #                               Return <- Run_ds.CurateData()
    #                               output$return_Run_ds.CurateData <- renderText({ paste0(Return, collapse = " ")})
    #                            })
    #
    #
    #
    # Site <- reactive({ input$SiteName })
    # MonitorTable <- reactive({ input$MonitorTableName })
    # MonitorData <- reactive({ CurationReport[[Site()]][[MonitorTable()]] })
    #
    # output$TestTable <- render_gt({ tryCatch(
    #                                     if (!is.null(MonitorData()))
    #                                     {
    #                                         MonitorData() %>%
    #                                              gt(groupname_col = "Feature") %>%
    #                                              dsCCPhosClient::gtTheme_CCP(TableAlign = "left", ShowNAs = TRUE, TableWidth = "80%") %>%
    #                                              tab_style(locations = cells_body(rows = (Value != "NA" & IsValueEligible == TRUE & Final > 0)),
    #                                                        style = cell_fill(color = "green")) %>%
    #                                              tab_style(locations = cells_body(rows = (Value != "NA" & IsValueEligible == TRUE & Final == 0)),
    #                                                        style = cell_fill(color = "lightgreen")) %>%
    #                                              tab_style(locations = cells_body(rows = (Value == "NA" | is.na(Value))),
    #                                                        style = cell_fill(color = "gray")) %>%
    #                                              tab_style(locations = cells_body(columns = c(Value, IsValueEligible, Transformed),
    #                                                                               rows = (Value != "NA" & IsValueEligible == FALSE & Transformed > 0 & Final == 0)),
    #                                                        style = cell_fill(color = "red")) %>%
    #                                              tab_style(locations = cells_body(columns = c(Value, IsValueEligible, Raw, Transformed),
    #                                                                               rows = (Value != "NA" & IsValueEligible == FALSE & Raw > 0 & Transformed == 0)),
    #                                                        style = cell_fill(color = "orange"))
    #                                       },
    #                                       error = function(error) { print(paste0("The table can not be printed. Error message: ", error)) }) })
}
}

