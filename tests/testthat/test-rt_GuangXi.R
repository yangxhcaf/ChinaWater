test_that("rt_GuangXi works", {
    expect_true({
        res <- realtime(FUN = rt_GuangXi, outdir = ".")
        nrow(res) > 100
    })
})
