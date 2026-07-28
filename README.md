# test-r-workflow

A minimal Mediforce workflow that runs an inline R script inside a prebuilt
Docker image on the platform, and reports the R version and library paths.

## Layout

- `src/test-r-script-container.wd.json` — the WorkflowDefinition (one `script`
  step + a terminal step). The R source lives in the step's `inlineScript`.

## Deploy target

- Base URL: `https://cdisc.mediforce.ai`
- Namespace: `vedha`
- Image is **prebuilt**: `image: mediforce-agent:cdisc-case-3`, no `dockerfile` /
  `repo` / `commit`. With no build config, `resolveImageBuild` returns
  `undefined` and the platform skips the image-build path entirely — it runs the
  container directly. Nothing is built at run time.

`inlineScript` + `runtime: r` makes the platform write the script to
`/output/script.R` and run `Rscript /output/script.R` in `image`, so no file
needs to be baked into the image or cloned from this repo.

## Secrets

None. `GITHUB_TOKEN` was only needed to clone this repo for the image build; the
prebuilt image needs no repo access.

## Output contract

`probe` step `result.json`:

```json
{
  "ok": true,
  "image": "mediforce-agent:cdisc-case-3",
  "rVersion": "4.6.1",
  "jsonliteInstalled": true,
  "admiralInstalled": false,
  "libPaths": ["..."]
}
```

## Run

```bash
pnpm exec mediforce workflow register --file src/test-r-script-container.wd.json \
  --namespace vedha --base-url https://cdisc.mediforce.ai
pnpm exec mediforce run start --workflow test-r-script-container --namespace vedha --json
pnpm exec mediforce run get <runId> --json
```
