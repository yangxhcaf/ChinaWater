test_that("task_ls works", {

    df <- task_ls()
    d1 <- task_ls("google", wildcard  = FALSE)
    d2 <- task_ls("google", wildcard  = TRUE)
    expect_is(d1, "data.frame")
})
