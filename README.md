# HLA typing Nextflow pipeline

This repository contains a Nextflow pipeline for HLA typing on 10X Genomics single-cell RNA-seq BAM files.

## Available pipeline modules

The current pipeline contains the following modules:

1. `PREPROCESS_10X_BAM`  
   Preprocesses 10X BAM files and extracts reads that can be used for HLA typing.

2. `RUN_OPTITYPE`  
   Runs OptiType on the preprocessed FASTQ files.

3. `COLLECT_OPTITYPE_RESULTS`  
   Collects the OptiType output files into one combined result table.

## Future perspective
In the future, this pipeline may be extended with addition HLA typing tools, for examples tools like arcasHLA that support MHC class II typing.