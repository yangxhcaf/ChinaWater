params_comm <- list(
    'callCount'       = '1',
    'page'            = '/ssIndex.html',
    'httpSessionId'   = 'BDC132943F6447CF681C16573CC6B29E.tomcat1',
    'scriptSessionId' = '2F59B9F0873B46C9B7654145BB0B19F0674',
    'c0-scriptName'   = 'IndexDwr',
    'c0-methodName'   = 'getSreachData',
    'c0-id'           = '0',
    'c0-param1'       = 'string:',
    'c0-param2'       = 'string:',
    'batchId'         = '1')
params_reservoir <- list('c0-param0' = 'string:sk') %>% c(params_comm, .)
params_river     <- list('c0-param0' = 'string:hd') %>% c(params_comm, .)
params_rain      <- list('c0-param0' = 'string:yl') %>% c(params_comm, .)

colnames_reservoir <- c("basin", "prov", "river", "site", "Z", "Q_in", "Z_max")
colnames_river     <- c("basin", "prov", "river", "site", "time", "Z", "Q", "Z_warn")
colnames_rain      <- c("basin", "prov", "river", "site", "time", "prcp", "weather")

#' rt_ChinaWater
#'
#' Get China curl_realtime water data.
#'
#' @inheritParams curl_realtime
#' @param type reservoir, river, rain
#'
#' @examples
#' \dontrun{
#' d_sk    <- rt_ChinaWater('reservoir')
#' d_river <- rt_ChinaWater('river')
#' d_rain  <- rt_ChinaWater('rain')
#' }
#' @importFrom stringi stri_unescape_unicode
#' @export
rt_ChinaWater <- function(type = "reservoir", outdir = ".", timestamp = TRUE, ...){
    if (type == "reservoir"){
        varnames <- colnames_reservoir
        params   <- params_reservoir
    } else if (type == "river") {
        varnames <- colnames_river
        params   <- params_river
    } else if (type == "rain") {
        varnames <- colnames_rain
        params   <- params_rain
    }

    # url <- "http://xxfb.hydroinfo.gov.cn/ssIndex.html"
    url <- "http://xxfb.hydroinfo.gov.cn/dwr/call/plaincall/IndexDwr.getSreachData.dwr"

    doc <- POST2(url, body = params, encode = "form",
            Referer = "http://xxfb.hydroinfo.gov.cn/svg/svghtml.html",
            Host = "xxfb.hydroinfo.gov.cn",
            Origin = "http://xxfb.hydroinfo.gov.cn", ...
        )
    p <- content(doc, encoding = "utf-8")
    str <- str_extract(p, '(?<=").*(?="\\);)') %>%
        {stri_unescape_unicode(gsub("\\U","\\u", ., fixed=TRUE))}

    # substr(str, 1, 1000) %>% print()
    t <- read_html(str) %>% xml_find_first("//table") #%>% html_table()
    d <- html_table(t) %>% set_colnames(varnames)

    time_system <- Sys.time()
    if (type != "rain") {
        # detect date info
        str_info <-  xml_find_all(t, "//font[@onmouseover]") %>% {
            .[seq(1, length(.), 2)]
        } %>% xml_attr("onmouseover")
        sid <- str_extract(str_info, "\\d{7,12}")
        time <- str_extract(str_info, "\\d{4}-\\d{2}-\\d{2}") # (?<=,').*(?=',)

        d %<>% cbind(time, sid, .)
    }

    if (timestamp) {
        date_sys <- format(time_system, "%Y-%m-%d %H:00:00")
        d <- cbind(system.time = date_sys, d)
    }

    outfile <- sprintf('%s/chinawater_%s (%s).txt', outdir, type,
        format(time_system, "%Y%m%d-%H%M00"))
    fwrite(d, outfile)
    d
}
