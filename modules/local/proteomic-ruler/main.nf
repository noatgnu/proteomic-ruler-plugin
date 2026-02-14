process PROTEOMIC_RULER {
    label 'process_medium'

    container "${ workflow.containerEngine == 'singularity' ?
        'docker://cauldron/proteomic-ruler:0.1.0' :
        'cauldron/proteomic-ruler:0.1.0' }"

    input:
    path input_file
    val accession_id_col
    val mw_column
    val intensity_columns
    val ploidy
    val total_cellular
    val get_mw

    output:
    
    path "ruler_output.txt", emit: ruler_output, optional: true
    path "versions.yml", emit: versions

    script:
    def args = task.ext.args ?: ''
    """
    # Build arguments dynamically to match CauldronGO PluginExecutor logic
    ARG_LIST=()

    
    # Mapping for mw_column
    VAL="$mw_column"
    if [ -n "\$VAL" ] && [ "\$VAL" != "null" ] && [ "\$VAL" != "[]" ]; then
        ARG_LIST+=("--mw-column" "\$VAL")
    fi
    
    # Mapping for intensity_columns
    VAL="$intensity_columns"
    if [ -n "\$VAL" ] && [ "\$VAL" != "null" ] && [ "\$VAL" != "[]" ]; then
        ARG_LIST+=("--intensity-columns" "\$VAL")
    fi
    
    # Mapping for ploidy
    VAL="$ploidy"
    if [ -n "\$VAL" ] && [ "\$VAL" != "null" ] && [ "\$VAL" != "[]" ]; then
        ARG_LIST+=("--ploidy" "\$VAL")
    fi
    
    # Mapping for total_cellular
    VAL="$total_cellular"
    if [ -n "\$VAL" ] && [ "\$VAL" != "null" ] && [ "\$VAL" != "[]" ]; then
        ARG_LIST+=("--total-cellular" "\$VAL")
    fi
    
    # Mapping for get_mw
    VAL="$get_mw"
    if [ -n "\$VAL" ] && [ "\$VAL" != "null" ] && [ "\$VAL" != "[]" ]; then
        if [ "\$VAL" = "true" ]; then
            ARG_LIST+=("--get-mw")
        fi
    fi
    
    # Mapping for input_file
    VAL="$input_file"
    if [ -n "\$VAL" ] && [ "\$VAL" != "null" ] && [ "\$VAL" != "[]" ]; then
        ARG_LIST+=("--input" "\$VAL")
    fi
    
    # Mapping for accession_id_col
    VAL="$accession_id_col"
    if [ -n "\$VAL" ] && [ "\$VAL" != "null" ] && [ "\$VAL" != "[]" ]; then
        ARG_LIST+=("--accession-id-col" "\$VAL")
    fi
    
    python /app/ruler.py \
        "\${ARG_LIST[@]}" \
         \
        \${args:-}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Proteomic Ruler: 0.1.0
    END_VERSIONS
    """
}
