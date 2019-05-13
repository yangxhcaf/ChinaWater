test_that("curl_realtime works", {
    fun <- function(...) {1}
    fun2 <- function(...) { stop("stop here")}

    res <- curl_realtime(fun)
    r1  <- curl_realtime(fun)
    r2 <- curl_realtime(fun2)

    expect_equal(res, r1)
    expect_null(r2)
})
