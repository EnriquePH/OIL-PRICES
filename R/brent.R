# Europe Brent Spot Price FOB (Dollars per Barrel)
# https://www.eia.gov/dnav/pet/hist/LeafHandler.ashx?n=PET&s=rbrte&f=D
#
# Common functions used by Brent.R and Brent.Rmd


suppressPackageStartupMessages(library(readxl))
suppressPackageStartupMessages(library(xts))


data_url <- "https://www.eia.gov/dnav/pet/hist_xls/RBRTEd.xls"
data_path <- file.path("data", basename(data_url))


# Download the EIA file if it is missing or older than `max_age_days`.
# If the download fails, the local copy is used.
download_brent <- function(path = data_path, max_age_days = 7) {
  fresh <- file.exists(path) &&
    difftime(Sys.time(), file.mtime(path), units = "days") < max_age_days
  if (fresh) return(invisible(path))
  dir.create(dirname(path), showWarnings = FALSE)
  tmp <- tempfile(fileext = ".xls")
  ok <- tryCatch(download.file(data_url, tmp, mode = "wb", quiet = TRUE) == 0,
                 error = function(e) FALSE, warning = function(w) FALSE)
  if (ok) {
    file.copy(tmp, path, overwrite = TRUE)
  } else if (!file.exists(path)) {
    stop("Cannot download ", data_url)
  } else {
    message("Download failed, using local file ", path)
  }
  invisible(path)
}


# Daily prices as xts
read_brent <- function(path = data_path) {
  brent <- read_excel(path, sheet = "Data 1", skip = 2)
  brent <- na.omit(brent)
  names(brent) <- c("Date", "USD_Barrel")
  xts(brent$USD_Barrel, as.Date(brent$Date), dimnames = list(NULL, "USD_Barrel"))
}


# Monthly mean prices as ts. The last month is dropped if it is incomplete.
monthly_brent <- function(daily) {
  monthly <- apply.monthly(daily, function(x) mean(x))
  last_day <- as.numeric(format(end(daily), "%d"))
  if (last_day < 25) monthly <- monthly[-nrow(monthly)]
  first <- start(monthly)
  ts(as.numeric(monthly),
     start = c(as.numeric(format(first, "%Y")), as.numeric(format(first, "%m"))),
     frequency = 12)
}
