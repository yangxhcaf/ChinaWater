context("test-curl_main")

test_that("curl_main works", {
    expect_silent({
        date <- as.POSIXct("2016-04-10 12:00:00")
        curl_main(date, FUN = curl_hunan)
        status <- file.remove(dir('tests/testthat/', "*.csv", full.names = TRUE))
    })
})
