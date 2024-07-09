#!/bin/bash

fastq_files=/home/ebalmas/scpHUB/projects/EB002AS1/analysis_EB_SB/scratch/CompGenomics/Data/Trimmed_fastq/*.fq.gz
index=/home/ebalmas/scpHUB/projects/EB002AS1/analysis_EB_SB/scratch/CompGenomics/hg38/hg38_STAR_51_2
for i in $fastq_files
do
	base=$(basename $i .fq.gz)
	STAR --runThreadN 3 --genomeDir $index --readFilesIn $i --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --readFilesCommand zcat --outFileNamePrefix $base"_"
done
