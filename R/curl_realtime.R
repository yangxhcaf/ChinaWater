#' curl_realtime
#' 
#' @inheritParams RETRY2
#' @inheritParams set_cookie
#' @param outdir directory of output files
#' @param timestamp boolean, whether include a timestamp to returned data.frame
#' 
#' @export
curl_realtime <- function(FUN, ..., outdir=".", timestamp = TRUE,
    cookiefile = "cookies.txt", times = 3)
{
    outdir %<>% check_dir()
    res <- RETRY2(FUN, outdir = outdir, timestamp = timestamp, cookiefile = cookiefile, ..., times = times)
    res
}

#' RETRY2
#' 
#' @param FUN function
#' @param times max trying times
#' @param ... others to \code{FUN}
#' 
#' @export
RETRY2 <- function(FUN, ..., times = 3) {
    res <- NULL
    for (i in 1:times) {
        tryCatch({
            res <- FUN(...)
            break
        }, error = function(e) {
            message(sprintf("[e] %sth times | %s", i, e$message))
        })
    }
    res
}
