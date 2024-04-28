

# --- MODULE: ServerWorkspaceMonitor ---

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param ShowObjectDetailTable
#' @noRd
ModServerWorkspaceMonitor_UI <- function(id,
                                         ShowObjectDetailTable = TRUE)
{
    ns <- NS(id)

    DisplayObjectDetails <- ifelse(ShowObjectDetailTable == TRUE,
                                   "display: block;",
                                   "display: none;")

    div(id = ns("ServerWorkspaceMonitorContainer"),
        class = "ui scrollable segment",
        style = "height: 100%;
                 overflow: auto;
                 margin: 0;",

        div(class = "ui top attached label",
            "Server R Session Workspace"),

        div(style = "display: grid;
                     grid-template-columns: 3fr 1fr;
                     grid-gap: 1em;
                     margin: 0;",

            div(style = "height: 100%;",

                DTOutput(ns("WorkspaceObjects"))),

            div(style = paste(DisplayObjectDetails,
                              "height: 100%;"),

                DTOutput(ns("ObjectDetails")))))

}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module server component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param input
#' @param output
#' @param session
#' @noRd
ModServerWorkspaceMonitor_Server <- function(id)
{
    moduleServer(id,
                 function(input, output, session)
                 {
                      ns <- session$ns

                      output$WorkspaceObjects <- renderDT({ req(session$userData$ServerWorkspaceInfo())

                                                            DataWorkspaceOverview <- session$userData$ServerWorkspaceInfo()$Overview %>%
                                                                                          ConvertLogicalToIcon()

                                                            DT::datatable(data = DataWorkspaceOverview,
                                                                          class = "ui small compact selectable table",
                                                                          editable = FALSE,
                                                                          escape = FALSE,
                                                                          filter = "none",
                                                                          options = list(info = FALSE,
                                                                                         ordering = FALSE,
                                                                                         paging = FALSE,
                                                                                         searching = FALSE),
                                                                          rownames = FALSE,
                                                                          selection = list(mode = "single",
                                                                                           target = "row"),
                                                                          style = "semanticui")
                                                          })


                      SelectedObjectName <- reactive({ req(session$userData$ServerWorkspaceInfo())
                                                       req(input$WorkspaceObjects_rows_selected)

                                                       # Get the index of the selected row using DT functionality
                                                       RowIndex <- input$WorkspaceObjects_rows_selected

                                                       # Returning name of object selected in table
                                                       session$userData$ServerWorkspaceInfo()$Overview$Object[RowIndex]
                                                     })


                      DataObjectDetails <- reactive({ req(session$userData$ServerWorkspaceInfo())
                                                      req(SelectedObjectName())

                                                      session$userData$ServerWorkspaceInfo()$Details[[SelectedObjectName()]]$ContentOverview
                                                    })


                      output$ObjectDetails <- renderDT({ req(DataObjectDetails())

                                                         DT::datatable(data = DataObjectDetails(),
                                                                       class = "ui small compact inverted selectable table",
                                                                       editable = FALSE,
                                                                       escape = FALSE,
                                                                       filter = "none",
                                                                       options = list(info = FALSE,
                                                                                      ordering = FALSE,
                                                                                      paging = FALSE,
                                                                                      searching = FALSE,
                                                                                      layout = list(top = NULL)),
                                                                       rownames = FALSE,
                                                                       selection = list(mode = "single",
                                                                                        target = "row"),
                                                                       style = "semanticui")
                                                      })


                      SelectedElementName <- reactive({ req(DataObjectDetails())
                                                        req(input$ObjectDetails_rows_selected)

                                                        # Get the index of the selected row using DT functionality
                                                        RowIndex <- input$ObjectDetails_rows_selected

                                                        # Returning name of element selected in table
                                                        DataObjectDetails()$Element[RowIndex]
                                                      })

                      return(list(Object = SelectedObjectName,
                                  Element = SelectedElementName))
                 })
}
