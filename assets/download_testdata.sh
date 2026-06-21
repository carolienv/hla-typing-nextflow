#!/usr/bin/env bash

set -euo pipefail

OUTDIR="assets/test_data/10x_5prime_pbmc_1k"

mkdir -p "${OUTDIR}"

BAM="sc5p_v2_hs_PBMC_1k_possorted_genome_bam.bam"
BAI="${BAM}.bai"

BAM_URL="https://cf.10xgenomics.com/samples/cell-vdj/4.0.0/sc5p_v2_hs_PBMC_1k/${BAM}"
BAI_URL="https://cf.10xgenomics.com/samples/cell-vdj/4.0.0/sc5p_v2_hs_PBMC_1k/${BAI}"

S2_BAM="s2_${BAM}"
S2_BAI="${S2_BAM}.bai"

if [ ! -f "${OUTDIR}/${BAM}" ]; then
    echo "Downloading ${BAM}..."
    wget -O "${OUTDIR}/${BAM}" "${BAM_URL}"
else
    echo "${BAM} already exists, skipping download."
fi

if [ ! -f "${OUTDIR}/${BAI}" ]; then
    echo "Downloading ${BAI}..."
    wget -O "${OUTDIR}/${BAI}" "${BAI_URL}"
else
    echo "${BAI} already exists, skipping download."
fi

if [ ! -L "${OUTDIR}/${S2_BAM}" ]; then
    echo "Creating symlink ${S2_BAM}..."
    ln -s "${BAM}" "${OUTDIR}/${S2_BAM}"
else
    echo "${S2_BAM} symlink already exists, skipping."
fi

if [ ! -L "${OUTDIR}/${S2_BAI}" ]; then
    echo "Creating symlink ${S2_BAI}..."
    ln -s "${BAI}" "${OUTDIR}/${S2_BAI}"
else
    echo "${S2_BAI} symlink already exists, skipping."
fi

echo "Done."