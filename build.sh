#!/usr/bin/env bash
# Builds resume-violetbudiansky.pdf from main.tex and cleans up LaTeX junk files.
set -euo pipefail
cd "$(dirname "$0")"

name=resume-violetbudiansky

if ! xelatex -interaction=nonstopmode -halt-on-error -jobname="$name" main.tex >/dev/null; then
  grep -A5 '^!' "$name.log" || tail -20 "$name.log"
  exit 1
fi

rm -f "$name".{aux,log,out}

pages=$(pdfinfo "$name.pdf" 2>/dev/null | awk '/^Pages:/ {print $2}')
echo "built $name.pdf (${pages:-?} page(s))"
[ "${pages:-1}" -eq 1 ] || echo "warning: resume is more than one page"
