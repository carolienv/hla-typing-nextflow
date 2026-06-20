// Process to reads aligned to chromosome 6
process EXTRACT_CHR6_BAM {

    tag "$meta.sample_id"

    label 'process_medium'

    container 'https://depot.galaxyproject.org/singularity/samtools:1.22.1--h96c455f_0'
    
    publishDir "${params.outdir}/preprocess/chr6_bam", mode: 'copy'

    input:
    tuple val(meta), path(bam), path(bai)

    output:
    tuple val(meta), path("${meta.sample_id}.chr6.bam"), emit: chr6_bam

    script:
    """
    set -euo pipefail

    echo "Sample: ${meta.sample_id}"
    echo "Input BAM: ${bam}"
    echo "Input BAI: ${bai}"

    # Detect whether chromosome 6 is called 'chr6' or '6' in the BAM index.
    IDX=\$(samtools idxstats "${bam}" | cut -f1)

    if echo "\$IDX" | grep -qx "chr6"; then
        CHR="chr6"
    elif echo "\$IDX" | grep -qx "6"; then
        CHR="6"
    else
        echo "ERROR: Could not find chromosome 6 for sample ${meta.sample_id}"
        exit 1
    fi

    echo "Using chromosome name: \$CHR"

    # Extract reads aligned to chromosome 6.
    samtools view \\
        -@ ${task.cpus} \\
        -bh "${bam}" "\$CHR" \\
        -o "${meta.sample_id}.chr6.bam"
    """
}

process SUBSAMPLE_BAM {

    tag "$meta.sample_id"

    label 'process_medium'

    container 'https://depot.galaxyproject.org/singularity/samtools:1.22.1--h96c455f_0'

    publishDir "${params.outdir}/preprocess/subsampled_bam", mode: 'copy'

    input:
    tuple val(meta), path(bam)

    output:
    tuple val(meta), path("${meta.sample_id}.chr6.subsampled.bam"), emit: subsampled_bam

    script:
    def seed_fraction = "${params.subsample_seed}${params.subsample_fraction.toString().replaceFirst(/^0\\./, '')}"

    """
    set -euo pipefail

    echo "Sample: ${meta.sample_id}"
    echo "Input BAM: ${bam}"
    echo "Subsample seed/fraction: ${seed_fraction}"

    samtools view \\
        -@ ${task.cpus} \\
        -b \\
        -s "${seed_fraction}" \\
        "${bam}" \\
        -o "${meta.sample_id}.chr6.subsampled.bam"
    """
}

process BAMTOFASTQ_10X {

    tag "$meta.sample_id"

    label 'process_medium'

    container 'https://depot.galaxyproject.org/singularity/10x_bamtofastq:1.4.1--h3ab6199_4'

    publishDir "${params.outdir}/preprocess/r2_fastq", mode: 'copy'

    input:
    tuple val(meta), path(bam)

    output:
    tuple val(meta), path("${meta.sample_id}.R2.fastq.gz"), emit: r2_fastq

    script:
    """
    set -euo pipefail

    echo "Sample: ${meta.sample_id}"
    echo "Input BAM: ${bam}"

    FASTQDIR="${meta.sample_id}_bamtofastq"

    # Convert 10X BAM to FASTQ.
    bamtofastq "${bam}" "\${FASTQDIR}"

    # Collect all R2 FASTQ files into one file.
    # R1 contains cell barcode / UMI information.
    # R2 contains the cDNA sequence used for HLA read fishing.
    find "\${FASTQDIR}" -name "*_R2_001.fastq.gz" -print0 | \\
        sort -z | \\
        xargs -0 cat > "${meta.sample_id}.R2.fastq.gz"

    echo "Number of R2 reads:"
    zgrep -c '^@' "${meta.sample_id}.R2.fastq.gz" || true
    """
}

process PREPARE_OPTITYPE_REFERENCE {

    label 'process_medium'

    container 'https://depot.galaxyproject.org/singularity/optitype:1.5.0--pyhdfd78af_0'

    publishDir "${params.outdir}/preprocess/reference", mode: 'copy'

    output:
    path "hla_reference_rna.fasta", emit: refrna

    script:
    """
    set -euo pipefail

    cp /usr/local/share/optitype/data/hla_reference_rna.fasta hla_reference_rna.fasta
    """
}

process ALIGN_HLA_READS {

    tag "$meta.sample_id"

    label 'process_medium'

    container 'https://depot.galaxyproject.org/singularity/bwa:0.7.19--h577a1d6_1'

    publishDir "${params.outdir}/preprocess/hla_alignment", mode: 'copy'

    input:
    tuple val(meta), path(r2_fastq)
    path refrna

    output:
    tuple val(meta), path("${meta.sample_id}.hla_aligned.sam"), emit: hla_aligned_sam

    script:
    """
    set -euo pipefail

    echo "Sample: ${meta.sample_id}"
    echo "Input R2 FASTQ: ${r2_fastq}"
    echo "HLA reference: ${refrna}"

    bwa index "${refrna}"

    bwa mem \\
        -t ${task.cpus} \\
        "${refrna}" \\
        "${r2_fastq}" \\
        > "${meta.sample_id}.hla_aligned.sam"
    """
}

process EXTRACT_HLA_MAPPED_READS {

    tag "$meta.sample_id"

    label 'process_medium'

    container 'https://depot.galaxyproject.org/singularity/samtools:1.22.1--h96c455f_0'

    publishDir "${params.outdir}/preprocess/hla_fished_fastq", mode: 'copy'

    input:
    tuple val(meta), path(hla_aligned_sam)

    output:
    tuple val(meta), path("${meta.sample_id}.fished.R2.fastq"), emit: hla_fished_fastq

    script:
    """
    set -euo pipefail

    echo "Sample: ${meta.sample_id}"
    echo "Input HLA-aligned SAM: ${hla_aligned_sam}"

    # Keep only reads that mapped to the HLA reference and write them as FASTQ.
    samtools fastq \\
        -@ ${task.cpus} \\
        -F 4 \\
        "${hla_aligned_sam}" \\
        > "${meta.sample_id}.fished.R2.fastq"

    echo "Number of HLA-fished reads:"
    grep -c '^@' "${meta.sample_id}.fished.R2.fastq" || true
    """
}