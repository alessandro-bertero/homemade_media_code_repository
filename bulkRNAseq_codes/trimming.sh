#!/bin/bash

fastq_files=/home/shared_folder/fastq/*.fastq.gz
for i in $fastq_files
do
	trim_galore --adapter CTGTCTCTTATACACATCT --trim1 --clip_R1 4 --gzip --fastqc --output_dir ./Data/Trimmed_fastq $i
done
