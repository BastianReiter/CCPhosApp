
# --- Module Initialize ---

# Has no UI component, only server

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module Server
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' Module Initialize Server function
#'
#' @param id
#' @param input
#' @param output
#' @param session
#' @noRd
ModInitialize <- function(id,
                          CCPCredentials,
                          CCPTestData)
{
    moduleServer(id,
                 function(input, output, session)
                 {
                      session$userData$CCPConnections <- "None"

                      if (!is.null(CCPCredentials)) { session$userData$CCPCredentials <- CCPCredentials }

                      if (!is.null(CCPTestData)) { session$userData$CCPTestData <- CCPTestData }


                 })
}
