#' @export
realtime <- function(FUN, ..., outdir=".", timestamp = TRUE,
    cookiefile = "cookies.txt", times = 3)
{
    res <- RETRY(FUN, outdir = outdir, timestamp = timestamp, cookiefile = cookiefile, ..., times = times)
    res
}

#' RETRY
#' @param FUN function
#' @param times max trying times
#' 
#' @export
RETRY <- function(FUN, ..., times = 3) {
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
