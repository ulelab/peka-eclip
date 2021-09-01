for i in *.2.fastq.gz; do  RBC=`zcat $i | head -1 | cut -d ':' -f 1`; printf "%s\t%s\n" ${i%%.*} $RBC >> ../rbc.tsv; done

awk '$2 !~ /@N|@A|@G|@C|@T/' rbc.tsv

# HepG2-EXOSC5-2	@K00180 https://www.encodeproject.org/files/ENCFF405ERW/@@download/ENCFF405ERW.bam
# HepG2-FTO-1	@K00180 https://www.encodeproject.org/files/ENCFF385LTB/@@download/ENCFF385LTB.bam
# 10 HepG2-STAU2-1	@K00180 https://www.encodeproject.org/files/ENCFF559ATC/@@download/ENCFF559ATC.bam
# HepG2-STAU2-2	@K00180 https://www.encodeproject.org/files/ENCFF202ITE/@@download/ENCFF202ITE.bam
# K562-APOBEC3C-1	@K00180 https://www.encodeproject.org/files/ENCFF943EZJ/@@download/ENCFF943EZJ.bam
# K562-APOBEC3C-2	@HWI-D00611 https://www.encodeproject.org/files/ENCFF284TAX/@@download/ENCFF284TAX.bam

# UMIs are all 10 nt long (?inc experimental barcode) and at the beginning of read 2
sbatch -N 1 --mem=32G -t 12:00:00 --wrap="umi_tools extract --bc-pattern NNNNNNNNNN -I HepG2-EXOSC5-2.2.fastq.gz --read2-in=HepG2-EXOSC5-2.1.fastq.gz -S ../HepG2-EXOSC5-2.2.fastq.gz --read2-out=../HepG2-EXOSC5-2.1.fastq.gz"
sbatch -N 1 --mem=32G -t 12:00:00 --wrap="umi_tools extract --bc-pattern NNNNNNNNNN -I HepG2-FTO-1.2.fastq.gz --read2-in=HepG2-FTO-1.1.fastq.gz -S ../HepG2-FTO-1.2.fastq.gz --read2-out=../HepG2-FTO-1.1.fastq.gz"
sbatch -N 1 --mem=32G -t 12:00:00 --wrap="umi_tools extract --bc-pattern NNNNNNNNNN -I HepG2-STAU2-1.2.fastq.gz --read2-in=HepG2-STAU2-1.1.fastq.gz -S ../HepG2-STAU2-1.2.fastq.gz --read2-out=../HepG2-STAU2-1.1.fastq.gz"
sbatch -N 1 --mem=32G -t 12:00:00 --wrap="umi_tools extract --bc-pattern NNNNNNNNNN -I HepG2-STAU2-2.2.fastq.gz --read2-in=HepG2-STAU2-2.1.fastq.gz -S ../HepG2-STAU2-2.2.fastq.gz --read2-out=../HepG2-STAU2-2.1.fastq.gz"
sbatch -N 1 --mem=32G -t 12:00:00 --wrap="umi_tools extract --bc-pattern NNNNNNNNNN -I K562-APOBEC3C-1.2.fastq.gz --read2-in=K562-APOBEC3C-1.1.fastq.gz -S ../K562-APOBEC3C-1.2.fastq.gz --read2-out=../K562-APOBEC3C-1.1.fastq.gz"
sbatch -N 1 --mem=32G -t 12:00:00 --wrap="umi_tools extract --bc-pattern NNNNNNNNNN -I K562-APOBEC3C-2.2.fastq.gz --read2-in=K562-APOBEC3C-2.1.fastq.gz -S ../K562-APOBEC3C-2.2.fastq.gz --read2-out=../K562-APOBEC3C-2.1.fastq.gz"