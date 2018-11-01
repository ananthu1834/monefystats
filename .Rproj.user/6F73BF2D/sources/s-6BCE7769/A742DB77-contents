#' @import dplyr
#' @import stringr

#' @export
read_and_clean <- function(file) {

  raw_data <- read.csv(file, stringsAsFactors = F)

  clean_data <- raw_data %>%
    select(date, account, category, amount, description) %>%
    clean_dates() %>%
    clean_amount()

  saveRDS(clean_data, 'expenses_clean.rds')
}

clean_dates <- . %>% mutate(date = as.POSIXct(strptime(date, format = '%d/%m/%Y')))

clean_amount <- . %>% mutate(amount = as.numeric(str_replace_all(amount, ',', ''))*-1)
