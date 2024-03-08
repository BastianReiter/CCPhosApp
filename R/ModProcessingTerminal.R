

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

        ModMessageMonitor_UI(ns("Monitor")))
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
                    w <- waiter::Waiter$new(id = "ProcessingMonitor")


                    if (id == "CheckServerRequirements")
                    {
                        FunctionReturn <- reactiveVal(NULL)
                        Complete <- reactiveVal(FALSE)

                        observe({ FunctionReturn(dsCCPhosClient::CheckServerRequirements(DataSources = session$userData$CCPConnections()))
                                  Complete(TRUE) }) %>%
                            bindEvent(input$ProcessingTrigger)

                        ModMessageMonitor_Server("Monitor",
                                                 MessagesList = FunctionReturn)

                        observe({ shinyjs::showElement(id = "Monitor", anim = TRUE, animType = "fade") }) %>%
                            bindEvent(FunctionReturn())

                        return(Complete)
                    }


                    if (id == "LoadData")
                    {
                        FunctionReturn <- reactiveVal(NULL)
                        Complete <- reactiveVal(FALSE)

                        observe({ FunctionReturn(dsCCPhosClient::LoadRawDataSet(DataSources = session$userData$CCPConnections(),
                                                                                ProjectName = session$userData$ProjectName()))

                                  session$userData$ServerWorkspaceInfo(dsCCPhosClient::GetServerWorkspaceInfo(DataSources = session$userData$CCPConnections()))

                                  Complete(TRUE) }) %>%
                            bindEvent(input$ProcessingTrigger)

                        ModMessageMonitor_Server("Monitor",
                                                 MessagesList = FunctionReturn)

                        return(Complete)
                    }

                 })
}


