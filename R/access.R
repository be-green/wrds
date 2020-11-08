#' Check whether you have access to a set of tables
#' @param all_tables set of tables to check for access
#' @importFrom progress progress_bar
#' @importFrom odbc dbDisconnect
check_table_access <- function(all_tables) {

  con <- connect_to_wrds()

  n_tables <- length(all_tables)

  pb <- progress::progress_bar$new(total = n_tables + 1)
  pb$tick(0)

  access <- c()

  for(i in 1:n_tables) {
    access[i] <- tryCatch({
      temp <- peek(con, all_tables[i], n = 0)
      "Yes"
    }, error = function(e) {
      "No"
    })

    pb$tick()
  }

  invisible(odbc::dbDisconnect(con))

  data.frame(Tables = all_tables, Access = access)
}

#' Update access to your tables
#' @importFrom data.table fwrite
#' @importFrom odbc dbDisconnect
update_table_access <- function() {
  con <- connect_to_wrds()
  tbls <- list_tables(con)
  odbc::dbDisconnect(con)
  access <- check_table_access(tbls)
  data.table::fwrite(access, paste0(system.file(package = "wrds"),"/db-access-list.csv"))
}

#' Check whether you have access to a set of tables
#' @param update whether to update with new access check or
#' @importFrom data.table fread
#' @export
available_tables <- function(update = F) {
  if(system.file("db-access-list.csv", package = "wrds") == "") {
    message("Checking table access for the first time, this might take a few minutes...")
    update_table_access()
  } else if (update == T) {
    message("Updating table access, this might take a few minutes...")
    update_table_access()
  }
  access <- data.table::fread(system.file("db-access-list.csv"))
  structure(access, class = "table-list")
}


