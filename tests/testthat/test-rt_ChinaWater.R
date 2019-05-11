verb <- NULL # verbose()
test_that("china_water reservoir works", {
    expect_true({
        d_sk <- realtime(rt_ChinaWater, type='reservoir', verb)
        nrow(d_sk) > 0
    }, "reservoir")
})

test_that("china_water river works", {
    expect_true({
        d_river <- realtime(rt_ChinaWater, type='river', verb)
        nrow(d_river) > 0
    }, "river")
})

test_that("china_water rain works", {
    expect_true({
        d_rain  <-  realtime(rt_ChinaWater, type='rain', verb)
        nrow(d_rain) > 0
    }, "rain")
})
