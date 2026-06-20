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
```

## Requirements

The pipeline requires:

- Nextflow
- Apptainer or another supported Nextflow container engine

The pipeline uses containers from the Galaxy Depot Singularity container registry.

> **Note**
> The current default configuration is set up for a Slurm-based HPC environment. Users running on a local machine or another scheduler may need to adapt the executor settings in `nextflow.config`.

## Input

The pipeline expects a CSV samplesheet with at least two columns:

```csv
sample_id,bam
sample1,/path/to/sample1.bam
sample2,/path/to/sample2.bam
```

Required columns:

| Column | Description |
|---|---|
| `sample_id` | Unique sample name used in output filenames |
| `bam` | Path to the input 10X Genomics BAM file |

The BAM index is expected to be available next to the BAM file with the `.bai` suffix.

For example, if the BAM file is:

```text
/path/to/sample1.bam
```

the pipeline expects the index file to be:

```text
/path/to/sample1.bam.bai
```

## Running on your own data

Prepare a samplesheet and run:

```bash
nextflow run main.nf \
  --input samplesheet.csv \
  --outdir results \
  -profile apptainer
```

On the training HPC, the `apptainer` profile enables Apptainer and uses the configured Apptainer cache directory.

## Outputs

Pipeline outputs are written to the directory specified by:

```bash
--outdir
```

By default, this is:

```text
results/
```

For the test profile, this is:

```text
results_test/
```

### Main OptiType outputs

The main OptiType outputs are written to:

```text
<outdir>/optitype/
```

Important files include:

```text
combined_optitype_results.tsv
```

and one OptiType result file per sample:

```text
<sample_id>_result.tsv
```

## Citations

Please see [`CITATIONS.md`](CITATIONS.md) for software and data citations.

## License

This project is licensed under the terms described in [`LICENSE`](LICENSE).