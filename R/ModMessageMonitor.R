

# --- Module: MessageMonitor ---


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module UI component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @noRd
ModMessageMonitor_UI <- function(id)
{
    ns <- NS(id)

    div(id = ns("MessagesContainer"),
        class = "ui scrollable segment",
        style = "height: 100%;
                 overflow: auto;",

        div(class = "ui top attached label",
            "Messages"),

        uiOutput(ns("Messages"), style = "line-height: 0.6;"))
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Module server component
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#' @param id
#' @param MessagesList
#' @param input
#' @param output
#' @param session
#' @noRd
ModMessageMonitor_Server <- function(id,
                                     MessagesList)
{
    # Formal check if argument is reactive (relevant only during development)
    stopifnot(is.reactive(MessagesList))

    moduleServer(id,
                 function(input, output, session)
                 {
                      output$Messages <- renderUI({ HtmlReturn <- list()

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

                                                            HtmlReturn <- c(HtmlReturn,
                                                                            list(HtmlMessage))
                                                        }
                                                    }

                                                    HtmlReturn
                                                  }) %>%
                          bindEvent(MessagesList())
                  })
}


