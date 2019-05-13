# Dongdong Kong, 20190513
library(ChinaWater)
library(lubridate)


## PARAMETERS --------------------------------------------------------------
# see \code{task_create} for details
workdir  <- "./task"
modifier <- 1
schedule <- "HOURLY"
# schedule <- "ONCE"

starttime <- "06:30"
schtasks_extra <- '/RU "kongdd" /RP "genie156&"'



## 1. Guangxi hourly monitoring -----------------------------------------------
rtask_rt_GuangXi <- quote({
    cat(sprintf('rt_GuangXi | %s', Sys.time()), sep = "\n")

    outdir <- "OUTPUT/GuangXi"
    res <- curl_realtime(FUN = rt_GuangXi, outdir = outdir)
    cat("\n")
})

taskname <- "rtask_rt_GuangXi"
task_create(rtask_rt_GuangXi, taskname, workdir,
            schedule = schedule, starttime = starttime,
            modifier = modifier,
            schtasks_extra = schtasks_extra)

## 2. ChinaWater --------------------------------------------------------------
rtask_rt_ChinaWater <- quote({
    cat(sprintf('rt_ChinaWater | %s', Sys.time()), sep = "\n")

    verb <- NULL
    outdir  <- "OUTPUT/ChinaWater"
    # d_rain  <- curl_realtime(rt_ChinaWater, type='rain', outdir = outdir, verb)
    d_river <- curl_realtime(rt_ChinaWater, type='river', outdir = outdir, verb)
    d_sk <- curl_realtime(rt_ChinaWater, type='reservoir', outdir = outdir, verb)

    cat("\n")
})

taskname <- "rtask_rt_ChinaWater"
task_create(rtask_rt_ChinaWater, taskname, workdir,
            schedule = schedule, starttime = starttime,
            modifier = modifier,
            schtasks_extra = schtasks_extra)

## 3. mete2000 --------------------------------------------------------------
rtask_rt_mete2000 <- quote({
    print(Sys.time())

    # check working dir
    info <- jsonlite::read_json('../user_cma.json')
    login_cma(info$user, info$pwd)
    d <- rt_mete2000(
        date_begin = Sys.time() - ddays(4),
        date_end = Sys.time() - ddays(1),
        outdir = "OUTPUT/mete2000")
    cat("\n")
})

taskname <- "rtask_rt_mete2000"
task_create(rtask_rt_mete2000, taskname, workdir,
            schedule = "DAILY", starttime = starttime,
            modifier = 2,
            schtasks_extra = schtasks_extra)
# task_stop(taskname)
# task_delete(taskname)
