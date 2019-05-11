# source('test/main_pkgs.R')
library(RcurlFlow)

outdir <- "D:/schedule/chinawater/"
setwd(dirname(outdir))

# sink('log_chinawater.txt')
# ------------------------------------------------------------------------------
print(Sys.time())
d_sk    <- china_water('reservoir', outdir)
d_river <- china_water('river', outdir)
d_rain  <- china_water('rain', outdir)

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
