#' once cookie exist, it's impossible to update by set_cookie
#' 
#' set_config() works globaly, but will not return cookie to reponse object.
#' Reversely, set_cookies() works locally, and return cookie to response object.
#' @export
set_cookie <- function(cookiefile = "cookies.txt"){
    if (file.exists(cookiefile)) {
        d <- fread(cookiefile)
        cookies <- set_names(d$value, d$name)
        config <- set_cookies(cookies)
        # set_config(config, override = TRUE)
        config
    } else {
        message("cookiefile not exist ... ")
        NULL
    }
}

#' @rdname set_cookie
#' 
#' @export
write_cookie <- function(cookies, cookiefile = "cookies.txt"){
    if (nrow(cookies) > 0) {
        fwrite(cookies, cookiefile)
    }
}

#' request url with cookiefile
#' 
#' @param ... other parameters will be passed to [GET()] or [POST()]
#' @export
GET2 <- function(..., cookiefile = "cookies.txt") {
    p <- GET(..., set_cookie(cookiefile))
    write_cookie(p$cookies, cookiefile)
    p
}

#' @rdname GET2
#' @export
POST2 <- function(..., cookiefile = "cookies.txt") {
    p <- POST(..., set_cookie(cookiefile))
    write_cookie(p$cookies, cookiefile)
    p
}

query_cookiefile <- function(...){
    p <- GET2("http://httpbin.org/cookies", ...)
    print(p)
    print(p$cookies)
}
