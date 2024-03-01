

# --- Module: MessageMonitor ---


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @noRd
ModMessageMonitor_UI <- function(id)
{
    ns <- NS(id)

    tagList(uiOutput(ns("Messages")),
            textOutput(ns("ProcessingMonitor")))
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module server component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param input
#' @param output
#' @param session
#' @noRd
ModMessageMonitor_Server <- function(id, MessagesList)
{
    stopifnot(is.reactive(MessagesList))

    moduleServer(id,
                 function(input, output, session)
                 {
                      #output$ProcessingMonitor <- renderText({ paste0(unlist(MessagesList()), collapse = " ") })


                      output$Messages <- renderUI({
                                                        purrr::map(.x = MessagesList(),
                                                                  .f = function(Subvector)
                                                                       {
                                                                          #paste0(names(Subvector), collapse = "")

                                                                          MessageMonitorList <- list()

                                                                            for (i in 1:length(Sublist))      # for-loop instead of nested purrr::walk because the latter seems to address Sublist[[i]] instead of Sublist[i]
                                                                            {
                                                                                message <- Sublist[i]

                                                                                IconClass <- dplyr::case_when(names(message) == "Info" ~ "info circle",
                                                                                                              names(message) == "Success" ~ "check circle",
                                                                                                              names(message) == "Warning" ~ "exclamation triangle",
                                                                                                              names(message) == "Failure" ~ "times circle",
                                                                                                              TRUE ~ "none")

                                                                                MessageMonitorList <- c(MessageMonitorList,
                                                                                                        list(div(icon(class = IconClass),
                                                                                                              as.character(message))))


                                                                            }

                                                                          return(MessageMonitorList)
                                                                         })
                                                  })
                 })
}


