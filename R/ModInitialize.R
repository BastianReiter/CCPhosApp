
# --- Module Initialize ---

# Has no UI component, only server

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module server component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param input
#' @param output
#' @param session
#' @param CCPSiteSpecifications
#' @param CCPTestData
#' @param RDSTableCheckData
#' @param CurationReportData
#' @noRd
ModInitialize <- function(id,
                          CCPSiteSpecifications,
                          CCPTestData,
                          RDSTableCheckData,
                          CurationReportData)
{
    moduleServer(id,
                 function(input, output, session)
                 {
                      if (!is.null(CCPSiteSpecifications))
                      { session$userData$CCPSiteSpecifications(CCPSiteSpecifications)
                      } else { session$userData$CCPSiteSpecifications(as.data.frame(dsCCPhosClient::CCPSiteSpecifications)) }

                      if (!is.null(CCPTestData)) { session$userData$CCPTestData <- CCPTestData }

                      if (!is.null(RDSTableCheckData)) { session$userData$RDSTableCheck(RDSTableCheckData) }

                      if (!is.null(CurationReportData)) { session$userData$CurationReport(CurationReportData) }
                 })
}
