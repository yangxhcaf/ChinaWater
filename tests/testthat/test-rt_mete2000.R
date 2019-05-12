test_that("multiplication works", {
    skip_if_not(file.exists(file_cma))

    info <- jsonlite::read_json(file_cma)
    status <- login_cma(info$user, info$pwd)

    #
    d <- rt_mete2000(date_end = Sys.time(), limits = 1)
    expect_true(nrow(d) > 0)
})
