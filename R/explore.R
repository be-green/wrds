#' Peek at top n rows of a table
#' @param tbl table to query
#' @param con connection to wrds
#' @param n number of rows to return
#' @export
peek <- function(con, tbl, n = 10) {
  query(con, paste0("select * from ", tbl, " limit ", n))
}

#' List all tables within an optional schema that match an optional pattern
#' @param con connection to database
#' @param schema schema to match
#' @param pattern pattern to match
#' @export
list_tables <- function(con, schema = NULL) {
  odbc::dbListTables(con, schema_name = schema)
}

#' List all schemas that match an (optional) pattern
#' @importFrom odbc odbcListObjects
#' @param con connection to database
#' @param pattern optional pattern to search across all schemas
#' @export
list_schemas <- function(con, pattern = "") {
  schemas <- odbc::odbcListObjects(con)
  schemas[which(str_detect(schemas$name, pattern)),]
}

#' Check if string is actually a filename
#' @param x string to check
read_if_file <- function(x) {
  if(file.exists(x)) {
    paste0(readLines(x), collapse = "\n")
  } else {
    x
  }
}

#' Query connection with either a sql script or a string
#' @param con connection to database
#' @param q query to pass along
#' @export
query <- function(con, q) {
  q <- read_if_file(q)
  odbc::dbGetQuery(con, q)
}
