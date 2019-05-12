#' split into nchunks
chunk <- function(x,n) split(x, cut(seq_along(x), n, labels = FALSE))

runningId <- function(i, step = 1, N, prefix = "") {
    perc <- ifelse(missing(N), "", sprintf(", %.1f%% ", i/N*100))
    if (mod(i, step) == 0) cat(sprintf("%srunning%s %d ...\n", prefix, perc, i))    
}

# ------------------------------------------------------------------------------
#' xml_json
#' @param x request object
#'
#' @export
xml_json <- function(x){
    content(x, encoding = "utf-8") %>% xml_text() %>% fromJSON()
}

#' @export
xml_check <- function(x){
    if(class(x)[1] %in% c("xml_document", "xml_node")) x else read_html(x)
}

#' html_inputs
#' @export
html_inputs <- function(p, xpath = "//input"){
    xml_check(p) %>% xml_find_all(xpath) %>% 
    {setNames(as.list(xml_attr(., "value")), xml_attr(., "name"))}
}

#' timestamp
#' 
#' @return time stamp, just like 1498029994455 (length of 13)
#' @export
timestamp <- function() as.character(floor(as.numeric(Sys.time())*1000))

#' @export
save_html <- function(x, file = "kong.html") write_xml(xml_check(x), file)

html_body <- function(p, xpath = "//body") xml_find_all(xml_check(p), xpath)

#' @export
getElementById <- function(p, Id) xml_check(p) %>% xml_find_all(sprintf("//*[@id='%s']", Id))

#' @export
getElementByName <- function(p, Id) xml_check(p) %>% xml_find_all(sprintf("//*[@name='%s']", Id))

listk <- function(...){
  # get variable names from input expressions
  cols <- as.list(substitute(list(...)))[-1]
  vars <- names(cols)
  Id_noname <- if (is.null(vars)) seq_along(cols) else which(vars == "")

  if (length(Id_noname) > 0)
    vars[Id_noname] <- sapply(cols[Id_noname], deparse)
  # ifelse(is.null(vars), Id_noname <- seq_along(cols), Id_noname <- which(vars == ""))
  x <- setNames(list(...), vars)
  return(x)
}

#' @export
cookies2list <- function(cookies){
    strsplit(cookies, ";")[[1]] %>% 
        ldply(function(x) strsplit(x, "=")[[1]]) %>% 
        {set_names(as.list(.[, 2]), .[, 1])}
}

#' convert Raw format string into the real raw format variable
#' @param raw format string
#' @return raw vector
#' @examples 
#' \dontrun{
#' key_p <- "EB2A38568661887FA180BDDB5CABD5F21C7BFD59C090CB2D245A87AC253062882729
#' 293E5506350508E7F9AA3BB77F4333231490F915F6D63C55FE2F08A49B353F444AD3993CACC02D
#' B784ABBB8E42A9B1BBFFFB38BE18D78E87A0E41B9B8F73A928EE0CCEE1F6739884B9777E4FE9E88A
#' 1BBE495927AC4A799B3181D6442443"
#' stringToRaw(key_p)
#' }
#' @export
stringToRaw <- function(str){
  string <- raw()
  for(i in 1:(str_length(str)/2)){
    string[i] <- str_sub(str, (2*i-1), (2*i)) %>% 
      as.hexmode() %>% unlist %>% as.raw()
  }
  return(string)
}
