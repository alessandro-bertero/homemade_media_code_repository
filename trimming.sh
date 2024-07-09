#!/bin/bash

fastq_files=/home/ebalmas/scpHUB/projects/EB002AS1/analysis_EB_SB/scratch/CompGenomics/Data/RNA-Seq/*.fastq.gz
for i in $fastq_files
do
	trim_galore --adapter CTGTCTCTTATACACATCT --trim1 --clip_R1 4 --gzip --fastqc --output_dir ./Data/Trimmed_fastq $i
done
