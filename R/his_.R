# http://61.187.56.156/wap/hnsq_BB2.asp
# printflag=1&liuyu=2&nian=2019&yue=5&ri=2&shi=22%3A00&
# queding=%C8%B7%B6%A8&dayin=%B4%F2%D3%A1&baocun=%B1%A3%B4%E6%CE%AAExcel&tuichu=%CD%CB%B3%F6

#' @name his_
#' @title his_
NULL

#' @inheritParams curl_realtime
#' @param date Date object, of querying
#' @param ... ignored.
#' 
#' @references
#' [1] http://113.57.190.228:8001/web/Report/RiverReport#
#'
#' @rdname his_
#' @export
his_HuBei <- function(date, ...) {
    url_root <- "http://113.57.190.228:8001/Web/Report/GetRiverData?date="
    url <- sprintf("%s%s", url_root, format(date, "%Y-%m-%d %H:%M")) %>% URLencode()

    p <- RETRY("GET", url) %>% content(encoding = "utf-8")
    d <- p$rows %>% map(as.data.table) %>% do.call(rbind, .) %>% {
        d1 <- .[, 1:11]
        d2 <- .[, 12:22] %>% set_colnames(names(d1))
        rbind(d1, d2)
    }
    d
}


#' @rdname his_
#' @export
his_yellowRiver <- function(date, ...){
    url_root <- "http://61.163.88.227:8006/hwsq.aspx?tdsourcetag=s_pctim_aiomsg"
    outfile <- sprintf("yr_%s.csv", date)
    params[[4]] <- date
    r <- RETRY("POST", url_root, body = params, encode = "form") %>% content()

    tables <- xml_find_all(p, '//table[@width="100%" and @class="mainTxt"]')
    d <- map_dfr(tables, html_table, header = T) %>% data.table()
    d
}
