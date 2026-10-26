# OIL-PRICES — Brent price forecasting

Time series forecasting of the **Europe Brent Spot Price FOB** (USD/barrel) with ARIMA,
using the daily data published by the [EIA](https://www.eia.gov/dnav/pet/hist/LeafHandler.ashx?n=PET&s=rbrte&f=D)
since 1987, aggregated to monthly means.

## Contents

| File | Description |
| --- | --- |
| `Brent.Rmd` / `Brent.html` | Full report: exploration, STL decomposition, ADF/KPSS tests, ACF/PACF, Naive / Drift / ETS / ARIMA models, test set (last 24 months), rolling cross-validation, residual checks and 12 month forecast. |
| `Brent.R` | Script: fits ARIMA with all the data and saves the forecast to `output/brent_forecast.csv` and `output/brent_forecast.png`. |
| `R/brent.R` | Shared functions: download, read and monthly aggregation. |
| `data/RBRTEd.xls` | EIA data. Downloaded again automatically when older than 7 days. |
| `draft/` | Old drafts (not tracked by git). |

## Usage

```bash
Rscript Brent.R          # 12 month forecast
Rscript Brent.R 24       # 24 month forecast
Rscript -e "rmarkdown::render('Brent.Rmd')"
```

R packages: `readxl`, `xts`, `forecast`, `tseries`, `ggplot2`, `plotly`, `rmarkdown`.

## Notes

Monthly log returns of oil are close to white noise, so ARIMA forecasts are only slightly
better (or worse) than the random walk. The report compares both explicitly.
