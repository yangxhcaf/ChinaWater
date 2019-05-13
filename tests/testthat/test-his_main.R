context("test-curl_history")

test_that("curl_history works", {
    expect_silent({
        date <- as.POSIXct("2016-04-10 12:00:00")
        curl_history(date, FUN = his_HuNan)
        status <- file.remove(dir('tests/testthat/', "*.csv", full.names = TRUE))
    })
})
