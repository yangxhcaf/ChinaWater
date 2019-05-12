#' Main function for crawling China flow data
#'
#' @examples
#' \dontrun{
#' library(lubridate)
#' dates <- seq(ymd("1946-01-01"), ymd("2019-04-25"), by = "day") #%>% format()
#' dates <- {dates + dhours(c(8))} %>% set_names(format_POSIXt(.))
#' plyr::l_ply(dates[1:8], history, outdir = "hubei", prefix = "hubei",
#'      FUN = his_hubei)
#' }
#' 
#' @export
history <- function(date, outdir = ".", prefix = "", FUN = NULL) {
    outfile <- sprintf("%s/%s_%s.csv", outdir, prefix, format(date, "%Y-%m-%d_%H%M"))

    if (!dir.exists(outdir)) {dir.create(outdir, recursive=TRUE)}
    if (!file.exists(outfile)){
        tryCatch({
            res <- FUN(date)
            # judge data.frame or list
            if (is.data.frame(res)) res <- list(res)

            names <- names(res)
            for(i in seq_along(names)) {
                d <- res[[i]]
                multi_subfix <- ifelse(i >= 2, paste0("_", i-1), "")
                outfile <- sprintf("%s/%s_%s%s.csv", outdir, prefix,
                    format(date, "%Y-%m-%d_%H%M"), multi_subfix)
                write.table(d, outfile, row.names = F, sep = ",", fileEncoding = "gbk")
            }
        }, error = function(e){
            message(sprintf("[e]: %s, %s", date, e$message))
        })
    }
}
