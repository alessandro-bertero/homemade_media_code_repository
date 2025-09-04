#!/bin/bash

STAR --runThreadN 3 --runMode geomeGenerate --limitGenomeGenerateRAM=150000000000 --genomeDir /home/shared_folder/hg38 --genomeFastaFiles /home/shared_folder/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa --sjdbGTFfile /home/shared_folder/Homo_sapiens.GRCh38.111.gtf
fastq_files=/home/shared_folder/Data/Trimmed_fastq/*.fq.gz
index=/home/shared_folder/hg38
for i in $fastq_files
do
	base=$(basename $i .fq.gz)
	STAR --runThreadN 3 --genomeDir $index --readFilesIn $i --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --readFilesCommand zcat --outFileNamePrefix $base"_"
done
