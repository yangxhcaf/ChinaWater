source('test/main_pkgs.R')

# Just for human
dates <- seq(ymd("1946-01-01"), ymd("2019-04-25"), by = "day") #%>% format()
n     <- length(dates)
hours <- (0:23)
dates <- {dates + dhours(rep(hours, each = n))} %>% set_names(format_POSIXt(.))
date  <- dates[1]

InitCluster(6)

temp <- l_ply(1:6, function(i){
    suppressMessages({
        library(magrittr)
        library(httr)
        library(xml2)
        library(lubridate)
        library(purrr)
        library(data.table)
    })
}, .parallel = TRUE)

l_ply(dates, curl_history, outdir = "hubei", prefix = "hubei",
      FUN = his_HuBei,
      .parallel = TRUE)

# download(dates[1:4], outdir = "hubei", prefix = "hubei", FUN = his_HuBei)

files <- dir("hubei", "*.csv", full.names = TRUE)

lst <- llply(files[1:100], fread, .progress = "text")
# params <- html_inputs(p, "//input")

save(lst, file = "flow_hubei (1946-2019).rda")

df <- melt_list(lst, "date")
df[!is.na(`流量`), ]
df[, `:=`(year = substr(date, 1, 4) %>% as.numeric(),
          month = substr(date, 6, 7)  %>% as.numeric(),
          day = substr(date, 9, 10)  %>% as.numeric(),
          hour = substr(date, 12, 13) %>% as.numeric())]
# df2 <- df[, .(name = STNM, date, Z, Q)] %>%
#     mutate(date = as.POSIXct(date, format = "%Y-%m-%d_%H%M"),
#            year = year(date),
#            month = month(date),
#            day = day(date),
#            hour = hour(date)) %>%
#     reorder_name(.(name, date, year, month, day, hour) %>% names()) %>%
#     .[, -2]

fwrite(df[, .(name, year, month, day, hour, Z, Q)], "rflow_hourly_湖北_1946-2019.csv")
# df <- fread("rflow_hourly_湖北_1946-2019.csv")
