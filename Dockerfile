# R probe image — extends the golden image (R + jsonlite already present).
# This Dockerfile MUST stay at the repo root: the platform sets the build
# context to the Dockerfile's own directory (docker-image-builder.ts), so
# `COPY scripts/` only resolves while this file sits beside `scripts/`.
#
# Deliberately cheap: no package installs. This build exists to prove the
# platform's build path (repo fetch -> FROM -> COPY -> run) end to end.
# Add expensive layers back only once a fast build is confirmed green.
FROM mediforce-golden-image

COPY scripts/ /app/scripts/

WORKDIR /workspace
