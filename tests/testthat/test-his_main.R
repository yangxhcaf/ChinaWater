context("test-history")

test_that("history works", {
    expect_silent({
        date <- as.POSIXct("2016-04-10 12:00:00")
        history(date, FUN = his_hunan)
        status <- file.remove(dir('tests/testthat/', "*.csv", full.names = TRUE))
    })
})
