
#' ConvertLogicalToIcon
#'
#' @param DataFrame \code{data.frame} or \code{tibble}
#'
#' @return \code{data.frame}
#' @export
#' @author Bastian Reiter
ConvertLogicalToIcon <- function(DataFrame)
{
    if (!is.null(DataFrame))
    {
        DataFrame %>%
            mutate(across(.cols = where(is.logical),
                          .fns = ~ case_match(.x,
                                              TRUE ~ as.character(icon(class = "small green check")),
                                              FALSE ~ as.character(icon(class = "small red times")))))
    }
    else { return(NULL) }
}
