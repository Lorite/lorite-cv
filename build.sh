#!/usr/bin/env bash
# Build cv.pdf. Runs pdflatex twice for stable links. Overleaf builds the same source.
set -euo pipefail
cd "$(dirname "$0")"
for i in 1 2; do
    pdflatex -interaction=nonstopmode -halt-on-error cv.tex > /dev/null
done
echo "Built $(pwd)/cv.pdf"
