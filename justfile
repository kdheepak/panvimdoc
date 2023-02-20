build:
    @./panvimdoc.sh "--project-name" "panvimdoc" "--input-file" "doc/panvimdoc.md" "--vim-version" "NVIM v0.8.0" "--toc" "true" "--description" "" "--dedup-subheadings" "true" "--demojify" "false" "--treesitter" "true" "--ignore-rawblocks" "true" "--doc-mapping" "true" "--doc-mapping-project-name" "true" --shift-heading-level-by 0 --increment-heading-level-by 0
