source('test/main_pkgs.R')
library(Rcmip5)

# Just for hunan
dates <- seq(ymd("1991-01-01"), ymd("2019-04-25"), by = "day") #%>% format()
n     <- length(dates)
dates <- {dates + dhours(rep(15:23, each = n))} %>% set_names(format_POSIXt(.))
date  <- dates[1]

files <- dir(outdir, "*.csv", full.names = TRUE)
dates_finished <- files %>% basename() %>% gsub("hunan_|.csv", "", .) %>% as.POSIXct(format = "%Y-%m-%d_%H%M") %>% unique()
# info_match <- match2(dates, dates_finished)
# dates_left <- dates[-info_match$I_x]

save(dates_left, file = "dates_left.rda")
# main script -------------------------------------------------------------

killCluster()
ncluster <- 6
InitCluster(ncluster)

l_ply(1:ncluster, function(i){
    suppressMessages({
        library(magrittr)
        library(httr)
        library(xml2)
        library(lubridate)
    })
}, .parallel = TRUE)

outdir <- "../OUTPUT/flow_hunan/"
l_ply(dates, curl_history, outdir = outdir, prefix = "hunan",
    FUN = his_HuNan,
    # .progress = "text",
    .parallel = TRUE)

# hunan -------------------------------------------------------------------
s2_post_process = FALSE
if (s2_post_process){
    pattern <- "00.csv"
    files1 <- dir("../OUTPUT/flow_hunan/", pattern, full.names = TRUE)
    files2 <- dir("../OUTPUT/finished/", pattern, full.names = TRUE)
    files <- c(files1, files2) %>% sort()

    hour <- files %>% basename() %>% str_extract("\\d{4}(?=\\.|_1)")
    info <- table(hour) %>% as.data.frame() %>% data.table()

    # I_move <- {{as.numeric(hour)/100} %in% 14} %>% which
    # file.rename(files[I_move], files[I_move] %>% basename() %>% paste0("../OUTPUT/finished/", .))
    #
    # names <- files %>% basename() %>% gsub("hunan_|hubei|.csv", "", .)

    info_station <- fread(files[1])
    # InitCluster(4)
    df_station <- ldply(files, data.table::fread, select = c(1, 4:6, 9, 10),
                 # .parallel = TRUE,
                 .progress = "text")
    fwrite(df_station, "rflow_hourly_湖南_1992-2019.csv")
    fwrite(info_station, "rflow_station_湖南_1992-2019.csv")

    # 水库 ---------------------------------------------------------------------
    pattern <- "00_1.csv"
    files1 <- dir("../OUTPUT/flow_hunan/", pattern, full.names = TRUE)
    files2 <- dir("../OUTPUT/finished/", pattern, full.names = TRUE)
    files <- c(files1, files2) %>% sort()

    hour <- files %>% basename() %>% str_extract("\\d{4}(?=\\.|_1)")
    info <- table(hour) %>% as.data.frame() %>% data.table()

    # I_move <- {{as.numeric(hour)/100} %in% 14} %>% which
    # file.rename(files[I_move], files[I_move] %>% basename() %>% paste0("../OUTPUT/finished/", .))
    #
    # names <- files %>% basename() %>% gsub("hunan_|hubei|.csv", "", .)

    info_station <- fread(files[1])
    # InitCluster(4)
    df_station <- ldply(files, data.table::fread,
                        select = c(1, 4, 5, 6, 8, 9, 10, 11, 12),
                        # .parallel = TRUE,
                        .progress = "text")
    fwrite(df_station, "rflow_hourly_湖南（水库）_1992-2019.csv")
    fwrite(info_station, "rflow_station_湖南（水库）_1992-2019.csv")
}
