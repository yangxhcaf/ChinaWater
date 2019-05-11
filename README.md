
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ChinaWater

<!-- badges: start -->
[![Travis build status](https://travis-ci.org/kongdd/ChinaWater.svg?branch=master)](https://travis-ci.org/kongdd/ChinaWater)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/kongdd/ChinaWater?branch=master&svg=true)](https://ci.appveyor.com/project/kongdd/ChinaWater)
[![Codecov test coverage](https://codecov.io/gh/kongdd/ChinaWater/branch/master/graph/badge.svg)](https://codecov.io/gh/kongdd/ChinaWater?branch=master)
[![License](http://img.shields.io/badge/license-GPL%20%28%3E=%203%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-3.0.html)
<!-- badges: end -->

Crawl China flow data.

## Installation

You can install the released version of ChinaWater from gitlab with:

``` r
devtools::install_gitlab("kongdd/ChinaWater")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(ChinaWater)
## basic example code
date <- as.POSIXct("2016-04-10 12:00:00")
curl_main(date, FUN = curl_hunan)
```

**Table 1.** 中国水位流量数据

| status | 省份 | url                                                | 水位 | 流量 |
| :----: | ---- | -------------------------------------------------- | :--: | :--: |
|   √    | 全国 | http://xxfb.hydroinfo.gov.cn/ssIndex.html          |  √   |  √   |
|   ×    | 广西 | http://slt.gxzf.gov.cn:9000/page/index.html?act=3  |      |      |
|   ×    | 广东 | http://www.gdwater.gov.cn:9001/Map/Map.aspx?id=    |  √   |      |
|   √    | 湖北 | http://113.57.190.228:8001/Web/Report/GetRiverData |  √   |  √   |
|   √    | 湖南 | http://61.187.56.156/wap/hnsq_BB2.asp              |  √   |  √   |


# Acknowledgements

Keep in mind that this repository is released under a GPL-3 license,
which permits commercial use but requires that the source code (of
derivatives) is always open even if hosted as a web service.
