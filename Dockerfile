# R probe image — extends the golden image (R + jsonlite already present).
# Build context is this file's directory (the repo root), so `COPY scripts/`
# resolves against the repo root. See build-workflow platform-contract §2.
FROM mediforce-golden-image

COPY scripts/ /app/scripts/

WORKDIR /workspace
