# Script to download and rename ENCODE fastq on CAMP
# A. M. Chakrabarti
# Last updated 26th October 2018, 1st September 2021

# sbatch -N 1 --array 1-1374%100 -t 24:00:00 -J eclip -o logs/%A_%a.log --wrap="Rscript --vanilla download.R"
# sbatch -N 1 --array 1-24 -J eclip -o %A_%a.log --wrap="Rscript --vanilla download.R"

# Get array id
i <- as.numeric(Sys.getenv("SLURM_ARRAY_TASK_ID"))

library(data.table)

metadata.dt <- fread("metadata.tsv")
metadata.dt[, output := paste0(`Biosample term name`, "-",
                               gsub(" eCLIP mock input", "_mock", sapply(strsplit(`Experiment target`, "\\-"), "[[", 1)), "-",
                               `Biological replicate(s)`, ".",
                               `Paired end`, ".fastq.gz")]

# NB K562 mock NONO has an extra space in the Experiment target
metadata.dt[output == "K562-NONO _mock-1.1.fastq.gz", output := "K562-NONO_mock-1.1.fastq.gz"]
metadata.dt[output == "K562-NONO _mock-1.2.fastq.gz", output := "K562-NONO_mock-1.2.fastq.gz"]

download.file(metadata.dt$`File download URL`[i], destfile = file.path("data", metadata.dt$output[i]), method = "wget", quiet = FALSE)

# # NB 3 have more than 2 fastq to sample, so get overwritten
# metadata.dt[, fastq_count := .N, by = .(`Biosample term name`, `Experiment target`, `Biological replicate(s)`)]
# many.dt <- metadata.dt[fastq_count > 2]
# lapply(1:nrow(many.dt), function(i) download.file(many.dt$`File download URL`[i], destfile = basename(many.dt$`File download URL`[i]), method = "wget"))


# many.list <- split(many.dt[, .(`File download URL`, output)], many.dt$output)

# lapply(seq_along(many.list), function(i) {
  
#   cmd <- paste0("zcat ", paste0(basename(many.list[[i]]$`File download URL`), collapse = " "), " | pigz > ", paste0("temp_", names(many.list)[i]))
#   print(cmd)
#   system(cmd)
  
# })

# system("repair.sh -Xmx20g ain=t in=temp_HepG2-EXOSC5-2.1.fastq.gz in2=temp_HepG2-EXOSC5-2.2.fastq.gz out=HepG2-EXOSC5-2.1.fastq.gz out2=HepG2-EXOSC5-2.2.fastq.gz")
# system("repair.sh -Xmx20g ain=t in=temp_HepG2-FTO-1.1.fastq.gz in2=temp_HepG2-FTO-1.2.fastq.gz out=HepG2-FTO-1.1.fastq.gz out2=HepG2-FTO-1.2.fastq.gz")
# system("repair.sh -Xmx20g ain=t in=temp_K562-APOBEC3C-1.1.fastq.gz in2=temp_K562-APOBEC3C-1.2.fastq.gz out=K562-APOBEC3C-1.1.fastq.gz out2=K562-APOBEC3C-1.2.fastq.gz")
