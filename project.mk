# Oil Prices (Brent) - project settings and targets (the repo owns this file).
# Not an R package: the common targets of the template (KIND=r) are set here for scripts, the app and the Rmd.

R_CODE := R/brent.R Brent.R app/app.R app/run.R
PKGS   := c("forecast", "ggplot2", "readxl", "xts", "zoo", "shiny", "rmarkdown", "knitr")

SETUP_CMD  := Rscript -e 'p <- $(PKGS); n <- p[!vapply(p, requireNamespace, TRUE, quietly = TRUE)]; \
              if (length(n)) install.packages(n, repos = "https://cloud.r-project.org")'
FORMAT_CMD := Rscript -e 'for (f in strsplit("$(R_CODE)", " ")[[1]]) styler::style_file(f)'
LINT_CMD   := Rscript -e 'l <- unlist(lapply(strsplit("$(R_CODE)", " ")[[1]], lintr::lint), recursive = FALSE); \
              print(l); quit(status = length(l) > 0)'
# smoke test: the local EIA file is read and turned into a monthly series
TEST_CMD   := Rscript -e 'source("R/brent.R"); m <- monthly_brent(read_brent()); \
              stopifnot(frequency(m) == 12, length(m) > 400, all(m > 0)); cat("OK:", length(m), "meses\n")'
CHECK_CMD  :=
DOCS_CMD   := Rscript -e 'rmarkdown::render("Brent.Rmd")'
BUILD_CMD  := Rscript Brent.R
CLEAN_CMD  := rm -f Rplots.pdf Brent.html
VERSION_CMD :=

.PHONY: app update

app: ## Shiny app: download the EIA prices and forecast on http://127.0.0.1:8322 (port convention)
	Rscript app/run.R

update: ## Download the EIA prices now and rebuild the forecast (Brent.R --update)
	Rscript Brent.R --update
