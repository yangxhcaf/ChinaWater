taskscheduler_create(taskname = "chinawater",
                     rscript = "test/ex-china.R",
                     schedule = "MINUTE",
                     # modifier = 5,
                     starttime = format(Sys.time() + 2, "%H:%M"),
                     startdate = format(Sys.Date(), "%Y/%m/%d"),
                     rscript_args = "--vanilla")
taskscheduler_delete("chinawater")

# myscript <- system.file("extdata", "helloworld.R", package = "taskscheduleR")
# taskscheduler_create(taskname = "myfancyscript", rscript = myscript, schedule = "ONCE",
#                      starttime = format(Sys.time() + 62, "%H:%M"))
#
