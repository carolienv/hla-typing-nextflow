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

process BAMTOFASTQ {

}

process FISH_HLA_READS {

}