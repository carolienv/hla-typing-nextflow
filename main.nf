nextflow.enable.dsl = 2

include { HLA_TYPING } from './workflows/hla_typing'


workflow {

    if (params.prepare_test_data) {
        log.info("Preparing test data with assets/download_testdata.sh")

        def stdout = new StringBuffer()
        def stderr = new StringBuffer()

        def proc = ["bash", "${projectDir}/assets/download_testdata.sh"].execute()
        proc.consumeProcessOutput(stdout, stderr)
        def exit_code = proc.waitFor()

        if (stdout) {
            log.info(stdout.toString())
        }

        if (stderr) {
            log.warn(stderr.toString())
        }

        if (exit_code != 0) {
            error("Test data preparation failed with exit code ${exit_code}")
        }
    }

    samples_ch = Channel
        .fromPath(params.input)
        .splitCsv(header: true)
        .map { row ->
            if (!row.sample_id) {
                error("Missing required column: sample_id")
            }
            if (!row.bam) {
                error("Missing required column: bam")
            }

            tuple(row, file(row.bam), file("${row.bam}.bai"))
        }

    HLA_TYPING(samples_ch)
}
