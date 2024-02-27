
#' Module ProcessingSteps UI function
#'
#' @param id
#' @noRd
ModProcessingSteps_UI <- function(id)
{
    tagList(shiny.semantic::steps(id = NS(id, "steps"),
                                  class = "ui vertical steps",
                                  steps_list = list(

                                      single_step(id = "Credentials",
                                                  title = "Enter credentials",
                                                  #description = "Enter credentials",
                                                  icon_class = "key"),

                                      single_step(id = "Connect",
                                                  title = "Connect to CCP",
                                                  #description = "Connect to CCP",
                                                  icon_class = "door open"),

                                      single_step(id = "ServerRequirements",
                                                  title = "Check server requirements",
                                                  #description = "Check server requirements",
                                                  icon_class = "glasses"),

                                      single_step(id = "LoadData",
                                                  title = "Load data",
                                                  description = "From Opal DB into R session",
                                                  icon_class = "database"),

                                      single_step(id = "CurateData",
                                                  title = "Curate data",
                                                  description = "Transform raw into curated data",
                                                  icon_class = "wrench")

                                  ))
    )
}


#' Module ProcessingSteps Server function
#'
#' @param id, input, output, session
#' @noRd
ModProcessingSteps_Server <- function(id)
{
    moduleServer(id,
                 function(input, output, session)
                 {

                 }
    )
}
