
# --- Module Initialize ---

# Has no UI component, only server

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module server component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param input
#' @param output
#' @param session
#' @param ServerSpecifications
#' @param CCPTestData
#' @param RDSTableCheckData
#' @param CDSTableCheckData
#' @param ADSTableCheckData
#' @param CurationReportData
#' @noRd
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ModInitialize <- function(id,
                          ServerSpecifications,
                          CCPTestData,
                          RDSTableCheckData,
                          CDSTableCheckData,
                          ADSTableCheckData,
                          CurationReportData)
{
    moduleServer(id,
                 function(input, output, session)
                 {
                      if (!is.null(ServerSpecifications))
                      { session$userData$ServerSpecifications(ServerSpecifications)
                      } else { session$userData$ServerSpecifications(as.data.frame(dsCCPhosClient::ServerSpecifications)) }

                      if (!is.null(CCPTestData)) { session$userData$CCPTestData <- CCPTestData }

                      if (!is.null(RDSTableCheckData)) { session$userData$RDSTableCheck(RDSTableCheckData) }

                      if (!is.null(CDSTableCheckData)) { session$userData$CDSTableCheck(CDSTableCheckData) }

                      if (!is.null(ADSTableCheckData)) { session$userData$ADSTableCheck(ADSTableCheckData) }

                      if (!is.null(CurationReportData)) { session$userData$CurationReport(CurationReportData) }
                 })
}
