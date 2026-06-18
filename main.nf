nextflow.enable.dsl = 2

include { EXTRACT_CHR6_BAM } from './modules/local/optitype/extract_chr6_bam'
include { SUBSAMPLE_BAM } from './modules/local/optitype/subsample_bam'

workflow {

    samples_ch = Channel
        .fromPath(params.input)
        .splitCsv(header: true)
        .map { row ->
            if (!row.sample_id) {
                error "Missing required column: sample_id"
            }
            if (!row.bam) {
                error "Missing required column: bam"
            }

            tuple(row, file(row.bam), file("${row.bam}.bai"))
        }

    EXTRACT_CHR6_BAM(samples_ch)

    SUBSAMPLE_BAM(EXTRACT_CHR6_BAM.out.chr6_bam)
}