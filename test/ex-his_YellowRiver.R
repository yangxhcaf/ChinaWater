source('test/main_pkgs.R')

#' parameters of POST template
get_params <- function(){
    url_root <- "http://61.163.88.227:8006/hwsq.aspx?tdsourcetag=s_pctim_aiomsg"
    p <- GET(url_root) %>% content(encoding = "utf-8")
    params <- html_inputs(p, "//input")    
}

# MAIN scripts ------------------------------------------------------------
date <- ymd("2019-03-03")
dates <- seq(ymd("2001-01-01"), ymd("2019-03-05"), by = "day") %>% format()

d <- his_yellowRiver(date)
l_ply(dates, curl_history, outdir = "hunan", prefix = "hunan", 
    FUN = his_yellowRiver)
    # .progress = "text", 
    # .parallel = TRUE)

## debug procedure
# param <- list(
#     "ctl00$ScriptManager1" = "ctl00$ScriptManager1|ctl00$ContentLeft$Button1",
#     "ctl00$ContentLeft$menuDate1$TextBox11" = format(date)
# )
# write_xml(r, "a.html")
# file.show("a.html")
