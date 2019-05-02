source('test/main_pkgs.R')

# Just for hunan
dates <- seq(ymd("1991-01-01"), ymd("2019-04-25"), by = "day") #%>% format()
n     <- length(dates)
dates <- {dates + dhours(rep(0:23, each = n))} %>% set_names(format_POSIXt(.))
date  <- dates[1]

ncluster <- 4
InitCluster(ncluster)

l_ply(1:ncluster, function(i){
    suppressMessages({
        library(magrittr)
        library(httr)
        library(xml2)
        library(lubridate)
    })
}, .parallel = TRUE)

l_ply(dates, curl_main, outdir = "../OUTPUT/flow_hunan/", prefix = "hunan",
    FUN = curl_hunan,
    # .progress = "text",
    .parallel = TRUE)


# hunan -------------------------------------------------------------------
files <- dir("hunan", "*.csv", full.names = TRUE)
names <- files %>% basename() %>% gsub("hunan_|hubei|.csv", "", .)

info <- fread(files[1])

lst <- llply(files, function(file){
    d <- fread(file)
    d[, 2:6]
}, .progress = "text")
names(lst) <- names

df <- melt_list(lst, "date")
df2 <- df[, .(name = STNM, date, Z, Q)]
df[!is.na(`流量`), ]

fwrite(df, "rflow_hourly_湖南_1992-2019.csv")
fwrite(info, "rflow_station_湖南_1992-2019.csv")

