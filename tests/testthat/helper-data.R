library(httr)
library(magrittr)

on.error <- function(e) {
    message(sprintf('[e] %s', e$message))
    400
}

verb <- verbose()
verb <- NULL 

## If can't access in appveyor or travis, then skip it
# rtChinaWater
req <- tryCatch(GET("http://xxfb.hydroinfo.gov.cn/ssIndex.html", verb)$status_code, 
    error = on.error)

is_test_rtChinaWater <- ifelse(req != 200, FALSE, TRUE)
if (is_test_rtChinaWater) {
    cat(sprintf('[ok] access ChinaWater[xxfb.hydroinfo.gov.cn] successfully.\n'))
} else {
    cat(sprintf('[e] failed to access ChinaWater[xxfb.hydroinfo.gov.cn]!\n'))
}

# rtGuangXi
req <- tryCatch(GET("http://slt.gxzf.gov.cn:9000/gxsl/japi/api/sl323/realtime/river", 
    add_headers(Referer = "http://slt.gxzf.gov.cn:9000/page/index.html?act=3"), verb)$status_code, 
    error = on.error)
is_test_rtGuangXi <- ifelse(req != 200, FALSE, TRUE)

if (is_test_rtGuangXi) {
    cat(sprintf('[ok] access GuangXi[slt.gxzf.gov.cn:9000] successfully.\n'))
} else {
    cat(sprintf('[e] failed to access GuangXi[slt.gxzf.gov.cn:9000]!\n'))
}

# cma
file_cma <- "../../user_cma.json"
is_test_cma <- file.exists(file_cma)
