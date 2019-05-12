test_that("login_cma works", {
    skip_if_not(file.exists(file_cma))

    info <- jsonlite::read_json(file_cma)
    status <- login_cma(info$user, info$pwd)

    expect_true(status)
})
