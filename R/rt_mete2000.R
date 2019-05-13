#' login_cma
#'
#' @param user character
#' @param pwd character
#' @inheritParams RETRY2
#'
#' @export
login_cma <- function(user, pwd, times=3){
    params <- list(
        username = user, # "991810576@qq.com",
        pwd = pwd,
        from = "wa",
        url = sprintf("/app/Rest/userService/%s/%s//userLogin", user, pwd)
    )

    status <- FALSE
    for (i in 1:times) {
        doc <- POST("http://data.cma.cn/wa/?r=rest/index&url", body = params)
        r <- xml_json(doc)
        if (r$code == 200) {
            cat(sprintf("[cma] Login success: welcome back %s\n", r$content$name))
            status <- TRUE
            break()
        } else {
            message(sprintf("[cma] login failed!"))
        }
    }
    return(status)
}

# http://data.cma.cn/dataService/ajax/act/getStationsByProvinceID/dataCode/A.0012.0001.html
# All Variable of A.0012.000
items_mete2000 <- "PRS,PRS_Sea,PRS_Max,PRS_Min,TEM,TEM_Max,TEM_Min,RHU,RHU_Min,VAP,PRE_1h,WIN_D_INST_Max,WIN_S_Max,WIN_D_S_Max,WIN_S_Avg_2mi,WIN_D_Avg_2mi,WEP_Now,WIN_S_Inst_Max,tigan,windpower,VIS,CLO_Cov,CLO_Cov_Low,CLO_COV_LM"

#' rt_mete2000
#'
#' This function only retrieves least 7 days meteorological data.
#'
#' @param date_begin POSIXct obj, or character in the format of "%Y%m%d%H",
#' e.g "2019050518".
#' @param date_end as date_begin
#' @param type "api" or "wap"
#' @param limits If not null, only process limits sites group
#' @inheritParams RETRY2
#' @inheritParams curl_realtime
#'
#' @examples
#' \dontrun{
#' info <- jsonlite::read_json('user_cma.json')
#' login_cma(info$user, info$pwd)
#' d <- rt_mete2000(date_end = "2019050518")
#'}
#'
#' @import foreach iterators
#' @importFrom jsonlite fromJSON
#' @importFrom data.table last
#' @importFrom lubridate ddays
#'
#' @export
rt_mete2000 <- function(
    stations = NULL,
    date_begin = NULL,
    date_end = Sys.time(),
    type = c("wap", "api"),
    outdir = "OUTPUT",
    limits = NULL,
    times = 3, ...)
{
    check_date <- function(x){
        if (is.character(x)) x <- as.POSIXct(x, format = "%Y%m%d%H")
        x
    }

    date_end   %<>% check_date()
    if (is.null(date_begin)) date_begin <- date_end - ddays(7)
    date_begin %<>% check_date()

    outdir <- check_dir(outdir)

    # if returnCode != 0, then throw error
    main <- function(FUN, str_stations, timeRange, ...){
        doc <- FUN(str_stations, timerange, ...)
        l <- xml_json(doc)
        if (l$returnCode != "0") {
            stop(sprintf("[e] mete_hourly| %s", timerange))
            # NULL return
        } else {
            # returned here
            d <- l$DS %>% reorder_name(c("Station_Id_C", "Year", "Mon", "Day", "Hour")) %>% data.table()
            d[d == 999999] <- NA_integer_
            d
        }
    }

    type = type[1]
    if (is.null(stations)) {
        data('st_hourly')
        stations <- st_hourly$StationID
    }

    chunksize <- ifelse(type == "api", 30, 120)
    nchunk  <- ceiling(length(stations)/chunksize)
    lst_stations <- chunk(stations, nchunk)

    # timerange
    # date_end <- Sys.time() - 10
    # date_begin <- date_end - ddays(7)
    timerange  <- c(date_begin, date_end) %>% format("%Y%m%d%H0000") %>%
        { sprintf("[%s,%s]", .[1], .[2]) }
    timerange2 <- simplifyTimeRange(timerange)

    FUN <- switch(type, wap = rt_mete_wap, api = rt_mete_api)

    # MAIN scripts
    ngrp <- length(lst_stations)
    outfiles <- sprintf("%s/mete2000_%s_%02dth(%d).csv", outdir, timerange2, 1:ngrp, ngrp)

    if (is.null(limits)) limits <- ngrp

    res <- foreach(station = lst_stations, outfile = outfiles, i = icount(limits)) %do% {
        runningId(i)
        if (!file.exists(outfile)) {
            str_stations <- paste(station, collapse = ",")
            d <- RETRY2(main, FUN, str_stations, timerange, ..., times = times)
            if (is.data.frame(d) && nrow(d) > 0) fwrite(d, outfile)
            d
        }
    }

    union_mete2000_files(outdir, timerange2)
    do.call(rbind, res)
}

# @param timerange character
simplifyTimeRange <- function(timerange){
    gsub("-00-00|0{4}(?=,|])|-| ", "", timerange, perl = TRUE)
}


#' union_mete2000_files
#'
#' @inheritParams curl_realtime
#' @param timerange e.g. "[2019042818,2019050518]"
#'
#' @examples
#' \dontrun{
#' union_mete2000_files("OUTPUT/", "[2019042818,2019050518]")
#' }
#'
#' @importFrom data.table setkeyv
#' @export
union_mete2000_files <- function(outdir, timerange){
    files <- dir(outdir, pattern = sprintf("\\%s_.*csv$", timerange), full.names = TRUE)
    if (length(files) == 0) {
        warning(sprintf("[e] union_mete2000_files, %s: not file found", timerange))
        return()
    }

    ngrp  <- basename(files[1]) %>% str_extract("(?<=\\()\\d{1,3}(?=\\))") %>% as.numeric()
    n_left <- ngrp - length(files)

    if (n_left == 0) {
        df <- map(files, fread) %>% do.call(rbind, .)
        df[, `:=`(date = sprintf("%04d-%02d-%02d %02d-00-00", Year, Mon, Day, Hour),
                  Year = NULL, Mon = NULL, Day = NULL, Hour = NULL)]
        df %<>% reorder_name(c("date", "Station_Id_C"))
        setkeyv(df, c("date", "Station_Id_C"))

        # rm last 2hour imcomplete
        info <- df[, .N, .(date)]
        date_end  <- info$date %>% last()
        date_last <- info[N >= 2167, date] %>% last()

        df_trim <- df[date <= date_last, ]

        if (nrow(df_trim) < nrow(df)) {
            message(sprintf("[w] date with imcomplete data is removed: (%s, %s]",
                            date_last, date_end))
        }

        timerange2 <- df_trim$date %>% range() %>% simplifyTimeRange() %>%
            {sprintf("[%s,%s]", .[1], .[2])}
        outfile <- sprintf("%s/mete2000_complete_%s.csv", outdir, timerange2)
        fwrite(df_trim, outfile)
        # the last two hour is not complete
        # rm files pices
        file.remove(files)
    } else {
        message(sprintf("[w] not finished! %d files left ...", n_left))
    }
}

rt_mete_api <- function(str_stations, timerange, ...){
    user <- "557640497965fHg3k"
    pwd  <- "0603kvD"
    # 支持最近7天的数据访问，格式为“[YYYYMMDDHHMISS,YYYYMMDDHHMISS]”

    url <- paste0("http://api.data.cma.cn:8090/api?userId=", user, "&pwd=", pwd,
                  "&dataFormat=json&interfaceId=getSurfEleByTimeRangeAndStaID&dataCode=SURF_CHN_MUL_HOR&timeRange=", timerange,
                  "&staIDs=", str_stations, "&elements=Station_Id_C,Year,Mon,Day,Hour,", items_mete2000)
    doc <- GET(url)
    doc
}

rt_mete_wap <- function(str_stations, timerange, ...) {
    params_wap <- list(
        sid                     = "F9A47789-A2E7-4F59-BF90-BBDCB901B370",
        pageNum                 = "1",
        pageSize                = "30000",
        dataCode                = "SURF_CHN_MUL_HOR",
        timeRange               = timerange,
        staIDs                  = str_stations,
        elements                = items_mete2000,
        url                     = "/app/Rest/dataService/search"
    )
    doc <- POST2("http://data.cma.cn/wa/?r=rest/index&url",
        body = params_wap,
        encode = "form",
        add_headers(Referer='http://data.cma.cn/wa/?r=site/materialquery'), ...)
    doc
}

#' get_mete2000_stations
#' It has been saved in \code{data('st_hourly')}.
#' @export
get_mete2000_stations <- function() {
    p <- GET("http://data.cma.cn/Market/Detail/code/A.0012.0001/type/0.html") %>%
        content(encoding = "utf-8")

    prov <- xml_find_all(p, "//div[@class='jmarkImCl1AtItTe']") %>% {
        id <- xml_attr(., "id") %>% as.numeric()
        name <-  xml_text(.)
        data.table(id, name)[id > 10, ]
    }

    get_station <- function(url) {
        l <- GET(url) %>% content(encoding = "utf-8") %>% xml_text() %>% fromJSON()
        cbind(prov = l$cityName, l$stations)
    }

    urls <- sprintf("http://data.cma.cn/dataService/ajax/act/getStationsByProvinceID/dataCode/A.0012.0001.html?provinceID=%s",
                    prov$id)
    res <- llply(urls, get_station, .progress = "text")
    st  <- do.call(rbind, res) %>% data.table
    st
}
