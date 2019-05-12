#' rt_GuangXi
#'
#' @param ... other parameters to [GET2()] or [POST2()]
#'
#' @importFrom purrr map map_df
#' @importFrom data.table as.data.table is.data.table
#' @export
rt_GuangXi <- function(outdir = ".", timestamp = TRUE, ...){
    # url <- "http://xxfb.hydroinfo.gov.cn/ssIndex.html"
    doc <- GET2("http://slt.gxzf.gov.cn:9000/gxsl/japi/api/sl323/realtime/river", 
        add_headers(Referer = "http://slt.gxzf.gov.cn:9000/page/index.html?act=3"), ...)
    d <- content(doc, encoding = "utf-8")$result %>% map_df(as.data.table) %>%
        data.table() %>% reorder_name("TM")
    d$TM <- as_datetime(d$TM/1e3) %>% format()

    fix_blankstr <- . %>% gsub(" ", "", .)
    vars <- c("HNNM", "RVNM", "STNM", "BSNM")
    d[, (vars) := lapply(.SD, fix_blankstr), .SDcols = vars]

    time_system <- Sys.time()
    if (timestamp) {
        date_sys <- format(time_system, "%Y-%m-%d %H:00:00")
        d <- cbind(system.time = date_sys, d)
    }

    outfile <- sprintf('%s/guangxi (%s).txt', outdir, format(time_system, "%Y%m%d-%H%M00"))
    fwrite(d, outfile)
    d
}
