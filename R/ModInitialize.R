
# --- Module Initialize ---

# Has no UI component, only server

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module server component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param input
#' @param output
#' @param session
#' @param CCPCredentials
#' @param CCPTestData
#' @noRd
ModInitialize <- function(id,
                          CCPCredentials,
                          CCPTestData)
{
    moduleServer(id,
                 function(input, output, session)
                 {
                      if (!is.null(CCPCredentials)) { session$userData$CCPCredentials(CCPCredentials) }

                      if (!is.null(CCPTestData)) { session$userData$CCPTestData <- CCPTestData }
                 })
}
