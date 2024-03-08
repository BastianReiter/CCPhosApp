
#' DataFrameToHtmlTable
#'
#' @param DataFrame
#' @param SemanticTableClass
#' @param RotatedHeaderNames
#'
#' @return
#' @export
#' @author Bastian Reiter
DataFrameToHtmlTable <- function(DataFrame,
                                 SemanticTableClass = "ui celled table",
                                 RotatedHeaderNames = character(),
                                 TurnLogicalIntoIcons = FALSE)
{
    require(dplyr)
    require(shiny)
    require(shiny.semantic)

    # If DataFrame is empty return empty string
    if (is.null(DataFrame))
    {
        return("")
    }


    # Get collection of th-elements as character-vector
    StringsTableHeadRow <- purrr::modify(.x = colnames(DataFrame),
                                         function(colname)
                                         {
                                             paste0(ifelse(colname %in% RotatedHeaderNames,
                                                           "tags$th(class = 'rotate', ",
                                                           "tags$th("),
                                                    "div(span(",
                                                    "'", colname, "')))")
                                         })

    # Make single string for thead-element
    StringTableHead <- paste0("tags$thead(tags$tr(",
                              paste0(StringsTableHeadRow, collapse = ", "),
                              "))")


    # Get collection of tr- and td-elements as character vectors
    StringsTableRows <- character()

    for (i in 1:nrow(DataFrame))
    {
        StringsTableRowCells <- character()

        for(j in 1:ncol(DataFrame))
        {
            CellValue <- DataFrame[i, j]

            StringsTableRowCells <- c(StringsTableRowCells,
                                      paste0("tags$td(",
                                             ifelse(TurnLogicalIntoIcons == TRUE,
                                                    case_when(CellValue == TRUE ~ "icon(class = 'small green check')",
                                                              CellValue == FALSE ~ "icon(class = 'small red times')",
                                                              TRUE ~ paste0("'", CellValue, "'")),
                                                    paste0("'", CellValue, "'")),
                                             ")"))
        }

        StringsTableRows <- c(StringsTableRows,
                              paste0("tags$tr(",
                                     paste0(StringsTableRowCells, collapse = ", "),
                                     ")"))
    }

    # Make single string for tbody-element
    StringTableBody <- paste0("tags$tbody(",
                              paste0(StringsTableRows, collapse = ", "),
                              ")")

    # Concatenate all substrings into one string
    HtmlCallString <- paste0("tags$table(class = '", SemanticTableClass, "', ",
                             StringTableHead,
                             ", ",
                             StringTableBody,
                             ")")

    # Evaluate string to return html code that can be processed by output-function in UI
    eval(parse(text = HtmlCallString))
}
