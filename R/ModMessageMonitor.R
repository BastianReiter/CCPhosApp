

# --- Module: MessageMonitor ---


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @noRd
ModMessageMonitor_UI <- function(id)
{
    ns <- NS(id)

    shinyjs::hidden(uiOutput(ns("MessageMonitor"), style = "line-height: 0.6;"))
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
                                                          HtmlOutput <- list()

                                                          for (i in 1:length(MessagesList()))
                                                          {
                                                              for (j in 1:length(MessagesList()[[i]]))
                                                              {
                                                                  message <- MessagesList()[[i]][j]

                                                                  if (names(message) == "Topic")
                                                                  {
                                                                      HtmlMessage <- div(class = "ui horizontal divider", as.character(message))
                                                                  }
                                                                  else
                                                                  {
                                                                      IconClass <- dplyr::case_when(names(message) == "Info" ~ "blue info circle",
                                                                                                    names(message) == "Success" ~ "green check circle",
                                                                                                    names(message) == "Warning" ~ "orange exclamation triangle",
                                                                                                    names(message) == "Failure" ~ "red times circle",
                                                                                                    TRUE ~ "none")

                                                                      HtmlMessage <- br(span(style = "font-size: 0.8em;", shiny.semantic::icon(class = IconClass), as.character(message)))
                                                                  }

                                                                  HtmlOutput <- c(HtmlOutput,
                                                                                  list(HtmlMessage))
                                                              }
                                                          }

                                                          HtmlOutput
                                                        })

                      observe({ shinyjs::showElement(id = "MessageMonitor", anim = TRUE, animType = "fade") }) %>%
                          bindEvent(MessagesList())
                  })
}


