# The base is pinned by digest (the texlive/texlive:latest of 2026-11-08), so every LaTeX repo builds on the
# same 4.8 GB base and Docker stores it once. The bare `latest` tag is published again every week, which
# gave each paper repo its own copy of the base. To update, read the new digest with
# `docker buildx imagetools inspect texlive/texlive:latest` and set it in every LaTeX repo at the same time.
FROM texlive/texlive:latest@sha256:07e8062637249c4f780ca59f42cc2ed592bc2dc1db4320769406aee3f98aa70e

ARG USERNAME=texlive
ARG USER_UID=1000
ARG USER_GID=1000

# Add the GitHub CLI apt source, then install the tooling the LaTeX workflow needs, plus what
# video/build_video.py needs (ffmpeg, PyYAML, the DejaVu fonts its captions use).
# NOTE: pdfunite is a BINARY, not a package name - it ships inside poppler-utils.
# Asking apt for "pdfunite" fails with "E: Unable to locate package pdfunite" and
# takes the whole image build down with it.
RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        gnupg \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        gh \
        openssh-client \
        chktex \
        poppler-utils \
        sudo \
        ffmpeg \
        python3-yaml \
        fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/*

# Deliberately a separate layer. The || fallbacks below break && short-circuiting,
# so when the apt layer above failed the build used to resume here and report a
# misleading "cannot create /etc/sudoers.d/texlive: Directory nonexistent" instead
# of the real cause. The parentheses keep each fallback pair self-contained.
RUN set -eux \
    && (groupadd --gid $USER_GID $USERNAME 2>/dev/null || groupmod --gid $USER_GID $USERNAME) \
    && (useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME 2>/dev/null \
        || usermod --uid $USER_UID --gid $USER_GID $USERNAME) \
    && echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
