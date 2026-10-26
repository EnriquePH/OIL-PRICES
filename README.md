# OIL-PRICES — Brent price forecasting

[![Weekly forecast](https://github.com/EnriquePH/OIL-PRICES/actions/workflows/weekly-forecast.yml/badge.svg)](https://github.com/EnriquePH/OIL-PRICES/actions/workflows/weekly-forecast.yml)

Time series forecasting of the **Europe Brent Spot Price FOB** (USD/barrel) with ARIMA,
using the daily data published by the [EIA](https://www.eia.gov/dnav/pet/hist/LeafHandler.ashx?n=PET&s=rbrte&f=D)
since 1987, aggregated to monthly means.

## Latest forecast (monthly mean price, USD/barrel)

![Forecast](plots/forecast-1.png)

<!-- forecast:start -->
Model **ARIMA(1,1,2)** on log(price). Data until **2026-10-20** (last price 115.2 USD), updated 2026-10-26.

| Month | Forecast | 80 % interval | 95 % interval |
| --- | ---: | :---: | :---: |
| 2026-10 | 120.5 | 106.2 – 135.5 | 99.6 – 144.5 |
| 2026-11 | 118.4 | 96.0 – 142.6 | 86.5 – 158.4 |
| 2026-12 | 116.7 | 89.6 – 146.5 | 78.6 – 166.9 |
| 2027-01 | 115.1 | 84.8 – 149.1 | 73.0 – 173.1 |
| 2027-02 | 113.8 | 81.0 – 150.9 | 68.7 – 178.0 |
| 2027-03 | 112.7 | 78.0 – 152.4 | 65.3 – 182.0 |
| 2027-04 | 111.8 | 75.4 – 153.6 | 62.5 – 185.5 |
| 2027-05 | 111.0 | 73.3 – 154.7 | 60.1 – 188.6 |
| 2027-06 | 110.3 | 71.4 – 155.7 | 58.1 – 191.4 |
| 2027-07 | 109.8 | 69.8 – 156.6 | 56.4 – 194.0 |
| 2027-08 | 109.3 | 68.4 – 157.5 | 54.9 – 196.4 |
| 2027-09 | 108.9 | 67.2 – 158.4 | 53.5 – 198.7 |
<!-- forecast:end -->

The table is updated every Sunday by GitHub Actions ([CSV](output/brent_forecast.csv)).

## Contents

| File | Description |
| --- | --- |
| `Brent.Rmd` | Full report (renders to `Brent.html`, not tracked): exploration, STL decomposition, ADF/KPSS tests, ACF/PACF, Naive / Drift / ETS / ARIMA models, test set (last 24 months), rolling cross-validation, residual checks and 12 month forecast. |
| `Brent.R` | Script: fits ARIMA with all the data and saves the forecast to [`output/brent_forecast.csv`](output/brent_forecast.csv) and `output/brent_forecast.png`. |
| `plots/` | Report figures, written by `Brent.Rmd`. |
| `R/brent.R` | Shared functions: download, read and monthly aggregation. |
| `data/RBRTEd.xls` | EIA data. Downloaded again automatically when older than 7 days. |
| `draft/` | Old drafts (not tracked by git). |

## Usage

```bash
Rscript Brent.R            # 12 month forecast
Rscript Brent.R 24         # 24 month forecast
Rscript Brent.R --update   # download the latest EIA data first
Rscript -e "rmarkdown::render('Brent.Rmd')"
```

R packages: `readxl`, `xts`, `forecast`, `tseries`, `ggplot2`, `plotly`, `rmarkdown`.

## Data updates

The EIA file is downloaded again automatically when the local copy is older than 7 days
(`--update` forces it). The EIA publishes the daily series weekly, with a delay of about
one week, so the latest data point is usually 5–10 days old. Only complete months are
modelled: the current month is dropped until it is (almost) finished.

## Weekly update (GitHub Actions)

[`.github/workflows/weekly-forecast.yml`](.github/workflows/weekly-forecast.yml) runs every
Sunday at 06:00 UTC (and manually from the *Actions* tab): downloads the latest EIA data,
runs `Brent.R` and renders `Brent.Rmd`, and commits `data/`, `plots/` and `output/` when they
change. The rendered `Brent.html` is attached to each run as an artifact.

## Plots

### Monthly mean price
![Monthly prices](plots/monthly-prices-1.png)

### STL decomposition of log(price)
![STL decomposition](plots/stl-decomposition-1.png)

### Monthly log returns, ACF and PACF
![Log returns](plots/log-returns-1.png)
![ACF and PACF](plots/acf-pacf-1.png)

### Forecasts on the test set (last 24 months)
![Test set forecasts](plots/test-forecasts-1.png)

### Cross-validated RMSE by horizon: ARIMA vs random walk
![CV RMSE](plots/cv-rmse-1.png)

### Residuals of the final ARIMA model
![Residuals](plots/residuals-1.png)

## Notes

Monthly log returns of oil are close to white noise, so ARIMA forecasts are only slightly
better (or worse) than the random walk. The report compares both explicitly.
