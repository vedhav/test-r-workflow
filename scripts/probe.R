library(jsonlite)

output_dir <- Sys.getenv("MEDIFORCE_OUTPUT_DIR", unset = "/output")

expected <- c(
  "admiral", "admiraldev", "metacore", "metatools", "xportr", "datasetjson",
  "random.cdisc.data", "pharmaversesdtm", "teal", "teal.modules.general", "tern"
)

versions <- vapply(
  expected,
  function(pkg) {
    if (requireNamespace(pkg, quietly = TRUE)) {
      as.character(packageVersion(pkg))
    } else {
      NA_character_
    }
  },
  character(1)
)

missing <- names(versions)[is.na(versions)]

result <- list(
  ok = length(missing) == 0,
  rVersion = paste(R.version$major, R.version$minor, sep = "."),
  packages = as.list(versions),
  missing = I(missing),
  libPaths = I(.libPaths()),
  scriptFiles = I(list.files("/app/scripts/"))
)

cat(
  "probe: R", result$rVersion, "|",
  length(expected) - length(missing), "of", length(expected), "packages present\n"
)
if (length(missing) > 0) {
  cat("missing:", paste(missing, collapse = ", "), "\n")
}

write(
  toJSON(result, auto_unbox = TRUE, pretty = TRUE),
  file.path(output_dir, "result.json")
)

if (length(missing) > 0) {
  quit(status = 1)
}
