#' Create database connection to WRDS back-end databases
#' @param user username to use for connection, defaults to calling `wrds_user()`
#' @param pass password to use for connection, defaults to calling `wrds_pass()`
#' @export
connect_to_wrds <- function(user = wrds_user(), pass = wrds_pass(),
                            database = "wrds") {

  DBI::dbConnect(odbc::odbc(),
                 Driver = driver(),
                 Server = "wrds-pgdata.wharton.upenn.edu",
                 Database = database,
                 UID = user,
                 PWD = pass,
                 Port = 9737,
                 sslmode = "require")
}
