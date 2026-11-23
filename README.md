# Long CV of Alejandro Lorite Mora

The long, text-based CV for application portals and academic applications. The one-page visual CV stays in Google Slides.

- `cv.tex`: the CV. The layout follows the CV that Pratik Ingle shared (plain `article` class, one column).
- `publications.tex`: the publication list, kept by hand, newest first.
- `private.tex` (not in git): phone number and references. Start from `private.example.tex`.

Build with `./build.sh`. It runs `latexmk` in the LaTeX dev container in `.devcontainer/`, which uses the same Dockerfile and pinned TeX Live image as the paper repos, so Docker reuses their layers. If VS Code has the dev container open, the script builds inside it.

On every push to `main`, GitHub Actions builds the PDF in the same pinned TeX Live image and publishes it at <https://github.com/Lorite/lorite-cv/releases/download/cv-latest/Alejandro-Lorite-Mora-CV.pdf>. The runner has no `private.tex`, so that public PDF has no phone number.
