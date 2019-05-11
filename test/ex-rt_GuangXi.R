library(ChinaWater)

outdir <- "D:/schedule/ChinaWater/GuangXi"
setwd2(outdir)

cat(sprintf('rt_GuangXi | %s', Sys.time()), sep = "\n")
res <- realtime(FUN = rt_GuangXi, outdir = outdir)
