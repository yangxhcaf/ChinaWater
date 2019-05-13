#' @references
#' [2] HuNan, http://61.187.56.156/wap/index_sq.asp
#' @rdname his_
#' @export
his_HuNan <- function(date = Sys.Date(), ...) {
    d_hnsq <- his_HuNan_type(date, "hnsq")
    d_dxsk <- his_HuNan_type(date, "dxsk")

    # d_zykz <- his_HuNan_type(date, "zykz")
    list(all = d_hnsq, reservoir = d_dxsk)
}

# ' his_HuNan_type
# '
# ' @param type
# ' hnsq: river stations
# ' zykz: key river stations
# ' dxsk: big reservoir
# '
#' @importFrom rvest html_table
his_HuNan_type <- function(date = Sys.Date(), type = "hnsq", ...) {
    # 2-7: 湘江, 资水, 沅水, 澧水流域, 长江, 洞庭湖
    # names for hnsq
    names_hnsq <- c('水系', '河名', '站名', '时间', '水位', '涨落', '较前日8时', '流量',
        '警戒水位', '历史最高水位', '发生时间', '所属地区', '所在县', '控制面积')

    # construct url
    get_url <- function(date, liuyu = NULL){
        url_root <- sprintf("http://61.187.56.156/wap/%s_BB2.asp", type)

        year  <- year(date)
        month <- month(date)
        day   <- day(date)
        shi   <- format(date, "%H:%M") %>% URLencode(reserved = TRUE)

        liuyu <- sprintf("&liuyu=%d", liuyu)
        if (length(liuyu) == 0) liuyu = ""

        sprintf("%s?printflag=1%s&nian=%d&yue=%d&ri=%d&shi=%s&%s",
                url_root, liuyu, year, month, day, shi,
                "queding=%C8%B7%B6%A8&dayin=%B4%F2%D3%A1&baocun=%B1%A3%B4%E6%CE%AAExcel&tuichu=%CD%CB%B3%F6")
    }

    header <- ifelse(type == "hnsq", FALSE, TRUE)
    # extract data from url
    extract_data <- function(liuyu=NULL){
        url <- get_url(date, liuyu)
        p <- RETRY("GET", url) %>% content(encoding = "GBK")

        x <- xml_find_first(p, "//table")
        d <- html_table(x, header = header) %>% data.table()

        if (type == "hnsq") { colnames(d) <- names_hnsq }
        d
    }

    if (type == "hnsq") {
        d <- lapply(2:7, extract_data) %>% do.call(rbind, .)
    } else if (type == "zykz") {
        d <- extract_data()
    } else if (type == "dxsk") {
        d <- extract_data()
    }

    cbind(date = format_POSIXt(date), d)
    # params_i <- update_params(date)
    # p <- POST(url_root, params_i, encode = "form") %>% content(encoding = "GBK")
}
