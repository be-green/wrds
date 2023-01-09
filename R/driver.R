driver_type <- "Unicode(x64)"

stop_no_driver <- function() {
  stop("Cannot find a PostgreSQL driver to use to connect to WRDS. ",
  "Please download and install the appropriate driver from ",
  "https://www.postgresql.org/ftp/odbc/versions/.")
}

#' Return correct version of PostgreSQL Driver
#' @importFrom odbc odbcListDrivers
#' @importFrom stringr fixed
#' @importFrom stringr str_detect
driver <- function() {
  available <- odbc::odbcListDrivers(filter = "Postgre")

  sys <- Sys.info()

  pg_drivers <- unique(available[
    which(stringr::str_detect(tolower(available$name),
                              "postgres")
          ),]$name)

  if(!length(pg_drivers) > 0) {
    stop_no_driver()
  }
  if(grepl("windows",tolower(Sys.info()['sysname'])) & length(pg_drivers > 1)) {
    subset(pg_drivers, stringr::str_detect(pg_drivers, stringr::fixed(driver_type)))
  } else {
    pg_drivers
  }
}
