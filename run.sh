#!/bin/bash

ml purge
ml Nextflow/21.04.0
ml Singularity/3.6.4
ml Graphviz/2.38.0-foss-2016b

nextflow pull ulelab/peka-eclip -r main

nextflow run ulelab/peka-eclip -r main --input './data'
