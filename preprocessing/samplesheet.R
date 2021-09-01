
library(data.table)

setwd("/camp/lab/luscomben/home/users/chakraa2/projects/peka/eclip")

fastq.path <- "/camp/lab/luscomben/home/users/chakraa2/projects/peka/eclip/results/umi_moved"
dt <- data.table(fastq = list.files(pattern = ".fastq.gz$", path = fastq.path, full.names = TRUE))
dt[, sample := tstrsplit(basename(fastq), "\\.")[1]]
setcolorder(dt, c("sample", "fastq"))
fwrite(dt, "samplesheet.csv")