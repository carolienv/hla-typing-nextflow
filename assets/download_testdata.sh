#!/usr/bin/env bash
#SBATCH --job-name=download_testdata
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --time=04:00:00

set -euo pipefail

OUTDIR="assets/test_data/10x_5prime_pbmc_1k"

mkdir -p "${OUTDIR}"

wget -c \
  -O "${OUTDIR}/sc5p_v2_hs_PBMC_1k_possorted_genome_bam.bam" \
  "https://cf.10xgenomics.com/samples/cell-vdj/4.0.0/sc5p_v2_hs_PBMC_1k/sc5p_v2_hs_PBMC_1k_possorted_genome_bam.bam"

wget -c \
  -O "${OUTDIR}/sc5p_v2_hs_PBMC_1k_possorted_genome_bam.bam.bai" \
  "https://cf.10xgenomics.com/samples/cell-vdj/4.0.0/sc5p_v2_hs_PBMC_1k/sc5p_v2_hs_PBMC_1k_possorted_genome_bam.bam.bai"