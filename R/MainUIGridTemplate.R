
#' MainUIGridTemplate
#'
#' Define main UI grid layout for desktop and mobile clients using shiny.semantic::grid_template()
#'
#' @return The output of shiny.semantic::grid_template()
#' @keywords internal
#' @export
#'
#' @examples
MainUIGridTemplate <- function()
{
    shiny.semantic::grid_template(

        default = list(areas = rbind(c("header", "header", "header"),
                                     c("leftside", "main", "rightside")),

                       rows_height = c("100px", "auto"),

                       cols_width = c("1fr", "4fr", "1fr")),

        mobile = list(areas = rbind(c("header", "header", "header"),
                                    c("leftside", "main", "rightside")),

                      rows_height = c("70px", "auto"),

                      cols_width = c("1fr", "4fr", "1fr"))
    )
}

# Test: Display grid template

#display_grid(MainUIGridTemplate())
