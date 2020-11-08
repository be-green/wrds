#' Peek at top n rows of a table
#' @param tbl table to query
#' @param con connection to wrds
#' @param n number of rows to return
#' @export
peek <- function(con, tbl, n = 10) {
  query(con, paste0("select * from ", tbl, " limit ", n))
}

#' List columns of a table
#' @param con connection to wrds
#' @param tbl name of table
#' @param ... other parameters to pass to `odbc::odbcListColumns()`
#' @export
list_columns <- function(con, tbl, ...) {
  odbc::odbcListColumns(con, table = tbl, ...)
}

#' List all tables, optionally a subset within a specific schema
#' @param con connection to database
#' @param schema schema to match
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

#' List all of the tables and columns available in a schema
#' @param con connection to wrds
#' @param schema schema to explore
#' @export
explore_schema <- function(con, schema) {
  tbls <- list_tables(con, schema)
  l <- lapply(tbls, list_columns, con = con, schema = schema)
  names(l) <- tbls
  structure(l, class = "tbl_list")
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

#' Search across schema for matching string
#' @param con connection to wrds
#' @param schema schema to search for
#' @param search search parameter passed as regular expression
#' @param what whether to search for a matching table or column
#' @importFrom stringr str_detect
#' @export
#' @details Searches within a schema for specific columns
search_schema <- function(con, schema, search, what = "column") {
  do.call(paste0("search_schema_for_", what),
          args = list(
            con = con,
            schema = schema,
            search = search
          ))
}

#' Search across schema for matching table
#' @param con connection to wrds
#' @param schema schema to search for
#' @param search search parameter passed as regular expression
#' @export
#' @importFrom stringr str_detect
search_schema_for_table <- function(con, schema, search) {
  tables <- list_tables(con, schema)
  tables <- subset(tables, stringr::str_detect(tables, search))
  lapply(tables, list_columns, con = con)
}

#' Search across schema tables for matching column
#' @param con connection to wrds
#' @param schema schema to search for
#' @param search search parameter passed as regular expression
#' @export
#' @importFrom stringr str_detect
search_schema_for_column <- function(con, schema, search) {
  tables <- explore_schema(con, schema)
  Filter(function(x) any(stringr::str_detect(x$name, search)), tables)
}

#' Search WRDS website for documentation
#' @param search string to search for in online WRDS documentation
#' @details This function launches a browser window and searches the WRDS
#' documentation for the query of interest.
#' @export
#' @importFrom utils browseURL
search_wrds <- function(search) {
  utils::browseURL(paste0("https://wrds-www.wharton.upenn.edu/search/?queryTerms=",search,"&selectedCore=support"))
}
