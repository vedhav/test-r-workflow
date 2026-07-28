# test-r-workflow

A minimal Mediforce workflow that runs an R script from this repo inside a Docker
image built on the platform, and reports the R library paths.

## Layout

- `src/test-r-script-container.wd.json` — the WorkflowDefinition (one `script`
  step + a terminal step).
- `Dockerfile` — extends `mediforce-golden-image` and `COPY`s `scripts/` in.
  Build context is the repo root.
- `scripts/probe.R` — reads `$MEDIFORCE_OUTPUT_DIR` (default `/output`), writes
  `result.json`.

## Deploy target

- Base URL: `https://cdisc.mediforce.ai`
- Namespace: `vedha`
- Image is a **lazy build**: `dockerfile` + `repo` + `commit`, no `image` tag —
  the platform builds it on first run.

## Secrets

- `GITHUB_TOKEN` — a zero-scope fine-grained PAT. Required for the image build to
  clone this repo (the platform rewrites the clone URL to SSH otherwise). Set
  namespace-wide:
  ```bash
  printf '%s' "<token>" | pnpm exec mediforce secret set --key GITHUB_TOKEN --stdin --namespace vedha
  ```

## Output contract

`probe` step `result.json`:

```json
{ "ok": true, "libPaths": ["..."], "siteLibrary": ["..."], "baseLibrary": ["..."] }
```

## Run

```bash
pnpm exec mediforce run start --workflow test-r-script-container --namespace vedha --json
pnpm exec mediforce run watch <runId>
pnpm exec mediforce run get <runId> --json
```
