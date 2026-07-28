# R probe image — extends the golden image (R + jsonlite already present).
# Build context is this file's directory (the repo root), so `COPY scripts/`
# resolves against the repo root. See build-workflow platform-contract §2.
FROM mediforce-golden-image

# admiral (ADaM derivation) — keep build output quiet: the platform builds with
# a ~1MB buffer and a chatty build gets killed. See build-workflow contract.
RUN install2.r --error --skipinstalled admiral > /dev/null 2>&1

COPY scripts/ /app/scripts/

WORKDIR /workspace
