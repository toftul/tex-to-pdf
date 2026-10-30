#!/usr/bin/env bash
# Compile .tex files with latexmk, then remove the temporary files after all builds.
# With file arguments, compile only these files. Without them, compile every
# standalone .tex file (one with \documentclass) in the current folder;
# files without \documentclass are inputs and are skipped.
# latexmk runs biber or bibtex as needed.
# The engine comes from a "% !TEX program = xelatex" line. The default is lualatex.
# Usage: tex-to-pdf [--keep-bbl] [file.tex ...]
set -uo pipefail
shopt -s nullglob

keep_bbl=false
files=()
for arg; do
    case "$arg" in
        --keep-bbl) keep_bbl=true ;;
        -*) echo "Usage: $(basename "$0") [--keep-bbl] [file.tex ...]" >&2; exit 2 ;;
        *) files+=("$arg") ;;
    esac
done

if ((${#files[@]} == 0)); then
    for tex in *.tex; do
        grep -q '^[[:space:]]*\\documentclass' "$tex" && files+=("$tex")
    done
fi

# -bibtex-cond1 removes the .bbl on cleanup, but only when its .bib file exists
bib=-bibtex-cond1
$keep_bbl && bib=-bibtex-cond

status=0
built=() modes=()
for ((i = 0; i < ${#files[@]}; i++)); do
    tex=${files[i]}
    echo "==> $tex"
    if [[ ! -f $tex ]]; then
        echo "    FAILED, file not found" >&2
        status=1
        continue
    fi
    name=${tex%.tex}
    engine=$(grep -m 1 -iE '^%[[:space:]]*!TEX[[:space:]]+(TS-)?program' "$tex" \
        | sed 's/.*=[[:space:]]*//' | tr '[:upper:]' '[:lower:]')
    case "$engine" in
        pdflatex*) mode=-pdf ;;
        xelatex*) mode=-xelatex ;;
        *) mode=-lualatex ;;
    esac
    # -cd builds in the folder of the file, so a path like paper/main.tex works
    if latexmk -cd "$mode" "$bib" -interaction=nonstopmode -halt-on-error -file-line-error \
        "$tex" &> /dev/null; then
        built+=("$tex") modes+=("$mode")
    else
        echo "    FAILED, see $name.log:" >&2
        grep -m 5 -E '^(\./)?[^:]+:[0-9]+:|^!' "$name.log" >&2
        status=1
    fi
done

# Clean only at the end: a file can read the .aux of another file (e.g. with xr)
for ((i = 0; i < ${#built[@]}; i++)); do
    latexmk -cd "${modes[i]}" "$bib" -c "${built[i]}" &> /dev/null
done
exit $status
