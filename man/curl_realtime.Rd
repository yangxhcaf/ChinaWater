% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/curl_realtime.R
\name{curl_realtime}
\alias{curl_realtime}
\title{curl_realtime}
\usage{
curl_realtime(FUN, ..., outdir = ".", timestamp = TRUE,
  cookiefile = "cookies.txt", times = 3)
}
\arguments{
\item{FUN}{function}

\item{...}{others to \code{FUN}}

\item{outdir}{directory of output files}

\item{timestamp}{boolean, whether include a timestamp to returned data.frame}

\item{cookiefile}{path of cookie file

set_config() works globaly, but will not return cookie to reponse object.
Reversely, set_cookies() works locally, and return cookie to response object.}

\item{times}{max trying times}
}
\description{
curl_realtime
}
