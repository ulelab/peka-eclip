
conda activate nf-core-clipseq-1.0

cd /camp/lab/luscomben/home/users/chakraa2/projects/peka/eclip

INDEX=/camp/lab/luscomben/home/shared/projects/ira-nobby/comp_hiclip/results_nonhybrid/work/ef/bd50b9087b1aa343f264d7373cfd06/STAR_GRCh38.primary_assembly.genome

STAR --outFilterMultimapNmax 1 \
    --outFilterMultimapScoreRange 1 \
    --outSAMattributes All \
    --alignSJoverhangMin 8 \
    --alignSJDBoverhangMin 1 \
    --outFilterType BySJout \
    --alignIntronMin 20 \
    --alignIntronMax 1000000 \
    --outFilterScoreMin 10  \
    --alignEndsType EndToEnd \
    --twopassMode Basic \
    --outSAMtype BAM SortedByCoordinate \
    --runThreadN 8 \
    --genomeDir $INDEX \
    --runMode alignReads \
    --readFilesIn data/HepG2-RBFOX2-1.1.fastq.gz  data/HepG2-RBFOX2-1.2.fastq.gz \
    --readFilesCommand gunzip -c \
    --outFileNamePrefix PE_HepG2-RBFOX2-1. 

STAR --outFilterMultimapNmax 1 \
    --outFilterMultimapScoreRange 1 \
    --outSAMattributes All \
    --alignSJoverhangMin 8 \
    --alignSJDBoverhangMin 1 \
    --outFilterType BySJout \
    --alignIntronMin 20 \
    --alignIntronMax 1000000 \
    --outFilterScoreMin 10  \
    --alignEndsType Extend5pOfReads12 \
    --twopassMode Basic \
    --outSAMtype BAM SortedByCoordinate \
    --runThreadN 8 \
    --genomeDir $INDEX \
    --runMode alignReads \
    --readFilesIn data/HepG2-RBFOX2-1.1.fastq.gz  data/HepG2-RBFOX2-1.2.fastq.gz \
    --readFilesCommand gunzip -c \
    --outFileNamePrefix 5p_PE_HepG2-RBFOX2-1. 

STAR --outFilterMultimapNmax 1 \
    --outFilterMultimapScoreRange 1 \
    --outSAMattributes All \
    --alignSJoverhangMin 8 \
    --alignSJDBoverhangMin 1 \
    --outFilterType BySJout \
    --alignIntronMin 20 \
    --alignIntronMax 1000000 \
    --outFilterScoreMin 10  \
    --alignEndsType Extend5pOfRead1 \
    --twopassMode Basic \
    --outSAMtype BAM SortedByCoordinate \
    --runThreadN 8 \
    --genomeDir $INDEX \
    --runMode alignReads \
    --readFilesIn data/HepG2-RBFOX2-1.2.fastq.gz \
    --readFilesCommand gunzip -c \
    --outFileNamePrefix SE_HepG2-RBFOX2-1. 