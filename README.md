# BulkRNAseq_media
Trimming and alignment
Fastq files can be downloaded from our BioStudies repository MTAB-14237.
trimming.sh performs the trimming with TrimGalore, alignment.sh performs the alignment with STAR. The scripts can be run in our docker which can be downloaded from our repository hedgelab/bulk_alignment.

Data analysis
The analysis can be performed within a Docker environment which uses Rstudio server (??2023.12.1 Build 402 ìOcean stormî release). The docker image can be downloaded from our repository hedgelab/rstudio-hedgelab (rstudio password is ìrstudioî). 
Input data can be downloaded from our Zenodo repository - https://zenodo.org/doi/10.5281/zenodo.12684584
4 files are needed for our analysis:
* gene_info_filtered.csv contains the information of gene_ID (ENSEMBL), gene_name and gene_type for the selected genes (created from gtf file)
* gene_length.csv contains the transcript length for the selected genes and it is needed for the normalization (created from gtf file)
* counts_ids.csv contains the counts of the 9 samples in the selected genes
* meta.csv contains information about the culture medium (E8/cE8, M8/hE8 and B8) and the replicate number (R1, R2, R3) for each of the 9 sample
Each of these files has to be imported using the first column as rownames and the first row as colnames.
Else it is possible to run the analysis starting from the R data file _bulk_media_data.Rdata, which contains the 4 files described and also the objects  created during the analysis.
Analysis (media_analysis_paper.Rdm) is performed according to the following  steps:
* analysis of the percentage of mitochondrial counts in each sample
* QC analysis with RNAseqQC
* Differential gene expression analysis with limma, glimma and edgeR
* Data normalization (TPM) and correction
* WGCNA analysis on normalized and corrected counts
* Gene ontology analysis on the overrepresented modules among significative genes (topGO)
* Gene set enrichment analysis on biological process and representation of developmental terms
* Gene set enrichment analysis on kegg pathways and representation of pluripotency signalling pathways
