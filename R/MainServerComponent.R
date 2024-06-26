
#' MainServerComponent
#'
#' Main server component of CCPhosApp
#'
#' @return Returns the main server function for the Shiny app
#'
#' @noRd
#' @author Bastian Reiter
MainServerComponent <- function(CCPSiteSpecifications,
                                CCPTestData)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{

# Main server function
function(input, output, session)
{
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# General settings
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Initiate router to enable multi-page appearance
shiny.router::router_server()

# Hide waiter loading screen after initial app load has finished
waiter::waiter_hide()

# Initialize global objects
session$userData$CCPConnections <- reactiveVal(NULL)
session$userData$CCPSiteSpecifications <- reactiveVal(NULL)
session$userData$ServerOpalInfo <- reactiveVal(NULL)
session$userData$ServerWorkspaceInfo <- reactiveVal(NULL)

session$userData$CurationReports <- reactiveVal(NULL)

session$userData$CCPTestData <- NULL


# --- Call module: Initialize ---
# Assigns content to session$userData objects at app start
ModInitialize(id = "Initialize",
              CCPSiteSpecifications,
              CCPTestData)


# Initialize menu behavior
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SelectedMainMenuItem <- reactiveVal("Start")

shinyjs::onclick(id = "MenuItem_Start", expr = SelectedMainMenuItem("Start"))
shinyjs::onclick(id = "MenuItem_Prepare", expr = SelectedMainMenuItem("Prepare"))
shinyjs::onclick(id = "MenuItem_Explore", expr = SelectedMainMenuItem("Explore"))
shinyjs::onclick(id = "MenuItem_Analyze", expr = SelectedMainMenuItem("Analyze"))
shinyjs::onclick(id = "MenuItem_Export", expr = SelectedMainMenuItem("Export"))


# Observers: Main menu item selected
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# - Change main menu item appearance when selected

observe({ shinyjs::toggleCssClass(class = "active",
                                  id = "MenuItem_Start",
                                  condition = (SelectedMainMenuItem() == "Start")) })

observe({ shinyjs::toggleCssClass(class = "active",
                                  id = "MenuItem_Prepare",
                                  condition = (SelectedMainMenuItem() == "Prepare")) })

observe({ shinyjs::toggleCssClass(class = "active",
                                  id = "MenuItem_Explore",
                                  condition = (SelectedMainMenuItem() == "Explore")) })

observe({ shinyjs::toggleCssClass(class = "active",
                                  id = "MenuItem_Analyze",
                                  condition = (SelectedMainMenuItem() == "Analzye")) })

observe({ shinyjs::toggleCssClass(class = "active",
                                  id = "MenuItem_Export",
                                  condition = (SelectedMainMenuItem() == "Export")) })




# --- Call module: Connection Status ---
ModConnectionStatus_Server(id = "ConnectionStatus")


output$ProjectNameOutput <- renderUI({ "" })
                                        # h3(style = "color: white;",
                                        #   paste0("Project: ", session$userData$ProjectName())) })

# For testing purposes: Arbitrary text monitor element
output$TestMonitor <- renderText({ #session$userData$CCPSiteSpecifications()[1,1]
                                    ""
                                 })



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
StatusDataCurated <- ModProcessingTerminal_Server(id = "CurateData")
StatusDataAugmented <- ModProcessingTerminal_Server(id = "AugmentData")

SelectedProcessingStep <- reactiveVal("None")

observe({ if (is.list(session$userData$CCPConnections())) { StatusConnected(TRUE) }
          else { StatusConnected(FALSE) } })


# --- Call module: Server Opal Monitor ---
ModServerOpalMonitor_Server("ServerOpalMonitor")

# --- Call module: Server Workspace Monitor ---
ModServerWorkspaceMonitor_Server("Prepare-ServerWorkspaceMonitor")

# --- Call module: Data Transformation Monitor ---
ModDataTransformationMonitor_Server("DataTransformationMonitor")



MakeStep <- function(IconClass = "",
                     HeaderText = "",
                     DescriptionText = "")
{
    div(class = "ui segment StepInaccessible",
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
    # Disable mouse hover behavior
    shinyjs::removeEvent(event = "hover",
                         id = StepID)

    # Disable click event
    shinyjs::removeEvent(event = "click",
                         id = StepID)


    # shinyjs::onevent("hover",
    #                  id = StepID,
    #                  expr = { shinyjs::toggleCssClass(selector = paste0("#", StepID, " > div"), class = "StepHover") })
    #
    # shinyjs::onclick(id = StepID,
    #                  expr = { if (StepID == "Step_CheckServerRequirements") { SelectedProcessingStep("CheckServerRequirements") }
    #                           if (StepID == "Step_LoadData") { SelectedProcessingStep("LoadData") }
    #                           if (StepID == "Step_CurateData") { SelectedProcessingStep("CurateData") }
    #                           if (StepID == "Step_AugmentData") { SelectedProcessingStep("AugmentData") } })
}





ToggleStepState <- function(StepID,
                            StepState = "Inaccessible")
{
    if (StepState == "Inaccessible")
    {
        shinyjs::addCssClass(selector = paste0("#", StepID, " > div"), class = "StepInaccessible")
        shinyjs::removeCssClass(selector = paste0("#", StepID, " > div"), class = "StepAccessible")
        shinyjs::removeCssClass(selector = paste0("#", StepID, " > div"), class = "StepSelected")
        shinyjs::removeCssClass(selector = paste0("#", StepID, " > div"), class = "StepCompleted")

        # Disable mouse hover behavior
        shinyjs::removeEvent(event = "hover",
                             id = StepID)

        # Disable click event
        shinyjs::removeEvent(event = "click",
                             id = StepID)
    }

    if (StepState == "Accessible")
    {
        shinyjs::removeCssClass(selector = paste0("#", StepID, " > div"), class = "StepInaccessible")
        shinyjs::addCssClass(selector = paste0("#", StepID, " > div"), class = "StepAccessible")

        # Enable mouse hover behavior
        shinyjs::onevent("hover",
                     id = StepID,
                     expr = { shinyjs::toggleCssClass(selector = paste0("#", StepID, " > div"), class = "StepHover") })

        # Enable click event
        shinyjs::onclick(id = StepID,
                         expr = { if (StepID == "Step_CheckServerRequirements") { SelectedProcessingStep("CheckServerRequirements") }
                                  if (StepID == "Step_LoadData") { SelectedProcessingStep("LoadData") }
                                  if (StepID == "Step_CurateData") { SelectedProcessingStep("CurateData") }
                                  if (StepID == "Step_AugmentData") { SelectedProcessingStep("AugmentData") } })
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
                               IconClass = "door open")
          ToggleStepState(StepID = "Step_CheckServerRequirements",
                          StepState = "Accessible") }) %>% bindEvent(StatusConnected())


observe({ ToggleStepCompletion(StepID = "Step_CheckServerRequirements",
                               StepCompleted = StatusServerRequirementsChecked(),
                               IconClass = "glasses")
          ToggleStepState(StepID = "Step_LoadData",
                          StepState = "Accessible") }) %>% bindEvent(StatusServerRequirementsChecked())


observe({ ToggleStepCompletion(StepID = "Step_LoadData",
                               StepCompleted = StatusDataLoaded(),
                               IconClass = "database")
          ToggleStepState(StepID = "Step_CurateData",
                          StepState = "Accessible") }) %>% bindEvent(StatusDataLoaded())


observe({ ToggleStepCompletion(StepID = "Step_CurateData",
                               StepCompleted = StatusDataCurated(),
                               IconClass = "wrench")
          ToggleStepState(StepID = "Step_AugmentData",
                          StepState = "Accessible") }) %>% bindEvent(StatusDataCurated())


observe({ ToggleStepCompletion(StepID = "Step_AugmentData",
                               StepCompleted = StatusDataAugmented(),
                               IconClass = "magic") }) %>% bindEvent(StatusDataAugmented())



InitiateStepJS(StepID = "Step_Connect")
InitiateStepJS(StepID = "Step_CheckServerRequirements")
InitiateStepJS(StepID = "Step_LoadData")
InitiateStepJS(StepID = "Step_CurateData")
InitiateStepJS(StepID = "Step_AugmentData")



#output$TabContentValidationReports <- renderUI({ "Test A" })
#output$TabContentTransformationMonitors <- renderUI({ "Test B" })



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Page 'Explore'
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# --- Call module: Server Workspace Monitor ---
Selection <- ModServerWorkspaceMonitor_Server("Explore-ServerWorkspaceMonitor")
SelectedObject <- Selection$Object
SelectedElement <- Selection$Element

# --- Call module: Univariate Exploration ---
ModUnivariateExploration_Server("UnivariateExploration",
                                Selection)




# onStart = function() {
#   cat("Doing application setup\n")
#
#   onStop(function() {
#     cat("Doing application cleanup\n")
#       if(session$userData$CCPConnections != "None") {DSI::datashield.logout(session$userData$CCPConnections) }
#   })
# }

}
}

