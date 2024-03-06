
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
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# General settings
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Initiate router to enable multi-page appearance
shiny.router::router_server()

# Initialize global objects
session$userData$CCPConnections <- reactiveVal(NULL)
session$userData$CCPCredentials <- reactiveVal(NULL)
session$userData$CCPTestData <- NULL

# --- Call module: Initialize ---
# Assigns content to session$userData objects at app start
ModInitialize(id = "Initialize",
              CCPCredentials,
              CCPTestData)

# --- Call module: Connection Status ---
ModConnectionStatus_Server(id = "ConnectionStatus")


output$TestMonitor <- renderText({ StatusConnected() })


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Page 'Start'
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# --- Call module: Login ---
ModLogin_Server(id = "Login")



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Page 'Prepare'
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# --- Set up processing steps feedback ---

StatusConnected <- reactiveVal(FALSE)
StatusServerRequirementsChecked <- ModProcessingTerminal_Server(id = "CheckServerRequirements")
StatusDataLoaded <- reactiveVal(FALSE)
StatusDataCurated <- reactiveVal(FALSE)
StatusDataAugmented <- reactiveVal(FALSE)


observe({ if (is.list(session$userData$CCPConnections())) { StatusConnected(TRUE) }
          else { StatusConnected(FALSE) } })


ToggleStep <- function(StepID,
                       IconClass)
{
    shinyjs::toggleCssClass(selector = paste0("#", StepID, " > div"), class = "StepActive")

    if (StatusConnected() == TRUE)
    {
        shinyjs::removeCssClass(selector = paste0("#", StepID, " i"), class = IconClass)
        shinyjs::addCssClass(selector = paste0("#", StepID, " i"), class = "green check")
    }
    else
    {
        shinyjs::removeCssClass(selector = paste0("#", StepID, " i"), class = "green check")
        shinyjs::addCssClass(selector = paste0("#", StepID, " i"), class = IconClass)
    }
}



observe({ ToggleStep(StepID = "Step_Connect",
                     IconClass = "door open") }) %>%
    bindEvent(StatusConnected())


InitiateStepJS <- function(StepID)
{
    shinyjs::onevent("hover",
                     id = StepID,
                     expr = shinyjs::toggleCssClass(selector = paste0("#", StepID, " > div"), class = "StepHover"))

    shinyjs::onclick(id = StepID,
                     expr = { shinyjs::hideElement(selector = "#TerminalContainer div")
                              shinyjs::showElement(id = stringr::str_replace(StepID, "Step_", "Terminal_"),
                                                 anim = TRUE,
                                                 animType = "fade") })
}

InitiateStepJS(StepID = "Step_Connect")
InitiateStepJS(StepID = "Step_CheckServerRequirements")
InitiateStepJS(StepID = "Step_LoadData")
InitiateStepJS(StepID = "Step_CurateData")
InitiateStepJS(StepID = "Step_AugmentData")







MakeStep <- function(IconClass = "",
                     HeaderText = "",
                     DescriptionText = "")
{
    div(class = "ui segment StepInactive",
        style = "min-height: 3em;",
        split_layout(style = "background: none;
                              justify-content: start;
                              align-items: center;
                              grid-template-columns: auto auto;",
                     icon(class = paste0("big ", IconClass),
                          style = "margin: 10px;"),
                     div(h4(HeaderText),
                         DescriptionText)))
}





output$Step_Connect <- renderUI({ MakeStep(IconClass = "door open",
                                           HeaderText = "Connect to CCP") })

output$Step_CheckServerRequirements <- renderUI({ MakeStep(IconClass = "glasses",
                                                           HeaderText = "Check server requirements") })

output$Step_LoadData <- renderUI({ MakeStep(IconClass = "database",
                                            HeaderText = "Load raw data",
                                            DescriptionText = "From Opal DB into R session") })

output$Step_CurateData <- renderUI({ MakeStep(IconClass = "wrench",
                                              HeaderText = "Data curation",
                                              DescriptionText = "Transform raw into curated data") })

output$Step_AugmentData <- renderUI({ MakeStep(IconClass = "magic",
                                               HeaderText = "Data augmentation",
                                               DescriptionText = "Transform into augmented data") })














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

