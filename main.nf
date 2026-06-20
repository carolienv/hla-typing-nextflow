nextflow.enable.dsl = 2

include {
    EXTRACT_CHR6_BAM
    SUBSAMPLE_BAM
    BAMTOFASTQ_10X
    PREPARE_OPTITYPE_REFERENCE
    ALIGN_HLA_READS
    EXTRACT_HLA_MAPPED_READS
} from './modules/local/optitype/preprocessing'
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
}