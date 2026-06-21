nextflow.enable.dsl = 2

include { OPTITYPE_HLATYPING } from '../subworkflows/optitype_hlatyping'


workflow HLA_TYPING {
    take:
    samples_ch

    main:
    OPTITYPE_HLATYPING(samples_ch)

    emit:
    optitype_results = OPTITYPE_HLATYPING.out.combined_results
}
