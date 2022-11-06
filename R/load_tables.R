#' Load all tables in a schema into an environment
#' @param con connection to wrds
#' @param schema name of schema to use
#' @param env environment to assign these variables in
#' @export
#' @details This is not meant to be used in a production context
#' where more targeted approaches probably make more sense.
#' But for users who are relatively new to using SQL and,
#' for example, want to just load all available crsp tables
#' into memory, this could be useful. Anyway this is probably bad
#' practice, and usually annoys me, but in this case I think
#' it might be useful.
#' @import dbplyr
#' @importFrom dplyr tbl
#' @importFrom dbplyr in_schema
load_schema <- function(con, schema, env = parent.frame()) {
  message("Loading tables...")
  tables <- list_tables(con, schema)
  if(length(tables) > 10) {
    pb <- progress::progress_bar$new(total = length(tables))
    pb$tick(0)
  } else {
    pb <- list(tick = function() {})
  }

  for(i in 1:length(tables)) {
    pb$tick()
    table <- tables[i]
    tryCatch({
      assign(table,
             value = dplyr::tbl(con,
                                dbplyr::in_schema(schema,
                                                  table)
             ),
             envir = env
      )
    }, error = function(e) {

    })

  }
  message("All finished!")
}

#' Get the schema of a set of tables
#' @param tbl_cons table connections from dbplyr
#' @importFrom stringr str_replace_all
#' @importFrom stringr str_extract
check_schema <- function(tbl_cons) {
  if("tbl_sql" %in% class(tbl_cons)) {
    tbl_cons <- list(tbl_cons)
  }
  sapply(tbl_cons,
         function(tbl_con) {
           stringr::str_replace_all(
             stringr::str_extract(
               as.character(tbl_con[["ops"]]$x),
               "^.*\\."),
             "[^A-Za-z]",""
             )
         }
  )
}

#' Remove all table items created by loading a schema
#' @param con connection to WRDS
#' @param schema schema to clean up
#' @param env environment to load schema into
#' @export
#' @details This function will remove any tables in the current (parent) environment
#' that are in the chosen schema. Useful for cleaning up workspaces following
#' `load_schema()`.
clean_schema <- function(con, schema, env = parent.frame()) {
  tbls <- intersect(list_tables(con, schema), ls(envir = env))
  if(length(tbls) == 0) {
    stop("There are no tables to remove in schema '", schema, "'.")
  }
  classes <- do.call(function(y) {
    sapply(y, function(x) schema == check_schema(get(x)))
    },args = list(y = tbls))
  tbls <- tbls[which(classes)]
  rm(list = tbls, envir = env)
}
