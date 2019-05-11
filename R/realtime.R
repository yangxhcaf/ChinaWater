#' @export
realtime <- function(FUN, ..., outdir=".", timestamp = TRUE, 
    cookiefile = "cookies.txt", times = 3) 
{
    res <- NULL
    for (i in 1:times) {
        tryCatch({
            res <- FUN(outdir = outdir, timestamp = timestamp, cookiefile = cookiefile, ...)
            break
        }, error = function(e) {
            message(sprintf("[e] %sth times | %s", i, e$message))
        })
    }
    res
}
