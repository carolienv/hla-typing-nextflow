process PREPROCESS_10X_BAM {

    tag "$meta.id"

    label 'process_medium'

    input:
    tuple val(meta), path(bam)

    output:
    tuple val(meta), path("${meta.id}_fished.R2_001.fastq"), emit: fished_fastq

    script:
    """
    set -euo pipefail

    echo "Sample: ${meta.id}"
    echo "BAM: ${bam}"

    # preprocessing code will go here
    """
}