# R probe image — extends the golden image (R + tidyverse + pak already present).
# This Dockerfile MUST stay at the repo root: the platform sets the build
# context to the Dockerfile's own directory (docker-image-builder.ts), so
# `COPY scripts/` only resolves while this file sits beside `scripts/`.
FROM mediforce-golden-image

COPY scripts/ /app/scripts/

# CDISC + teal stack, all from CRAN so install2.r pulls prebuilt binaries from
# Posit Package Manager instead of compiling from source. Installing these from
# GitHub via pak would compile them and burn the unauthenticated 60-req/hr
# GitHub API limit — the platform passes no --build-arg, so no PAT is available
# during the build (`repoAuth` authenticates the clone, not the build).
#
# Output goes to a log with only the last 50 lines echoed on failure: the
# platform shells out via execSync with stdio:'pipe' and no maxBuffer override,
# so combined stdout+stderr above Node's 1 MiB default kills the build with
# ENOBUFS.
RUN install2.r --error --skipinstalled -n 4 \
      admiral \
      admiraldev \
      metacore \
      metatools \
      xportr \
      datasetjson \
      random.cdisc.data \
      pharmaversesdtm \
      teal \
      teal.modules.general \
      tern \
    > /tmp/cran-install.log 2>&1 \
 || (tail -50 /tmp/cran-install.log && false)

WORKDIR /workspace
