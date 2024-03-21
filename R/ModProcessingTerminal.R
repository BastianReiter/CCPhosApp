

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

                    # Setting up loading screen with waiter package
                    ns <- session$ns
                    WaiterScreen <- Waiter$new(id = ns("WaiterScreenContainer"),
                                               html = spin_3(),
                                               color = transparent(.5))


                    if (id == "CheckServerRequirements")
                    {
                        observe({ # Set up loading behaviour
                                  shinyjs::disable("ProcessingTrigger")
                                  WaiterScreen$show()
                                  on.exit({ shinyjs::enable("ProcessingTrigger")
                                            WaiterScreen$hide() })

                                  # Trigger function CheckServerRequirements() and assign return to reactive value ReturnMessages
                                  ReturnMessages(dsCCPhosClient::CheckServerRequirements(CCPSiteSpecifications = session$userData$CCPSiteSpecifications(),
                                                                                         DataSources = session$userData$CCPConnections()))

                                  # Trigger function GetServerOpalInfo() and assign return (data.frame) to reactive value ServerOpalInfo in session$userData
                                  session$userData$ServerOpalInfo(dsCCPhosClient::GetServerOpalInfo(CCPSiteSpecifications = session$userData$CCPSiteSpecifications(),
                                                                                                    DataSources = session$userData$CCPConnections()))

                                  # Set reactive value Complete TRUE
                                  Complete(TRUE)

                                  }) %>%
                            bindEvent(input$ProcessingTrigger)
                    }


                    if (id == "LoadData")
                    {
                        observe({ # Set up loading behaviour
                                  shinyjs::disable("ProcessingTrigger")
                                  WaiterScreen$show()
                                  on.exit({ shinyjs::enable("ProcessingTrigger")
                                            WaiterScreen$hide() })

                                  # Trigger function LoadRawDataSet() and assign return to reactive value ReturnMessages
                                  ReturnMessages(dsCCPhosClient::LoadRawDataSet(CCPSiteSpecifications = session$userData$CCPSiteSpecifications(),
                                                                                DataSources = session$userData$CCPConnections()))

                                  # Trigger function GetServerWorkspaceInfo() and assign return (data.frame) to reactive value ServerWorkspaceInfo in session$userData
                                  session$userData$ServerWorkspaceInfo(dsCCPhosClient::GetServerWorkspaceInfo(DataSources = session$userData$CCPConnections()))

                                  # Set reactive value Complete TRUE
                                  Complete(TRUE)

                                  }) %>%
                            bindEvent(input$ProcessingTrigger)
                    }


                    if (id == "CurateData")
                    {
                        observe({ # Set up loading behaviour
                                  shinyjs::disable("ProcessingTrigger")
                                  WaiterScreen$show()
                                  on.exit({ shinyjs::enable("ProcessingTrigger")
                                            WaiterScreen$hide() })

                                  # Trigger functions ds.CurateData() and ds.UnpackCuratedDataSet() and assign returns (concatenated lists) to reactive value ReturnMessages
                                  ReturnMessages(c(dsCCPhosClient::ds.CurateData(RawDataSetName = "RawDataSet",
                                                                               OutputName = "CurationOutput",
                                                                               DataSources = session$userData$CCPConnections()),

                                                   # Make tables from Curated Data Set directly addressable by unpacking them into R server session
                                                   dsCCPhosClient::ds.UnpackCuratedDataSet(CuratedDataSetName = "CuratedDataSet",
                                                                                           DataSources = session$userData$CCPConnections())))

                                  # Trigger function ds.GetCurationReport() and assign return to reactive value CurationReports in session$userData
                                  session$userData$CurationReports(dsCCPhosClient::ds.GetCurationReport(DataSources = session$userData$CCPConnections()))

                                  # Trigger function GetServerWorkspaceInfo() and assign return to reactive value ServerWorkspaceInfo in session$userData
                                  session$userData$ServerWorkspaceInfo(dsCCPhosClient::GetServerWorkspaceInfo(DataSources = session$userData$CCPConnections()))

                                  # Set reactive value Complete TRUE
                                  Complete(TRUE)

                                  }) %>%
                            bindEvent(input$ProcessingTrigger)
                    }


                    if (id == "AugmentData")
                    {
                        observe({ # Set up loading behaviour
                                  shinyjs::disable("ProcessingTrigger")
                                  WaiterScreen$show()
                                  on.exit({ shinyjs::enable("ProcessingTrigger")
                                            WaiterScreen$hide() })

                                  # Trigger functions ds.AugmentData() and ds.UnpackAugmentedDataSet() and assign returns (concatenated lists) to reactive value ReturnMessages
                                  ReturnMessages(c(dsCCPhosClient::ds.AugmentData(CuratedDataSetName = "CuratedDataSet",
                                                                                OutputName = "AugmentationOutput",
                                                                                DataSources = session$userData$CCPConnections()),

                                                   # Make tables from Augmented Data Set directly addressable by unpacking them into R server session
                                                   dsCCPhosClient::ds.UnpackAugmentedDataSet(AugmentedDataSetName = "AugmentedDataSet",
                                                                                             DataSources = session$userData$CCPConnections())))

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


