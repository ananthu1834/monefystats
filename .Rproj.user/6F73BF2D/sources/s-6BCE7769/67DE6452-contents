
#' @export
all_categories <- function(file = 'expenses_clean.rds', df = NULL) give_uniques(file, df, 'category')

#' @export
all_accounts <- function(file = 'expenses_clean.rds', df = NULL) give_uniques(file, df, 'account')

give_uniques <- function(file = 'expenses_clean.rds', df = NULL, col) {
  if(is.null(df)) df = readRDS(file)
  df[[col]] %>% unique()
}
