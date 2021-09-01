#!/usr/bin/env nextflow

params.reads = "$baseDir/data/*.{1,2}.fastq.gz"

def summary = [:]
summary['Output directory'] = params.outdir
summary['Trace directory'] = params.tracedir
log.info "-\033[2m---------------------------------------------------------------\033[0m-"
log.info summary.collect { k,v -> "${k.padRight(25)}: $v" }.join("\n")
log.info "-\033[2m---------------------------------------------------------------\033[0m-"


ch_reads = Channel.fromFilePairs(params.reads)

process REMOVEADAPTERS {

    tag "$sample"
    publishDir "${params.outdir}/adapters_removed", pattern: "*.round2.fastq.gz", mode: 'copy', overwrite: true
    publishDir "${params.outdir}/adapters_removed/logs", pattern: "*.log", mode: 'copy', overwrite: true

    cpus '8'
    memory '32G'
    time '2h'

    input:
    tuple val(sample), path(reads) from ch_reads

    output:
    tuple val(sample), path("*.round2.fastq.gz") into ch_trimmed
    path "*.log"

    """
    cutadapt \
        -j ${task.cpus} \
        --match-read-wildcards \
        --times 1 \
        -e 0.1 \
        -O 1 \
        --quality-cutoff 6 \
        -m 18 \
        -a NNNNNAGATCGGAAGAGCACACGTCTGAACTCCAGTCAC \
        -g CTTCCGATCTACAAGTT \
        -g CTTCCGATCTTGGTCCT \
        -A AACTTGTAGATCGGA \
        -A AGGACCAAGATCGGA \
        -A ACTTGTAGATCGGAA \
        -A GGACCAAGATCGGAA \
        -A CTTGTAGATCGGAAG \
        -A GACCAAGATCGGAAG \
        -A TTGTAGATCGGAAGA \
        -A ACCAAGATCGGAAGA \
        -A TGTAGATCGGAAGAG \
        -A CCAAGATCGGAAGAG \
        -A GTAGATCGGAAGAGC \
        -A CAAGATCGGAAGAGC \
        -A TAGATCGGAAGAGCG \
        -A AAGATCGGAAGAGCG \
        -A AGATCGGAAGAGCGT \
        -A GATCGGAAGAGCGTC \
        -A ATCGGAAGAGCGTCG \
        -A TCGGAAGAGCGTCGT \
        -A CGGAAGAGCGTCGTG \
        -A GGAAGAGCGTCGTGT \
        -o ${sample}.1.adapterTrim.round1.fastq.gz \
        -p ${sample}.2.adapterTrim.round1.fastq.gz \
        ${reads[0]} \
        ${reads[0]} \
        > ${sample}.cutadapt_r1.log

    cutadapt \
        -j ${task.cpus} \
        --match-read-wildcards \
        --times 1 \
        -e 0.1 \
        -O 5 \
        --quality-cutoff 6 \
        -m 18 \
        -A AACTTGTAGATCGGA \
        -A AGGACCAAGATCGGA \
        -A ACTTGTAGATCGGAA \
        -A GGACCAAGATCGGAA \
        -A CTTGTAGATCGGAAG \
        -A GACCAAGATCGGAAG \
        -A TTGTAGATCGGAAGA \
        -A ACCAAGATCGGAAGA \
        -A TGTAGATCGGAAGAG \
        -A CCAAGATCGGAAGAG \
        -A GTAGATCGGAAGAGC \
        -A CAAGATCGGAAGAGC \
        -A TAGATCGGAAGAGCG \
        -A AAGATCGGAAGAGCG \
        -A AGATCGGAAGAGCGT \
        -A GATCGGAAGAGCGTC \
        -A ATCGGAAGAGCGTCG \
        -A TCGGAAGAGCGTCGT \
        -A CGGAAGAGCGTCGTG \
        -A GGAAGAGCGTCGTGT \
        -o ${sample}.1.adapterTrim.round2.fastq.gz \
        -p ${sample}.2.adapterTrim.round2.fastq.gz \
        ${sample}.1.adapterTrim.round1.fastq.gz \
        ${sample}.2.adapterTrim.round1.fastq.gz \
        > ${sample}.cutadapt_r2.log
    """

}

process MOVEUMI {

    tag "$sample"
    publishDir "${params.outdir}/umi_moved", mode: 'copy', overwrite: true

    cpus '1'
    memory '32G'
    time '2h'

    input:
    tuple val(sample), path(reads) from ch_trimmed

    output:
    tuple val(sample), path("*.umi.fastq.gz") into ch_moved

    """
    #!/usr/bin/env python

    import os
    import sys
    import gzip
    from Bio import SeqIO

    input_fq = "${reads[1]}"
    output_fq = "${sample}.umi.fastq"

    with gzip.open(input_fq, mode = 'rt') as f_in:
        with open(output_fq, mode = 'w') as f_out:
            for record in SeqIO.parse(f_in, 'fastq'):
                header = record.id.split(":")
                if '_' not in header[-1]:
                    rearranged = ":".join(header[1:]) + '_' + header[0]
                    record.id = rearranged
                    record.name = rearranged
                    record.description = rearranged
                SeqIO.write(record, f_out, 'fastq')

    os.system('pigz ' + output_fq)
    """

}