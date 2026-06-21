# Test data

The test profile uses a public 10X Genomics 5' single-cell RNA-seq BAM file to test the pipeline.

The test data are prepared automatically when running:

```bash
nextflow run carolienv/hla-typing-nextflow -profile test,apptainer
```

## Downloaded files

The test-data script is:

```text
assets/download_testdata.sh
```

It downloads:

```text
sc5p_v2_hs_PBMC_1k_possorted_genome_bam.bam
sc5p_v2_hs_PBMC_1k_possorted_genome_bam.bam.bai
```

The BAM file is approximately 5 GB, so make sure enough disk space is available before running the test.

## Location

Downloaded test files are stored in:

```text
assets/test_data/
```

This directory is ignored by Git and is not stored in the repository.

## Symlinked second sample

To test multi-sample behaviour without storing a second BAM file, the download script creates a second symlinked BAM and BAI file:

```text
s2_sc5p_v2_hs_PBMC_1k_possorted_genome_bam.bam
s2_sc5p_v2_hs_PBMC_1k_possorted_genome_bam.bam.bai
```

These symlinks point to the original downloaded BAM and BAI files.

The test samplesheet is:

```text
assets/samplesheet_testdata.csv
```

It contains two samples: one using the original BAM and one using the symlinked BAM.

## Re-running the test-data script

The download script is designed to be re-run safely.

If the BAM and BAI already exist, they are not downloaded again.

If the symlinks already exist, they are not recreated.

## Removing test data

To remove the downloaded test data:

```bash
rm -rf assets/test_data/
```

To remove test results and Nextflow work files:

```bash
rm -rf results_test/
rm -rf work/
rm -f .nextflow.log*
```