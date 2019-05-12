test_that("rt_GuangXi works", {
    expect_true({
        skip_if_not(is_test_rtGuangXi)
        skip_on_appveyor()
        skip_on_travis()

        res <- realtime(FUN = rt_GuangXi, outdir = ".")
        nrow(res) > 100
    })
})
