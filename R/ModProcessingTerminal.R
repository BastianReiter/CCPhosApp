

# --- MODULE: Processing Terminal ---

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param ButtonLabel
#' @noRd
ModProcessingTerminal_UI <- function(id,
                                     ButtonLabel)
{
    ns <- NS(id)

    div(style = "display: grid;
                 height: 100%;
                 grid-template-rows: 4em 22.8em;",

        div(style = "padding: 10px;
                     text-align: center;",

            action_button(ns("ProcessingTrigger"),
                          class = "ui blue button",
                          style = "box-shadow: 0 0 10px 10px white;",
                          label = ButtonLabel)),

            div(style = "position: relative;",

                div(id = ns("WaiterScreenContainer"),
                    style = "position: absolute;
                             height: 100%;
                             width: 100%;
                             top: 0.5em;
                             left: 0;"),

                ModMessageMonitor_UI(ns("Monitor"))))
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module server component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param input
#' @param output
#' @param session
#' @noRd
ModProcessingTerminal_Server <- function(id)
{

    moduleServer(id,
                 function(input, output, session)
                 {
                    ReturnMessages <- reactiveVal(NULL)
                    Complete <- reactiveVal(FALSE)

                    ModMessageMonitor_Server("Monitor",
                                             MessagesList = ReturnMessages)

                    observe({ shinyjs::showElement(id = "Monitor", anim = TRUE, animType = "fade") }) %>%
                        bindEvent(ReturnMessages())

                    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                    # Setting up loading behavior with waiter package functionality
                    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                    ns <- session$ns
                    WaiterScreen <- CreateWaiterScreen(ID = ns("WaiterScreenContainer"))

                    LoadingOn <- function()
                    {
                        shinyjs::disable("ProcessingTrigger")
                        WaiterScreen$show()
                    }

                    LoadingOff <- function()
                    {
                        shinyjs::enable("ProcessingTrigger")
                        WaiterScreen$hide()
                    }


                    if (id == "CheckServerRequirements")
                    {
                        observe({ # Assign loading behavior
                                  LoadingOn()
                                  on.exit(LoadingOff())

                                  # Trigger function CheckServerRequirements() and save returned list
                                  ServerCheck <- dsCCPhosClient::CheckServerRequirements(CCPSiteSpecifications = session$userData$CCPSiteSpecifications(),
                                                                                         DataSources = session$userData$CCPConnections())

                                  # Assign 'Messages' to reactive value ReturnMessages
                                  ReturnMessages(ServerCheck$Messages)

                                  # Update 'Checkpoints' data frame ...
                                  Checkpoints <- session$userData$Checkpoints() %>%
                                                      left_join(select(ServerCheck$PackageAvailability, c(SiteName, CheckPackageAvailability)), by = join_by(SiteName)) %>%
                                                      left_join(ServerCheck$VersionOfdsCCPhos, by = join_by(SiteName)) %>%
                                                      left_join(select(ServerCheck$FunctionAvailability, c(SiteName, CheckFunctionAvailability)), by = join_by(SiteName)) %>%
                                                      left_join(select(ServerCheck$OpalTableAvailability, c(SiteName, CheckOpalTableAvailability)), by = join_by(SiteName))

                                  # ... and reassign it to session$userData object
                                  session$userData$Checkpoints(Checkpoints)

                                  # Trigger function GetServerOpalInfo() and assign return (data.frame) to reactive value ServerOpalInfo in session$userData
                                  session$userData$ServerOpalInfo(ServerCheck$OpalTableAvailability)

                                  # Set reactive value 'Complete' TRUE
                                  Complete(TRUE)

                                  }) %>%
                            bindEvent(input$ProcessingTrigger)
                    }


                    if (id == "LoadData")
                    {
                        observe({ # Assign loading behavior
                                  LoadingOn()
                                  on.exit(LoadingOff())

                                  # Trigger function LoadRawDataSet() and assign return to reactive value ReturnMessages
                                  ReturnMessages(dsCCPhosClient::LoadRawDataSet(CCPSiteSpecifications = session$userData$CCPSiteSpecifications(),
                                                                                DataSources = session$userData$CCPConnections()))

                                  # Trigger function ds.CheckRDSTables() and save returned list
                                  RDSTableCheck <- dsCCPhosClient::ds.CheckRDSTables(DataSources = session$userData$CCPConnections())

                                  # Assign to session$userData object
                                  session$userData$RDSTableCheck(RDSTableCheck)

                                  # Update 'Checkpoints' data frame ...
                                  Checkpoints <- session$userData$Checkpoints() %>%
                                                      left_join(select(RDSTableCheck$TableStatus, c(SiteName, CheckRDSTables)), by = join_by(SiteName))

                                  # # ... and reassign it to session$userData object
                                  session$userData$Checkpoints(Checkpoints)

                                  # Trigger function GetServerWorkspaceInfo() and assign return (data.frame) to reactive value ServerWorkspaceInfo in session$userData
                                  session$userData$ServerWorkspaceInfo(dsCCPhosClient::GetServerWorkspaceInfo(DataSources = session$userData$CCPConnections()))

                                  # Set reactive value Complete TRUE
                                  Complete(TRUE)

                                  }) %>%
                            bindEvent(input$ProcessingTrigger)
                    }


                    if (id == "CurateData")
                    {
                        observe({ # Assign loading behavior
                                  LoadingOn()
                                  on.exit(LoadingOff())

                                  # Trigger function ds.CurateData() and save return
                                  Curation <- dsCCPhosClient::ds.CurateData(RawDataSetName = "RawDataSet",
                                                                            OutputName = "CurationOutput",
                                                                            DataSources = session$userData$CCPConnections())

                                  # Assign returned messages (concatenated lists) to reactive value ReturnMessages
                                  ReturnMessages(Curation$Messages)

                                  # Update 'Checkpoints' data frame ...
                                  Checkpoints <- session$userData$Checkpoints() %>%
                                                      left_join(Curation$CurationCompletionCheck, by = join_by(SiteName))

                                  # # ... and reassign it to session$userData object
                                  session$userData$Checkpoints(Checkpoints)

                                  # Make tables from Curated Data Set directly addressable by unpacking them into R server session
                                  dsCCPhosClient::ds.UnpackCuratedDataSet(CuratedDataSetName = "CuratedDataSet",
                                                                          DataSources = session$userData$CCPConnections())

                                  # Trigger function GetServerWorkspaceInfo() and assign return to reactive value ServerWorkspaceInfo in session$userData
                                  session$userData$ServerWorkspaceInfo(dsCCPhosClient::GetServerWorkspaceInfo(DataSources = session$userData$CCPConnections()))

                                  # Trigger function ds.GetCurationReport() and assign return to reactive value 'CurationReport' in session$userData
                                  session$userData$CurationReport(dsCCPhosClient::ds.GetCurationReport(DataSources = session$userData$CCPConnections()))

                                  # Set reactive value Complete TRUE
                                  Complete(TRUE)

                                  }) %>%
                            bindEvent(input$ProcessingTrigger)
                    }


                    if (id == "AugmentData")
                    {
                        observe({ # Assign loading behavior
                                  LoadingOn()
                                  on.exit(LoadingOff())

                                  # Trigger function ds.AugmentData() and save return
                                  Augmentation <- dsCCPhosClient::ds.AugmentData(CuratedDataSetName = "CuratedDataSet",
                                                                                 OutputName = "AugmentationOutput",
                                                                                 DataSources = session$userData$CCPConnections())

                                  # Assign returned messages (concatenated lists) to reactive value ReturnMessages
                                  ReturnMessages(Augmentation$Messages)

                                  # Update 'Checkpoints' data frame ...
                                  Checkpoints <- session$userData$Checkpoints() %>%
                                                      left_join(Augmentation$AugmentationCompletionCheck, by = join_by(SiteName))

                                  # # ... and reassign it to session$userData object
                                  session$userData$Checkpoints(Checkpoints)

                                  # Make tables from Augmented Data Set directly addressable by unpacking them into R server session
                                  dsCCPhosClient::ds.UnpackAugmentedDataSet(AugmentedDataSetName = "AugmentedDataSet",
                                                                            DataSources = session$userData$CCPConnections())

                                  # Trigger function GetServerWorkspaceInfo() and assign return to reactive value ServerWorkspaceInfo in session$userData
                                  session$userData$ServerWorkspaceInfo(dsCCPhosClient::GetServerWorkspaceInfo(DataSources = session$userData$CCPConnections()))

                                  # Set reactive value Complete TRUE
                                  Complete(TRUE)

                                  }) %>%
                            bindEvent(input$ProcessingTrigger)
                    }

                    return(Complete)

                 })
}


