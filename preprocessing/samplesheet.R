
library(data.table)

setwd("/camp/lab/luscomben/home/users/chakraa2/projects/peka/eclip")

fastq.path <- "/camp/lab/luscomben/home/users/chakraa2/projects/peka/eclip/results/umi_moved"
dt <- data.table(fastq = list.files(pattern = ".fastq.gz$", path = fastq.path, full.names = TRUE))
dt[, sample := tstrsplit(basename(fastq), "\\.")[1]]
setcolorder(dt, c("sample", "fastq"))
fwrite(dt, "samplesheet.csv")

missing <- c("HepG2-RBM5_mock-1", 
"HepG2-TROVE2_mock-1", 
"K562-GEMIN5_mock-1", 
"K562-HLTF_mock-1", 
"K562-RPS3_mock-1", 
"K562-RPS3-1", 
"K562-SSB-1", 
"K562-SSB-2", 
"K562-TROVE2-2")

sel.dt <- dt[!sample %in% missing]
fwrite(sel.dt , "sel.samplesheet.csv")