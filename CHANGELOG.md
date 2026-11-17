# Changelog

All notable changes to this project are documented in this file. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the versions follow
[Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- Shiny app (`make app`, http://127.0.0.1:8322): downloads the EIA Brent prices, fits the same model as `Brent.R`
  (`auto.arima` on log prices) and shows the forecast with its intervals.
- `Makefile` with the common targets of the author's projects (`help`, `setup`, `format`, `lint`, `test`, `check`,
  `docs`, `build`, `clean`, `release`) and `project.mk` with `app` and `update`.
- `CITATION.cff`.

### Changed
- `R/brent.R` and `Brent.R` formatted with styler; `make lint` reports no issues.
- `.gitignore` rebuilt from the common templates (base + R), with this repo's own rules at the end.
