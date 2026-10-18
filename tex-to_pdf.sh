#!/usr/bin/env bash
# Compile every standalone .tex file (one with \documentclass) in this folder
# with lualatex + biber, then remove the temporary files.
# Files without \documentclass (packages.tex, proposal_*.tex) are inputs and are skipped.
# Usage: ./compile.sh [--keep-bbl]
set -uo pipefail
cd "$(dirname "$0")"

keep_bbl=false
case "${1:-}" in
    "") ;;
    --keep-bbl) keep_bbl=true ;;
    *) echo "Usage: $0 [--keep-bbl]" >&2; exit 2 ;;
esac

temp=(aux bcf blg fdb_latexmk fls log out run.xml synctex.gz toc)
$keep_bbl || temp+=(bbl)

latex() { lualatex -interaction=nonstopmode -halt-on-error -file-line-error "$1" > /dev/null; }

status=0
for tex in *.tex; do
    grep -q '^[[:space:]]*\\documentclass' "$tex" || continue
    name=${tex%.tex}
    echo "==> $tex"
    if latex "$tex" && { [[ ! -f $name.bcf ]] || biber -q "$name" > /dev/null; } \
        && latex "$tex" && latex "$tex"; then
        for ext in "${temp[@]}"; do rm -f "$name.$ext"; done
    else
        echo "    FAILED, see $name.log:" >&2
        grep -m 5 -E '^(\./)?[^:]+:[0-9]+:|^!' "$name.log" >&2
        status=1
    fi
done
exit $status
