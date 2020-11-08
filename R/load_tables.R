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
