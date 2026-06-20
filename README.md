# HLA typing Nextflow pipeline

This repository contains a Nextflow pipeline for HLA typing on 10X Genomics single-cell RNA-seq BAM files.

## Available HLA typing methods

| Method | Status | Notes |
|---|---|---|
| OptiType | Available | Used for MHC class I HLA typing from RNA-seq data. |
| arcasHLA | Coming soon | Planned extension for additional HLA typing, including MHC class II support. |

## Quick start: test run

The pipeline includes a test profile that automatically downloads a public 10X Genomics 5' scRNA-seq BAM file and creates a second symlinked test sample. This allows the workflow to be tested with multiple samples without storing duplicate BAM files.

> **Note**
> The test BAM file is approximately 5 GB. Make sure you have enough disk space before running the test.

Run the test with:

```bash
nextflow run main.nf -profile test,apptainer