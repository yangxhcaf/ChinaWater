
<!-- README.md is generated from README.Rmd. Please edit that file -->

# RcurlFlow

<!-- badges: start -->

<!-- badges: end -->

Crawl China flow data.

## Installation

You can install the released version of RcurlFlow from gitlab with:

``` r
devtools::install_gitlab("rcurl/rcurlflow")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(RcurlFlow)
## basic example code
date <- as.POSIXct("2016-04-10 12:00:00")
curl_main(date, FUN = curl_hunan)
```
