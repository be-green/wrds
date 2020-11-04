#' Error and suggest user set username
stop_no_user <- function() {
  stop("No username specified. Please set via set_wrds_user()",
       " or set the WRDS_USER environment variable yourself.")
}

#' Error and suggest user set password
stop_no_pass <- function() {
  stop("No password specified. Please set via set_wrds_pass()",
       " or set the WRDS_PASS environment variable yourself.")
}

#' Get username for WRDS connection
#' @export
wrds_user <- function() {
  user <- Sys.getenv("WRDS_USER")
  if(user == "") {
    stop_no_user()
  }
  user
}

#' Get username for WRDS connection
#' @export
wrds_pass <- function() {
  pass <- Sys.getenv("WRDS_PASS")
  if(pass == "") {
    stop_no_pass()
  }
  pass
}

create_if_nonexistent <- function(filename) {
  if(!file.exists(filename)) {
    file.create(filename)
  }
}

#' Overwrite an existing variable in the .Renviron file
#' @param env_var environment variable to overwrite
#' @param newstring new string to pass as value for environment variable
#' @importFrom assertthat assert_that
overwrite_in_renviron <- function(env_var, newstring) {

  assertthat::assert_that(is.character(env_var))
  assertthat::assert_that(nchar(env_var) > 0)
  assertthat::assert_that(is.character(newstring))
  assertthat::assert_that(nchar(newstring) > 0)

  create_if_nonexistent("~/.Renviron")
  lines <- readLines("~/.Renviron")
  env_line <- which(stringr::str_detect(lines, env_var))

  new_var <- paste0(env_var, "=","\'",newstring,"\'")

  if(length(env_line) == 0) {
    lines[length(lines) + 1] <- new_var
  } else {
    lines[env_line] <- new_var
  }

  writeLines(lines, "~/.Renviron")
}

#' Refresh R environment variables
refresh_renviron <- function() {
  readRenviron("~/.Renviron")
}

#' Set username for WRDS connection
#' @param user username to set and use for connections
#' @param ask whether to ask before overwriting existing user id
#' @importFrom assertthat assert_that
#' @export
set_wrds_user <- function(user, ask = T) {

  assertthat::assert_that(is.character(user))
  assertthat::assert_that(nchar(user) > 0)

  olduser <- Sys.getenv("WRDS_USER")
  if(olduser == "") {
    overwrite_in_renviron("WRDS_USER", user)
    message("Password changed.")
  } else if(olduser == user) {
    message("Username is already ", user, ".")
  } else if (ask){
    message("Your current WRDS username is set to ", olduser, ".")
    change <- readline("Are you sure you want to change it? Y/N: \n")
    if(change == "Y") {
      overwrite_in_renviron("WRDS_USER", user)
      message("Password changed.")
    } else {
      message("Keeping old password.")
    }
  } else {
    overwrite_in_renviron("WRDS_USER", user)
    message("Password changed.")
  }

  refresh_renviron()
}

#' Set password for WRDS connection
#' @param pass username to set and use for connections
#' @param ask whether to ask before overwriting existing user id
#' @importFrom assertthat assert_that
#' @export
set_wrds_pass <- function(pass, ask = T) {

  assertthat::assert_that(is.character(pass))
  assertthat::assert_that(nchar(pass) > 0)
  oldpass <- Sys.getenv("WRDS_PASS")
  if(oldpass == "") {
    overwrite_in_renviron("WRDS_PASS", pass)
  } else if(oldpass == pass) {
    message("Password is already ", pass, ".")
  } else if (ask){
    message("Your current WRDS password is set to ", oldpass, ".")
    change <- readline("Are you sure you want to change it? Y/N: \n")
    if(change == "Y") {
      overwrite_in_renviron("WRDS_PASS", pass)
      message("Password changed.")
    } else {
      message("Keeping old password.")
    }
  } else {
      overwrite_in_renviron("WRDS_PASS", pass)
  }
  refresh_renviron()
}


