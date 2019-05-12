#' @export
realtime <- function(FUN, ..., outdir=".", timestamp = TRUE, 
    cookiefile = "cookies.txt", times = 3) 
{
    res <- RETRY(FUN, outdir = outdir, timestamp = timestamp, cookiefile = cookiefile, ..., times)
    res
}

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
