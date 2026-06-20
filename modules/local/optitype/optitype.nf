process RUN_OPTITYPE {

    tag "$meta.sample_id"

    label 'process_high'

    container 'https://depot.galaxyproject.org/singularity/optitype:1.5.0--pyhdfd78af_0'

    publishDir "${params.outdir}/optitype", mode: 'copy'

    input:
    tuple val(meta), path(fished_fastq)

    output:
    tuple val(meta), path("${meta.sample_id}_optitype"), emit: optitype_result_dir

    script:
    """
    set -euo pipefail

    echo "Sample: ${meta.sample_id}"
    echo "Input fished FASTQ: ${fished_fastq}"

    mkdir -p "${meta.sample_id}_optitype"

    optitype run \\
        -i "${fished_fastq}" \\
        --rna \\
        -o "${meta.sample_id}_optitype" \\
        --prefix "${meta.sample_id}"
    """
}
