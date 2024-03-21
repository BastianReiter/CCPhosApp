
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
#' @noRd
ModInitialize <- function(id,
                          CCPSiteSpecifications,
                          CCPTestData)
{
    moduleServer(id,
                 function(input, output, session)
                 {
                      if (!is.null(CCPSiteSpecifications)) { session$userData$CCPSiteSpecifications(CCPSiteSpecifications) }
                      else { session$userData$CCPSiteSpecifications(as.data.frame(dsCCPhosClient::CCPSiteSpecifications)) }

                      if (!is.null(CCPTestData)) { session$userData$CCPTestData <- CCPTestData }
                 })
}
