test_that("realtime works", {
    fun <- function(...) {1}
    fun2 <- function(...) { stop("stop here")}

    res <- realtime(fun)
    r1  <- realtime(fun)
    r2 <- realtime(fun2)

    expect_equal(res, r1)
    expect_null(r2)
})
