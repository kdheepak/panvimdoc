build:
    @./entrypoint.sh "--project-name" "panvimdoc" "--input-file" "doc/panvimdoc.md" "--vim-version" "NVIM v0.8.0" "--toc" "true" "--description" "" "--dedup-subheadings" "false" "--demojify" "false" "--treesitter" "true"
