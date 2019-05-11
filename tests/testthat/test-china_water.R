test_that("china_water reservoir works", {
    expect_true({
        d_sk    <- china_water('reservoir')
        TRUE
    }, "reservoir")
})

test_that("china_water river works", {
    expect_true({
        d_river <- china_water('river')
        TRUE
    }, "river")
})

test_that("china_water rain works", {
    expect_true({
        d_rain  <- china_water('rain')
        TRUE
    }, "rain")
})
