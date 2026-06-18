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