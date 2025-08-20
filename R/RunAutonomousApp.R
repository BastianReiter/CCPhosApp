
#' RunAutonomousApp
#'
#' Set up a background process essentially running a separate R session. Use this session to run a Shiny app autonomously from hosting R session.
#'
#' @param ShinyAppInitFunction
#'
#' @return An \code{r_process} object. See also documentation for \code{callr::r_bg()}.
#'
#' @export
#' @author Bastian Reiter
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
RunAutonomousApp <- function(ShinyAppInitFunction,
                             Arguments = NULL,
                             Host = "127.0.0.1",
                             Port = 49152)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{
  require(callr)
  require(pingr)

  # --- For Testing Purposes ---
  # ShinyAppInitFunction <- CCPhosApp::StartCCPhosApp
  # AppArguments <- list(CCPTestData = TestData)
  # Host <- "127.0.0.1"
  # Port <- 49153

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  Process <- callr::r_bg(
                args = list(ShinyApp.Bg = ShinyApp,
                            AppArguments.Bg = AppArguments,
                            Host.Bg = Host,
                            Port.Bg = Port),
                func = function(ShinyApp.Bg, AppArguments.Bg, Host.Bg, Port.Bg)
                       {
                          #TestData <- readRDS("../dsCCPhos/Development/Data/TestData/CCPTestData.rds")

                          # Load namespace of CCPhosApp for new background R session
                          library(CCPhosApp)
                          library(shiny)

                          # Start CCPhos app
                          shiny::runApp(do.call(ShinyApp.Bg, AppArguments.Bg),
                                        port = Port.Bg,
                                        host = Host.Bg,
                                        launch.browser = FALSE)

                       },
                supervise = TRUE)

  # Check if URL is responding and stall if it needs time loading (Credit to Will Landau)
  while(!pingr::is_up(destination = Host, port = Port))
  {
    if (!Process$is_alive()) stop(Process$read_all_error())   # If process was ended for some reason, print error messages.
    Sys.sleep(0.01)   # Stall - Effectively check every 0.01 seconds if URL is available yet
  }

  # Open browser window hosting the app
  browseURL(paste0("http://", Host, ":", Port))

  return(Process)
}


# Now manually open browser
# browseURL("http://127.0.0.1:49154")
#
# library(rstudioapi)
# viewer(url = "http://127.0.0.1:49154")
#
# TestProcess$is_alive()
# TestProcess$read_error()
# TestProcess$kill()

