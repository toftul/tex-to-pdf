#!/usr/bin/env bash
# Compile every standalone .tex file (one with \documentclass) in the current folder
# with latexmk, then remove the temporary files. latexmk runs biber or bibtex as needed.
# The engine comes from a "% !TEX program = xelatex" line. The default is lualatex.
# Files without \documentclass are inputs and are skipped.
# Usage: tex-to-pdf [--keep-bbl]
set -uo pipefail
shopt -s nullglob

keep_bbl=false
case "${1:-}" in
    "") ;;
    --keep-bbl) keep_bbl=true ;;
    *) echo "Usage: $(basename "$0") [--keep-bbl]" >&2; exit 2 ;;
esac

# -bibtex-cond1 removes the .bbl on cleanup, but only when its .bib file exists
bib=-bibtex-cond1
$keep_bbl && bib=-bibtex-cond

status=0
for tex in *.tex; do
    grep -q '^[[:space:]]*\\documentclass' "$tex" || continue
    name=${tex%.tex}
    engine=$(grep -m 1 -iE '^%[[:space:]]*!TEX[[:space:]]+(TS-)?program' "$tex" \
        | sed 's/.*=[[:space:]]*//' | tr '[:upper:]' '[:lower:]')
    case "$engine" in
        pdflatex*) mode=-pdf ;;
        xelatex*) mode=-xelatex ;;
        *) mode=-lualatex ;;
    esac
    echo "==> $tex"
    if latexmk "$mode" "$bib" -interaction=nonstopmode -halt-on-error -file-line-error \
        "$tex" &> /dev/null; then
        latexmk "$mode" "$bib" -c "$tex" &> /dev/null
    else
        echo "    FAILED, see $name.log:" >&2
        grep -m 5 -E '^(\./)?[^:]+:[0-9]+:|^!' "$name.log" >&2
        status=1
    fi
done
exit $status
