#/bin/bash

ml purge
ml Nextflow/21.04.0
ml Singularity/3.6.4
ml Graphviz/2.38.0-foss-2016b

export NXF_SINGULARITY_CACHEDIR=/camp/lab/luscomben/home/shared/singularity
REFDIR=/camp/lab/luscomben/home/users/chakraa2/projects/peka/eclip/ref

## UPDATE PIPELINE
nextflow pull amchakra/clipseq -r feat-dedup-bug

## RUN PIPELINE
nextflow run amchakra/clipseq -r feat-dedup-bug \
-profile crick \
--input samplesheet.csv \
--outdir results_clipseq \
--umi_separator _ \
--smrna_org human \
--fasta $REFDIR/GRCh38.primary_assembly.genome.fa.gz \
--gtf $REFDIR/gencode.v30.primary_assembly.annotation.gtf.gz \
--star_index $REFDIR/STAR_GRCh38_primary_gencode_v30