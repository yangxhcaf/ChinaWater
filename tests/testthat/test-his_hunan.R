context("test-his_hunan")

test_that("his_hunan works", {
    expect_equal(2 * 2, 4)
    date <- as.POSIXct("2016-04-10 12:00:00")
    d_hnsq <- his_hunan_type(date, "hnsq")
    d_dxsk <- his_hunan_type(date, "dxsk")

    status <- file.remove(dir("*.csv"))
    ## check data in web page
    # 1. dxsk
    expect_equal(nrow(d_dxsk), 25)
    expect_equal(d_dxsk[1, 6][[1]], 251.2) # 库水位

    # 2. stations
    expect_equal(nrow(d_hnsq), 228)
    expect_equal(d_hnsq[1, 6][[1]], 66.08) # 水位
})
