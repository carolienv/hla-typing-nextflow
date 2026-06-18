process EXTRACT_CHR6_BAM {

    tag "$meta.sample_id"

    label 'process_medium'

    container 'https://depot.galaxyproject.org/singularity/samtools:1.22.1--h96c455f_0'
    
    publishDir "${params.outdir}/preprocess/chr6_bam", mode: 'copy'

    input:
    tuple val(meta), path(bam)

    output:
    tuple val(meta), path("${meta.sample_id}.chr6.bam"), emit: chr6_bam

    script:
    """
    set -euo pipefail

    echo "Sample: ${meta.sample_id}"
    echo "Input BAM: ${bam}"

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

    # Index the extracted BAM for downstream use.
    samtools index \\
        -@ ${task.cpus} \\
        "${meta.sample_id}.chr6.bam"
    """
}