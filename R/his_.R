#' @export
his_hunan <- function(date = Sys.Date(), ...) {
    d_hnsq <- his_hunan_type(date, "hnsq")
    d_dxsk <- his_hunan_type(date, "dxsk")

    # d_zykz <- his_hunan_type(date, "zykz")
    list(all = d_hnsq, reservoir = d_dxsk)
}

#' Hunan
#'
#' basins:
#' 2: 湘江
#' 3: 资水
#' 4: 沅水
#' 5: 澧水流域
#' 6: 长江
#' 7: 洞庭湖
#'
#' @param type
#' hnsq: 全省水情日报
#' zykz: 控制站日报表
#' dxsk: 大型水库
#'
#' @references
#' http://61.187.56.156/wap/index_sq.asp
#' @export
his_hunan_type <- function(date = Sys.Date(), type = "hnsq", ...) {
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
        p <- httr::GET(url) %>% content(encoding = "GBK")

        d <- xml2::xml_find_first(p, "//table") %>% rvest::html_table(header = header) %>% data.table::data.table()
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

# http://61.187.56.156/wap/hnsq_BB2.asp
# printflag=1&liuyu=2&nian=2019&yue=5&ri=2&shi=22%3A00&
# queding=%C8%B7%B6%A8&dayin=%B4%F2%D3%A1&baocun=%B1%A3%B4%E6%CE%AAExcel&tuichu=%CD%CB%B3%F6

#' Hubei
#'
#' @references
#' http://113.57.190.228:8001/web/Report/RiverReport#
#'
#' @export
his_hubei <- function(date, ...) {
    url_root <- "http://113.57.190.228:8001/Web/Report/GetRiverData?date="
    url <- sprintf("%s%s", url_root, format(date, "%Y-%m-%d %H:%M")) %>% URLencode()

    p <- GET(url) %>% content(encoding = "utf-8")
    d <- p$rows %>% map(as.data.table) %>% do.call(rbind, .) %>% {
        d1 <- .[, 1:11]
        d2 <- .[, 12:22] %>% set_colnames(names(d1))
        rbind(d1, d2)
    }
    d
}


#' Yellow river
#' @export
his_yellowRiver <- function(date, ...){
    url_root <- "http://61.163.88.227:8006/hwsq.aspx?tdsourcetag=s_pctim_aiomsg"
    outfile <- sprintf("yr_%s.csv", date)
    params[[4]] <- date
    r <- POST(url_root, body = params, encode = "form") %>% content()

    tables <- xml_find_all(p, '//table[@width="100%" and @class="mainTxt"]')
    d <- map_dfr(tables, html_table, header = T) %>% data.table()
    d
}
