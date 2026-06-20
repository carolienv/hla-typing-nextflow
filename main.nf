nextflow.enable.dsl = 2

include {
    EXTRACT_CHR6_BAM
    SUBSAMPLE_BAM
    BAMTOFASTQ_10X
    PREPARE_OPTITYPE_REFERENCE
    ALIGN_HLA_READS
    EXTRACT_HLA_MAPPED_READS
} from './modules/local/optitype/preprocessing'

include { RUN_OPTITYPE } from './modules/local/optitype/optitype'

include { COLLECT_OPTITYPE_RESULTS } from './modules/local/optitype/postprocessing'
workflow {

    if (params.prepare_test_data) {
        log.info "Preparing test data with assets/download_testdata.sh"

        def stdout = new StringBuffer()
        def stderr = new StringBuffer()

        def proc = ["bash", "${projectDir}/assets/download_testdata.sh"].execute()
        proc.consumeProcessOutput(stdout, stderr)
        def exit_code = proc.waitFor()

        if (stdout) {
            log.info stdout.toString()
        }

        if (stderr) {
            log.warn stderr.toString()
        }

        if (exit_code != 0) {
            error "Test data preparation failed with exit code ${exit_code}"
        }
    }

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

    PREPARE_OPTITYPE_REFERENCE()

    EXTRACT_CHR6_BAM(samples_ch)
    SUBSAMPLE_BAM(EXTRACT_CHR6_BAM.out.chr6_bam)
    BAMTOFASTQ_10X(SUBSAMPLE_BAM.out.subsampled_bam)

    ALIGN_HLA_READS(
        BAMTOFASTQ_10X.out.r2_fastq,
        PREPARE_OPTITYPE_REFERENCE.out.refrna
    )

    EXTRACT_HLA_MAPPED_READS(
        ALIGN_HLA_READS.out.hla_aligned_sam
    )

    RUN_OPTITYPE(
        EXTRACT_HLA_MAPPED_READS.out.hla_fished_fastq
    )

    optitype_results_ch = RUN_OPTITYPE.out.optitype_result
        .map { meta, result_tsv -> result_tsv }
        .collect()

    COLLECT_OPTITYPE_RESULTS(optitype_results_ch)
}