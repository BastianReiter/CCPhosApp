
#' DataFrameToHtmlTable
#'
#' @param DataFrame
#' @param SemanticTableClass
#' @param RotatedHeaderNames
#' @param TurnLogicalIntoIcon
#' @param CategoryColumn \code{string}
#' @param RowColorColumn \code{string}
#' @param CellClassColumns character vector
#'
#' @return
#' @export
#' @author Bastian Reiter
DataFrameToHtmlTable <- function(DataFrame,
                                 SemanticTableClass = "ui celled table",
                                 RotatedHeaderNames = character(),
                                 TurnLogicalIntoIcon = FALSE,
                                 CategoryColumn = NULL,
                                 RowColorColumn = NULL,
                                 CellClassColumns = NULL)
{
    # For testing purposes only
    # DataFrame <- dsCCPhos::Meta_FeatureNames
    # DataFrame <- DataFrame %>% mutate(CellClass_TableName_Curated = "Success")
    # SemanticTableClass = "ui celled table"
    # RotatedHeaderNames = character()
    # TurnLogicalIntoIcon = FALSE
    # CategoryColumn <- "TableName_Raw"
    # RowColorColumn <- NULL
    # CellClassColumns <- c("CellClass_TableName_Curated")


    require(dplyr)
    require(shiny)
    require(shiny.semantic)

    # If DataFrame is empty return empty string
    if (is.null(DataFrame))
    {
        return("")
    }


    # If there are special purpose columns, don't render their content in the table
    HiddenColumns <- c(CategoryColumn,
                       RowColorColumn,
                       CellClassColumns)


    # If there is a column informing about categories, get all unique category values
    CategoryValues <- "None"
    if (!is.null(CategoryColumn))
    {
        CategoryValues <- unique(DataFrame[[CategoryColumn]])
    }


    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Table Header: Get collection of th-elements as character-vector
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    StringsTableHeadRow <- purrr::modify(.x = colnames(DataFrame),
                                         function(colname)
                                         {
                                            if (!(colname %in% HiddenColumns))      # Don't include headers from hidden columns
                                            {
                                                 paste0(ifelse(colname %in% RotatedHeaderNames,
                                                               "tags$th(class = 'rotate', ",
                                                               "tags$th("),
                                                        "div(span(",
                                                        "'", colname, "')))")
                                            }
                                            else { return(NA) }
                                         })

    # Make single string for thead-element
    StringTableHead <- paste0("tags$thead(tags$tr(",
                              paste0(StringsTableHeadRow[!is.na(StringsTableHeadRow)], collapse = ", "),
                              "))")


    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Table body rows: Get collection of tr- and td-elements as character vectors
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    StringsTableRows <- character()
    Data <- DataFrame

    # --- Loop through CATEGORIES (optionally) ---------------------------------
    for (k in 1:length(CategoryValues))
    {
        if (!is.null(CategoryColumn))
        {
            # Add a subheader-row for current category
            StringsTableRows <- c(StringsTableRows,
                                  paste0("tags$tr(tags$th(style = 'background-color: #d0d0d0;
                                                                   color: white;',
                                                          colspan = '",
                                         ncol(DataFrame) - length(HiddenColumns),   # Number of columns that subheader-row is spanning over
                                         "', '",
                                         CategoryValues[k],
                                         "'))"))

            # Select only rows in data that belong to current category
            Data <- DataFrame[DataFrame[[CategoryColumn]] == CategoryValues[k], ]
        }

        # --- Loop through ROWS ------------------------------------------------
        for (i in 1:nrow(Data))
        {
            StringsTableRowCells <- character()

            # --- Loop through COLUMNS -----------------------------------------
            for(j in 1:ncol(Data))
            {
                if (!(names(Data)[j] %in% HiddenColumns))      # Don't include cells from hidden columns
                {
                    CellValue <- as.character(Data[i, j])
                    CellClass <- "None"
                    CellIcon <- "None"

                    # In case there is a column defining a cell class for the current column data
                    if (paste0("CellClass_", names(Data)[j]) %in% names(Data))
                    {
                        CellClass <- as.character(Data[i, paste0("CellClass_", names(Data)[j])])

                        # Determine code for icon to be displayed in cell based on cell class
                        CellIcon <- case_when(CellClass == "CellClass_Success" ~ "icon(class = 'small green check')",
                                              CellClass == "CellClass_Failure" ~ "icon(class = 'small red times')",
                                              TRUE ~ "None")
                    }

                    StringsTableRowCells <- c(StringsTableRowCells,
                                              paste0("tags$td(",
                                                     #--- Assign CSS class to cell if option is passed ---
                                                     ifelse(CellClass != "None",
                                                            paste0("class = '", CellClass, "', "),
                                                            ""),
                                                     #--- Turn logical cell value into icon if option is passed ---
                                                     ifelse(TurnLogicalIntoIcon == TRUE,
                                                            case_when(CellValue == TRUE ~ "icon(class = 'small green check')",
                                                                      CellValue == FALSE ~ "icon(class = 'small red times')",
                                                                      TRUE ~ paste0("'", CellValue, "'")),
                                                            paste0("'", CellValue, "'")),
                                                     #--- Add optional icon to value as determined by cell class ---
                                                     ifelse(CellIcon != "None",
                                                            paste0(", HTML('&ensp;'), ", CellIcon),      # Add two spaces before icon
                                                            ""),
                                                     ")"))
                }
            }

            # Optionally determine class attribute for tr-element to colorize row
            RowColor <- ifelse(is.null(RowColorColumn),
                               "",
                               paste0("class = '", Data[i, RowColorColumn], "', "))

            # Add current row to table
            StringsTableRows <- c(StringsTableRows,
                                  paste0("tags$tr(",
                                         RowColor,
                                         paste0(StringsTableRowCells, collapse = ", "),
                                         ")"))
        }
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
