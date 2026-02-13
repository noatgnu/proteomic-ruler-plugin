#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { PROTEOMIC_RULER } from './modules/local/proteomic-ruler/main'

workflow PIPELINE {
    main:
    PROTEOMIC_RULER (
        params.input_file ? Channel.fromPath(params.input_file).collect() : Channel.of([]),
        Channel.value(params.accession_id_col ?: ''),
        Channel.value(params.mw_column ?: ''),
        Channel.value(params.intensity_columns ?: ''),
        Channel.value(params.ploidy ?: ''),
        Channel.value(params.total_cellular ?: ''),
        Channel.value(params.get_mw ?: ''),
    )
}

workflow {
    PIPELINE ()
}
