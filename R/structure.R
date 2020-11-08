
#' Return structure of all available schemas
#' @importFrom odbc dbDisconnect
#' @importFrom data.table rbindlist
#' @importFrom data.table as.data.table
#' @importFrom data.table data.table
#' @importFrom data.table `:=`
learn_schema_structure <- function() {
  con <- connect_to_wrds()
  schemas <- data.table::as.data.table(list_schemas(con))
  schemas[,I := .I]

  suppressWarnings({

  tbl_structure <-
    data.table::rbindlist(
      lapply(split(schemas, by = "I"),
           function(x) {
      data.table::data.table(Table = list_tables(con,schema = x$name),
                 x)
    }))

  })
  odbc::dbDisconnect(con)

  tbl_structure[,.(Schema = name, Table = Table)]
}

#' Read saved schema structure file
#' @importFrom data.table fread
read_schema_structure <- function() {
  data.table::fread(system.file("schema-structure.csv", package = "wrds"))
}
