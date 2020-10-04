#' @import dplyr
#' @import stringr
#' @import futile.logger

#' @title Read and clean raw Monefy exported csv
#' @title Read, clean and write Monefy exported csv data to an rds file
#' @param file path to the raw csv exported from monefy app
#' @param delimer_character delimiter character chosen during export
#' @param decimal_separator decimal separator chosen during export
#' @param write_path path to write the cleaned rds file into
#' @export
read_and_clean_raw_data <- function(file, delimiter_character = ",", decimal_separator = ".", write_path = 'expenses_clean.rds') {

  raw_data = read_raw_exported_file(file, delimiter_character = delimiter_character, decimal_separator = decimal_separator)

  clean_data <- raw_data %>%
    select(date, account, category, amount, description) %>%
    clean_dates() %>%
    clean_amount() %>%
    add_transaction_type()

  saveRDS(clean_data, write_path)

  return(normalizePath(write_path))
}

read_raw_exported_file <- function(file, delimiter_character = ",", decimal_separator = ".") {

  tryCatch({
    raw_data = read.csv(file, stringsAsFactors = F, dec = decimal_separator, sep = delimiter_character)
  },
  error = function(e) {
    if(stringr::str_detect(e$message, "more columns than column names")) {
      stop("Got the followiing error trying to read exported csv: '", e$message,
           "'. Are you sure the 'delimiter_character' and 'decimal_separator' are correct?")
    } else {
      stop(e$message)
    }
  })

  return(raw_data)
}

clean_dates <- . %>% mutate(date = as.POSIXct(strptime(date, format = '%d/%m/%Y')))

clean_amount <- . %>% mutate(amount = as.numeric(str_replace_all(amount, ',', '')))

add_transaction_type <- . %>% mutate(transaction_type = if_else(amount > 0, true = "income", false = "expense"))

