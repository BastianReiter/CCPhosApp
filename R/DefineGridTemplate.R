
#' DefineGridTemplate
#'
#' Define grid layout for desktop and mobile clients using shiny.semantic::grid_template()
#'
#' @return The output of shiny.semantic::grid_template()
#' @keywords internal
#' @export
#'
#' @examples
DefineGridTemplate <- function()
{
    shiny.semantic::grid_template(

        default = list(areas = rbind(c("header", "header", "header"),
                                        c("menu", "main1", "right"),
                                        c("menu", "main2", "right")),

                       rows_height = c("70px", "auto", "auto"),

                       cols_width = c("1fr", "4fr", "1fr")),

        mobile = list(areas = rbind(c("header", "header", "header"),
                                        c("menu", "main", "right"),
                                        c("menu", "main", "right")),

                      rows_height = c("50px", "300px", "auto"),

                      cols_width = c("200px", "2fr", "1fr"))
    )
}

# Test: Display grid template

#display_grid(GetGridTemplate())
