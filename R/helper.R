
#' @export
get_all_categories <- function(file = 'expenses_clean.rds', df = NULL) give_uniques(file, df, 'category')

#' @export
get_all_accounts <- function(file = 'expenses_clean.rds', df = NULL) give_uniques(file, df, 'account')

give_uniques <- function(file = 'expenses_clean.rds', df = NULL, col) {
  if(is.null(df)) df = readRDS(file)
  df[[col]] %>% unique()
}

#' @export
get_date_range <- function(file = 'expenses_clean.rds', df = NULL) {
  if(is.null(df)) df = readRDS(file)
  range(df[['date']])
}

#' @export
get_all_categories_for_account <- function(file = 'expenses_clean.rds', df = NULL, account_to_filter) {
  if(is.null(df)) df = readRDS(file)
  if(account_to_filter != "all") {
    df = df %>% filter(account == account_to_filter)
  }
  get_all_categories(df = df)
}

#' @description  A function to help Mac users get latest file from default ~/Downloads folder automatically
#' @export
auto_find_input_file <- function() {

  flog.info("Trying to auto detect exported file..")

  possible_files = list.files(path = "~/Downloads/", pattern = "Monefy.Data", full.names = T)
  if(length(possible_files) == 0) return(character(0))

  which_latest = possible_files %>%
    stringr::str_extract_all("\\d\\d") %>%
    vapply(function(x) x %>% rev %>% paste(collapse = '') %>% as.numeric(), FUN.VALUE = numeric(1)) %>%
    which.max()

  possible_files[which_latest]
}


#' @export
get_demo_data_file <- function() {
  flog.info("Trying to read demo file..")
  system.file("demo_data/demo_exported.csv", package = "monefystats")
}

#' @export
existing_raw_file_path <- function() {

  flog.info("Running function: existing_raw_file_path")

  input_file_path = auto_find_input_file()

  if(length(input_file_path) == 0) {
    flog.info("Reactive fn: existing_raw_file_path - Auto detect of file failed. Checking for demo data")
    input_file_path = get_demo_data_file()
  }

  input_file_path
}
