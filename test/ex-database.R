{
    library(RSQLite)
    filename <- "F:/test_01.db"
    sqlite.driver <- dbDriver("SQLite")
    db <- dbConnect(sqlite.driver,
                    dbname = filename)
    ## Some operations
    dbListTables(db)
    df <- dbReadTable(db,"water_flow") %>% data.table()
    df[, `:=`(date = as_datetime(date))]
}
