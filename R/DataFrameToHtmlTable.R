
#' DataFrameToHtmlTable
#'
#' @param DataFrame \code{data.frame} or \code{tibble}
#' @param TableID \code{string} Used to tidentify the table object in the DOM
#' @param CategoryColumn \code{string}
#' @param CellClassColumns character vector
#' @param ColContentHorizontalAlign Either a single string for all columns or a named character vector to determine horizontal content alignment for specific columns
#' @param ColumnClass Either a single string for all columns or a named character vector to determine table cell classes for specific columns
#' @param ColumnLabels named character vector
#' @param RotatedHeaderNames
#' @param RowColorColumn \code{string}
#' @param SemanticTableClass
#' @param TurnLogicalIntoIcon
#'
#' @return HTML code
#' @export
#' @author Bastian Reiter
DataFrameToHtmlTable <- function(DataFrame,
                                 TableID = NULL,
                                 CategoryColumn = NULL,
                                 CellClassColumns = NULL,
                                 ColContentHorizontalAlign = "left",
                                 ColumnClass = NULL,
                                 ColumnLabels = NULL,
                                 RotatedHeaderNames = character(),
                                 RowColorColumn = NULL,
                                 SemanticTableClass = "ui celled table",
                                 TurnLogicalIntoIcon = FALSE)
{
    # For testing purposes only
    # TableID <- NULL
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


    # If no explicit TableID is passed, assign it a random sample of letters
    TableID <- ifelse(is.null(TableID),
                      paste0(sample(LETTERS, 9, TRUE), collapse = ""),
                      TableID)


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
                                                HeaderCellClass <- ""

                                                # If 'ColContentHorizontalAlign' is a single string
                                                if (length(ColContentHorizontalAlign) == 1 & is.null(names(ColContentHorizontalAlign)))
                                                {
                                                    HeaderCellClass <- paste(HeaderCellClass,
                                                                             case_when(ColContentHorizontalAlign == "right" ~ "right aligned",
                                                                                       ColContentHorizontalAlign == "center" ~ "center aligned",
                                                                                       .default = ""))
                                                }

                                                # If 'ColContentHorizontalAlign' is a named vector with current column name in its names
                                                if (!is.null(names(ColContentHorizontalAlign)) & colname %in% names(ColContentHorizontalAlign))
                                                {
                                                    HeaderCellClass <- paste(HeaderCellClass,
                                                                             case_when(ColContentHorizontalAlign[colname] == "right" ~ "right aligned",
                                                                                       ColContentHorizontalAlign[colname] == "center" ~ "center aligned",
                                                                                       .default = ""))
                                                }

                                                # If optional 'RotatedHeaderNames' is passed
                                                if (colname %in% RotatedHeaderNames) { HeaderCellClass <- paste(HeaderCellClass, "rotate") }


                                                # Replace column label if passed in ColumnLabels
                                                if (colname %in% names(ColumnLabels)) { colname <- ColumnLabels[colname] }

                                                paste0("tags$th(",
                                                       "class = '", HeaderCellClass, "', ",   # Add th CSS class
                                                       "div(span('", colname, "')))")
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
                                  paste0("tags$tr(tags$th(style = 'background-color: #767676;
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
                ColumnName <- names(Data)[j]

                if (!(ColumnName %in% HiddenColumns))      # Don't include cells from hidden columns
                {
                    CellValue <- as.character(Data[i, j])
                    CellClass <- ""
                    CellIcon <- "None"

                    # Set specific column-wide CSS class for cells, if option is passed
                    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                    # If 'ColumnClass' is a single string
                    if (length(ColumnClass) == 1 & is.null(names(ColumnClass))) { CellClass <- paste(CellClass, ColumnClass) }

                    # If 'ColumnClass' is a named vector with current column name in its names
                    if (!is.null(names(ColumnClass)) & ColumnName %in% names(ColumnClass)) { CellClass <- paste(CellClass, ColumnClass[ColumnName]) }


                    # Set column-wide CSS class determining horizontal alignment, if option is passed
                    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                    # If 'ColContentHorizontalAlign' is a single string
                    if (length(ColContentHorizontalAlign) == 1 & is.null(names(ColContentHorizontalAlign)))
                    {
                        CellClass <- paste(CellClass,
                                           case_when(ColContentHorizontalAlign == "right" ~ "right aligned",
                                                     ColContentHorizontalAlign == "center" ~ "center aligned",
                                                     .default = ""))
                    }

                    # If 'ColContentHorizontalAlign' is a named vector with current column name in its names
                    if (!is.null(names(ColContentHorizontalAlign)) & ColumnName %in% names(ColContentHorizontalAlign))
                    {
                        CellClass <- paste(CellClass,
                                           case_when(ColContentHorizontalAlign[ColumnName] == "right" ~ "right aligned",
                                                     ColContentHorizontalAlign[ColumnName] == "center" ~ "center aligned",
                                                     .default = ""))
                    }


                    # Set value-dependent CSS class for cells, if optional class columns are passed
                    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                    # In case there is a column defining a value-dependent cell class for current data
                    if (paste0("CellClass_", ColumnName) %in% names(Data))
                    {
                        CellClass <- paste(CellClass,
                                           as.character(Data[i, paste0("CellClass_", ColumnName)]))

                        # Determine code for icon to be displayed in cell based on cell class (grepl() call checks if the string in 'CellClass' contains certain substrings)
                        CellIcon <- case_when(grepl("CellClass_Success", CellClass, fixed = TRUE) ~ "icon(class = 'small green check')",
                                              grepl("CellClass_Failure", CellClass, fixed = TRUE) ~ "icon(class = 'small red times')",
                                              TRUE ~ "None")
                    }

                    StringsTableRowCells <- c(StringsTableRowCells,
                                              paste0("tags$td(",
                                                     #--- Add td CSS class, if one is defined ---
                                                     ifelse(CellClass != "",
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
    HtmlCallString <- paste0("tags$table(id = '", TableID, "', class = '", SemanticTableClass, "', ",
                             StringTableHead,
                             ", ",
                             StringTableBody,
                             ")")

    # Evaluate string to return html code that can be processed by output-function in UI
    eval(parse(text = HtmlCallString))
}
