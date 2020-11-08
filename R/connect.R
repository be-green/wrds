#' Create database connection to WRDS back-end databases
#' @param user username to use for connection, defaults to calling `wrds_user()`
#' @param pass password to use for connection, defaults to calling `wrds_pass()`
#' @param ... other arguments the user wants to pass too `DBI::dbConnect()`
#' @export
connect_to_wrds <- function(user = wrds_user(), pass = wrds_pass(), ...) {

  DBI::dbConnect(odbc::odbc(),
                 Driver = driver(),
                 Server = "wrds-pgdata.wharton.upenn.edu",
                 Database = "wrds",
                 UID = user,
                 PWD = pass,
                 Port = 9737,
                 sslmode = "require",
                 ...)
}
