process COLLECT_OPTITYPE_RESULTS {

    label 'process_medium'

    publishDir "${params.outdir}/optitype", mode: 'copy'

    input:
    path optitype_results

    output:
    path "combined_optitype_results.tsv", emit: combined_results

    script:
    """
    set -euo pipefail

    bash ${projectDir}/bin/collect_optitype_results.sh ${optitype_results}
    """
}