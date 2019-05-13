test_that("task_create works", {
    skip_on_travis()
    skip_on_cran()

    rscript <- quote({
        print(Sys.time())
        print(getwd())
        print("hello world")
    })

    taskname <- "R_task"
    workdir  <- "~"

    expect_true({
        task_create(rscript, taskname, workdir, schedule = "ONCE", debug = FALSE)
        TRUE
    })
    expect_silent(task_stop("R_task"))
    expect_silent(task_delete("R_task"))
})
