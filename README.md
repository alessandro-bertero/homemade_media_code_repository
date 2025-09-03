# Code Repository homemade_media_code_repository

This GitHub page is the repository of the publication "Refined and benchmarked homemade media for cost-effective, weekend-free human pluripotent stem cell culture"; data are all available from our [Zenodo repository](https://zenodo.org/doi/10.5281/zenodo.12684584) as well as from Biostudies ([E-MTAB-14237](https://www.ebi.ac.uk/biostudies/arrayexpress/studies/E-MTAB-14237) and [add here name](https://www.ebi.ac.uk/biostudies/arrayexpress/studies/E-MTAB-14237)).

Trimming and alignment of the Bulk RNAseq data:

Fastq files can be downloaded from our BioStudies repository [E-MTAB-14237](https://www.ebi.ac.uk/biostudies/arrayexpress/studies/E-MTAB-14237).
trimming.sh performs the trimming with TrimGalore, alignment.sh performs the alignment with STAR. The scripts can be run in our docker which can be downloaded from our repository hedgelab/bulk_alignment.

Bulk RNAseq data analysis:

The analysis can be performed within a Docker environment which uses Rstudio server (??2023.12.1 Build 402 ìOcean stormî release). The docker image can be downloaded from our repository hedgelab/rstudio-hedgelab (rstudio password is ìrstudioî). 
Input data can be downloaded from our [Zenodo repository](https://zenodo.org/doi/10.5281/zenodo.12684584)
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

scRNAseq data analysis:

Data can be downloaded as a row data or processed from our BioStudies repository [add name here](https://www.ebi.ac.uk/biostudies/arrayexpress/studies/E-MTAB-14237). Alternatively, processed data and RData are available to download from our [Zenodo repository](https://zenodo.org/doi/10.5281/zenodo.12684584). Download the "scratch" folder in the repository and place it in the same directory as the scRNAseq codes available here (3 R markdown files numbered from 1 to 3). Then run the codes within our Docker environment hedgelab/rstudio-hedgelab.

Karyotyping data analysis:


