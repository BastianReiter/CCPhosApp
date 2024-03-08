
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
session$userData$ProjectName <- reactiveVal("None")
session$userData$ServerWorkspaceInfo <- reactiveVal(NULL)

session$userData$CCPTestData <- NULL

# --- Call module: Initialize ---
# Assigns content to session$userData objects at app start
ModInitialize(id = "Initialize",
              CCPCredentials,
              CCPTestData)

# --- Call module: Connection Status ---
ModConnectionStatus_Server(id = "ConnectionStatus")


output$ProjectNameOutput <- renderUI({ h3(style = "color: white;",
                                          paste0("Project: ", session$userData$ProjectName())) })


output$TestMonitor <- renderText({ paste0(names(session$userData$ServerWorkspaceInfo())) })


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
StatusDataLoaded <- ModProcessingTerminal_Server(id = "LoadData")
StatusDataCurated <- reactiveVal(FALSE)
StatusDataAugmented <- reactiveVal(FALSE)

SelectedProcessingStep <- reactiveVal("None")


observe({ if (is.list(session$userData$CCPConnections())) { StatusConnected(TRUE) }
          else { StatusConnected(FALSE) } })


ModServerWorkspaceMonitor_Server("ServerWorkspaceMonitor")


MakeStep <- function(IconClass = "",
                     HeaderText = "",
                     DescriptionText = "")
{
    div(class = "ui segment StepInaccessible",
        #style = "min-height: 3em;",
        split_layout(style = "background: none;
                              justify-content: start;
                              align-items: center;
                              grid-template-columns: auto auto;",
                     icon(class = paste0("big ", IconClass),
                          style = "margin: 10px;"),
                     div(h4(HeaderText),
                         DescriptionText)))
}


InitiateStepJS <- function(StepID)
{
    shinyjs::onevent("hover",
                     id = StepID,
                     expr = { shinyjs::toggleCssClass(selector = paste0("#", StepID, " > div"), class = "StepHover") })

    shinyjs::onclick(id = StepID,
                     expr = { if (StepID == "Step_CheckServerRequirements") { SelectedProcessingStep("CheckServerRequirements") }
                              if (StepID == "Step_LoadData") { SelectedProcessingStep("LoadData") }
                              if (StepID == "Step_CurateData") { SelectedProcessingStep("CurateData") }
                              if (StepID == "Step_AugmentData") { SelectedProcessingStep("AugmentData") } })
}



ToggleStepState <- function(StepID,
                            StepState = "Inaccessible",
                            IconClass = "question")
{
    if (StepState == "Inaccessible")
    {
        shinyjs::addCssClass(selector = paste0("#", StepID, " > div"), class = "StepInaccessible")
        shinyjs::removeCssClass(selector = paste0("#", StepID, " > div"), class = "StepAccessible")
        shinyjs::removeCssClass(selector = paste0("#", StepID, " > div"), class = "StepSelected")
        shinyjs::removeCssClass(selector = paste0("#", StepID, " > div"), class = "StepCompleted")
    }

    if (StepState == "Accessible")
    {
        shinyjs::removeCssClass(selector = paste0("#", StepID, " > div"), class = "StepInaccessible")
        shinyjs::addCssClass(selector = paste0("#", StepID, " > div"), class = "StepAccessible")
    }

    if (StepState == "Selected")
    {
        shinyjs::removeCssClass(selector = paste0("#", StepID, " > div"), class = "StepInaccessible")
        shinyjs::removeCssClass(selector = paste0("#", StepID, " > div"), class = "StepAccessible")
        shinyjs::addCssClass(selector = paste0("#", StepID, " > div"), class = "StepSelected")
    }
}



ToggleStepCompletion <- function(StepID,
                                 StepCompleted = FALSE,
                                 IconClass = "question")
{
    if (StepCompleted == TRUE)
    {
        # Add class "StepCompleted" to div
        shinyjs::removeCssClass(selector = paste0("#", StepID, " > div"), class = "StepInaccessible")
        shinyjs::removeCssClass(selector = paste0("#", StepID, " > div"), class = "StepAccessible")
        shinyjs::addCssClass(selector = paste0("#", StepID, " > div"), class = "StepCompleted")
        # Set icon to green check
        shinyjs::removeCssClass(selector = paste0("#", StepID, " i"), class = IconClass)
        shinyjs::addCssClass(selector = paste0("#", StepID, " i"), class = "green check")
    }
    else
    {
        # Remove class "StepCompleted" from div
        shinyjs::removeCssClass(selector = paste0("#", StepID, " > div"), class = "StepCompleted")
        # (Re-)Set icon according to passed IconClass
        shinyjs::addCssClass(selector = paste0("#", StepID, " i"), class = IconClass)
        shinyjs::removeCssClass(selector = paste0("#", StepID, " i"), class = "green check")
    }
}



ToggleTerminal <- function(TerminalID)
{
    shinyjs::hideElement(selector = "#TerminalContainer > div")      # Hide every <div> in TerminalContainer (see UIPagePrepare())
    shinyjs::showElement(id = TerminalID,
                         anim = TRUE,
                         animType = "fade",
                         time = 0.2)
}




InitiateStepJS(StepID = "Step_Connect")
InitiateStepJS(StepID = "Step_CheckServerRequirements")
InitiateStepJS(StepID = "Step_LoadData")
InitiateStepJS(StepID = "Step_CurateData")
InitiateStepJS(StepID = "Step_AugmentData")



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




# Observers: Procession step selected
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# - Change Step appearance when selected

observe({ shinyjs::toggleCssClass(class = "StepSelected",
                                  selector = "#Step_CheckServerRequirements > div",
                                  condition = (SelectedProcessingStep() == "CheckServerRequirements")) })

observe({ shinyjs::toggleCssClass(class = "StepSelected",
                                  selector = "#Step_LoadData > div",
                                  condition = (SelectedProcessingStep() == "LoadData")) })

observe({ shinyjs::toggleCssClass(class = "StepSelected",
                                  selector = "#Step_CurateData > div",
                                  condition = (SelectedProcessingStep() == "CurateData")) })

observe({ shinyjs::toggleCssClass(class = "StepSelected",
                                  selector = "#Step_AugmentData > div",
                                  condition = (SelectedProcessingStep() == "AugmentData")) })


# Toggle visibility of terminals when selection of processing step occurs
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

observe({ if (SelectedProcessingStep() == "CheckServerRequirements") { ToggleTerminal("Terminal_CheckServerRequirements") }
          if (SelectedProcessingStep() == "LoadData") { ToggleTerminal("Terminal_LoadData") }
          if (SelectedProcessingStep() == "CurateData") { ToggleTerminal("Terminal_CurateData") }
          if (SelectedProcessingStep() == "AugmentData") { ToggleTerminal("Terminal_AugmentData") } }) %>% bindEvent(SelectedProcessingStep())



# Observers: Procession step completed
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

observe({ ToggleStepCompletion(StepID = "Step_Connect",
                               StepCompleted = StatusConnected(),
                               IconClass = "door open") }) %>% bindEvent(StatusConnected())

observe({ ToggleStepCompletion(StepID = "Step_CheckServerRequirements",
                               StepCompleted = StatusServerRequirementsChecked(),
                               IconClass = "glasses") }) %>% bindEvent(StatusServerRequirementsChecked())

observe({ ToggleStepCompletion(StepID = "Step_LoadData",
                               StepCompleted = StatusDataLoaded(),
                               IconClass = "database") }) %>% bindEvent(StatusDataLoaded())

observe({ ToggleStepCompletion(StepID = "Step_CurateData",
                               StepCompleted = StatusDataCurated(),
                               IconClass = "wrench") }) %>% bindEvent(StatusDataCurated())

observe({ ToggleStepCompletion(StepID = "Step_AugmentData",
                               StepCompleted = StatusDataAugmented(),
                               IconClass = "magic") }) %>% bindEvent(StatusDataAugmented())












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

