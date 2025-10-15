
# --- Module Initialize ---

# Has no UI component, only server

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module server component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @noRd
#-------------------------------------------------------------------------------
ModInitialize <- function(id,
                          ADSTableCheckData = NULL,
                          CCPTestData = NULL,
                          CDSTableCheckData = NULL,
                          CurationReportData = NULL,
                          DSConnections = NULL,
                          RDSTableCheckData = NULL,
                          ServerSpecifications = NULL,
                          ServerWorkspaceInfo = NULL)
#-------------------------------------------------------------------------------
{
  moduleServer(id,
               function(input, output, session)
               {
                  if (!is.null(ServerSpecifications)) { session$userData$ServerSpecifications(ServerSpecifications)
                  } else if (!is.null(session$userData$ServerSpecifications)) { session$userData$ServerSpecifications(as.data.frame(dsCCPhosClient::ServerSpecifications)) }

                  if (!is.null(DSConnections)) { session$userData$DSConnections(DSConnections) }

                  if (!is.null(CCPTestData)) { session$userData$CCPTestData <- CCPTestData }

                  if (!is.null(ServerWorkspaceInfo)) { session$userData$ServerWorkspaceInfo(ServerWorkspaceInfo) }

                  if (!is.null(RDSTableCheckData)) { session$userData$RDSTableCheck(RDSTableCheckData) }

                  if (!is.null(CDSTableCheckData)) { session$userData$CDSTableCheck(CDSTableCheckData) }

                  if (!is.null(ADSTableCheckData)) { session$userData$ADSTableCheck(ADSTableCheckData) }

                  if (!is.null(CurationReportData)) { session$userData$CurationReport(CurationReportData) }
               })
}
