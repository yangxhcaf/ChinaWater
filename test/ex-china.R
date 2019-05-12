# source('test/main_pkgs.R')
library(ChinaWater)

outdir <- "D:/schedule/chinawater/"
setwd(dirname(outdir))

# sink('log_chinawater.txt')
# ------------------------------------------------------------------------------
print(Sys.time())
d_sk    <- china_water('reservoir', outdir)
d_river <- china_water('river', outdir)
d_rain  <- china_water('rain', outdir)

#
st <- readxl::read_excel("data/China_SURF_Station.xlsx", skip = 0)
meteItems_houly <- readxl::read_excel("data/China_SURF_Element.xlsx", skip = 0)[-(1:5), 2:4] %>%
    set_colnames(c("name", "longname", "unit")) %>% data.table()

{
    p <- GET("http://data.cma.cn/data/search.html?dataCode=A.0012.0001",
             body = params,
             encode = "form",
             add_headers(
                 Referer = "http://data.cma.cn/dataService/cdcindex/datacode/A.0012.0001/show_value/normal.html",
                 Cookie = "PHPSESSID=lr0fsnspbrh7vgq01l3hc54og3; login_id_chat=0; surveyCookie=0; userLoginKey=84f193d3ad6ade9866a37109d1724008; trueName=%E5%AD%94%E5%86%AC%E5%86%AC; userName=286860344AA42E51BC60D0912620B73F; "),
             verbose()) %>% content()
    xml_text(p) %>% print()
    write_xml(p, "a.html")
    }

stations <- st[IsOpenApi == 1, StationID] %>% chunk(73)

lst <- foreach(station = stations, i = icount()) %do% {
    runningId(i)
    d <- realtime(rt_mete_hourly, station, outdir=".", timestamp = TRUE,
                  cookiefile = "cookies.txt", times = 3)
}

# {
#     library(RSQLite)
#     filename <- "F:/test_01.db"
#     sqlite.driver <- dbDriver("SQLite")
#     db <- dbConnect(sqlite.driver,
#                     dbname = filename)
#     ## Some operations
#     dbListTables(db)
#     df <- dbReadTable(db,"water_flow") %>% data.table()
#     df[, `:=`(date = as_datetime(date))]
# }


