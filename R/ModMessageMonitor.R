

# --- Module: MessageMonitor ---


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @noRd
ModMessageMonitor_UI <- function(id)
{
    ns <- NS(id)

    shinyjs::hidden(uiOutput(ns("MessageMonitor")))
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
                      output$MessageMonitor <- renderUI({
                                                          HtmlTotal <- list()

                                                          for (i in 1:length(MessagesList()))
                                                          {
                                                              Topic <- names(MessagesList()[i])

                                                              for (j in 1:length(MessagesList()[[i]]))
                                                              {
                                                                  message <- MessagesList()[[i]][j]

                                                                  IconClass <- dplyr::case_when(names(message) == "Info" ~ "blue info circle",
                                                                                                names(message) == "Success" ~ "green check circle",
                                                                                                names(message) == "Warning" ~ "orange exclamation triangle",
                                                                                                names(message) == "Failure" ~ "red times circle",
                                                                                                TRUE ~ "none")

                                                                  HtmlMessage <- br(span(style = "font-size: 0.8em;", shiny.semantic::icon(class = IconClass), as.character(message)))

                                                                  HtmlTotal <- c(HtmlTotal,
                                                                                 list(HtmlMessage))
                                                              }
                                                          }

                                                          HtmlTotal
                                                        })

                      observe({ shinyjs::showElement(id = "MessageMonitor", anim = TRUE, animType = "fade") }) %>%
                          bindEvent(MessagesList())
                  })
}


