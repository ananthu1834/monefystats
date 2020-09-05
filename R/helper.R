
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

  possible_files = list.files(path = "~/Downloads/", pattern = "Monefy.Data", full.names = T)
  if(length(possible_files) == 0) return(character(0))

  which_latest = possible_files %>%
    stringr::str_extract_all("\\d\\d") %>%
    vapply(function(x) x %>% rev %>% paste(collapse = '') %>% as.numeric(), FUN.VALUE = numeric(1)) %>%
    which.max()

  possible_files[which_latest]
}
