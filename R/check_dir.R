#' @export
check_dir <- function(path) {
    if (!dir.exists(path)) {
        dir.create(path, recursive = TRUE)
    }
    path
}
