library(jsonlite)

output_dir <- Sys.getenv("MEDIFORCE_OUTPUT_DIR", unset = "/output")

result <- list(
  ok = TRUE,
  rVersion = paste(R.version$major, R.version$minor, sep = "."),
  admiralInstalled = requireNamespace("admiral", quietly = TRUE),
  libPaths = I(.libPaths()),
  siteLibrary = I(list.files("/usr/local/lib/R/site-library")),
  baseLibrary = I(list.files("/usr/local/lib/R/library")),
  scriptFiles = I(list.files("/app/scripts/"))
)

write(
  toJSON(result, auto_unbox = TRUE, pretty = TRUE),
  file.path(output_dir, "result.json")
)
