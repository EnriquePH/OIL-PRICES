# OIL-PRICES — Brent price forecasting

Time series forecasting of the **Europe Brent Spot Price FOB** (USD/barrel) with ARIMA,
using the daily data published by the [EIA](https://www.eia.gov/dnav/pet/hist/LeafHandler.ashx?n=PET&s=rbrte&f=D)
since 1987, aggregated to monthly means.

## Contents

| File | Description |
| --- | --- |
| `Brent.Rmd` | Full report (renders to `Brent.html`, not tracked): exploration, STL decomposition, ADF/KPSS tests, ACF/PACF, Naive / Drift / ETS / ARIMA models, test set (last 24 months), rolling cross-validation, residual checks and 12 month forecast. |
| `Brent.R` | Script: fits ARIMA with all the data and saves the forecast to `output/brent_forecast.csv` and `output/brent_forecast.png`. |
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

### 12 month forecast
![Forecast](plots/forecast-1.png)

## Notes

Monthly log returns of oil are close to white noise, so ARIMA forecasts are only slightly
better (or worse) than the random walk. The report compares both explicitly.
