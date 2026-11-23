#!/usr/bin/env bash
# Build cv.pdf with latexmk inside the LaTeX dev container (the same pinned TeX Live image as the paper repos).
# 1. If VS Code has the dev container running, build inside it.
# 2. Otherwise build the image from .devcontainer/ (cached after the first time) and run it once.
set -euo pipefail
REPO="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO"
CMD=(latexmk -pdf -interaction=nonstopmode -halt-on-error cv.tex)

C=$(docker ps -q --filter "label=devcontainer.local_folder=$REPO" | head -1)
if [ -n "$C" ]; then
    docker exec -u texlive -w "/workspaces/$(basename "$REPO")" "$C" "${CMD[@]}" > latexmk.out 2>&1
else
    docker build -q -t lorite-cv-texlive "$REPO/.devcontainer" > /dev/null
    docker run --rm -u "$(id -u):$(id -g)" -v "$REPO:/work" -w /work lorite-cv-texlive "${CMD[@]}" > latexmk.out 2>&1
fi || { echo "Build failed, see $REPO/latexmk.out and $REPO/cv.log" >&2; exit 1; }
echo "Built $REPO/cv.pdf"
