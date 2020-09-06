#' @import ggplot2

#' @title Plot transaction trend
#' @description Plot histogram chart for transaction statistics for a single category in an account over a period of time
#' @param category_to_filter The Monefy 'category' for which the chart has to be plotted.
#' This can be a vector of categories to plot for more than one. Also, use 'all' for selecting all categories
#' @param account_to_filter The Monefy 'account' for which the chart has to be plotted.
#' This can be a vector of accounts to plot for more than one. Also, use 'all' for selecting all accounts
#' @param transaction_type_to_filter The transaction type for which the chart has to be plotted. This could be either "income" or "expense".
#' Use 'all' for selecting both - this will consider amount as is, which means expenses will have the value of 'amount' as negative
#' @param start_time start time from which histogram should be plotted. Default - start of data
#' @param end_time end time from which histogram should be plotted. Default - end of data
#' @param description_pattern regex pattern to match transaction description
#' @param cleaned_file path to the cleaned and ready to consume file with Monefy data. To create clean file, use \code{\link{read_and_clean_raw_data}}
#' @param bin_by the period to bin the aggregation. Default - 'month'
#' @param agg_type the type of summary stat to be plotted. One of "sum", "count" or "mean". Default - "sum"
#' @export
plot_transaction_trend <- function(category_to_filter = "all",
                                   account_to_filter = 'all',
                                   transaction_type_to_filter = "all",
                                   start_time = NULL,
                                   end_time = NULL,
                                   description_pattern = ".*",
                                   cleaned_file = 'expenses_clean.rds',
                                   bin_by = 'month',
                                   agg_type = 'sum') {

  clean_data = readRDS(cleaned_file)

  relevant_data = get_relevant_input_data(clean_data, category_to_filter, account_to_filter, transaction_type_to_filter, start_time, end_time, description_pattern)

  df_to_plot = get_stats_trend_to_plot(relevant_data, bin_by, agg_type)

  mean_value = df_to_plot$agg %>% mean(na.rm = T)
  median_value = df_to_plot$agg %>% median(na.rm = T)

  ggplot() +
    geom_bar(aes(x = df_to_plot[['time_bin']], y = df_to_plot[['agg']]), stat = 'identity', fill = 'indianred2') +
    xlab("Time") + ylab(stringr::str_interp("${paste0(category_to_filter, collapse = ', ')} (${agg_type})")) +
    theme(axis.text.x = element_text(face="bold", size=10),
          axis.text.y = element_text(face="bold", size=10),
          text = element_text(face="bold", size=10)) +
    geom_hline(aes(yintercept = mean_value, linetype = "Mean (per bin) for the period"), color = "steelblue3") +
    geom_hline(aes(yintercept = median_value, linetype = "Median (per bin) for the period"),  color = "olivedrab4") +
    scale_linetype_manual(name = "Statistics", values = c(2,2), guide = guide_legend(override.aes = list(color = c("steelblue3", "olivedrab4")))) #+
    # scale_y_continuous(breaks = sort(c(.get_y_axis_scale_units(df_to_plot), mean_value, median_value)))

}

.get_y_axis_scale_units <- function(df_to_plot) {
  max_value = df_to_plot$agg %>% max(na.rm = T)
  scale_limit_10s = max_value %>% log10() %>% ceiling() %>% `^`(10, .)
  scale_limit_5s = scale_limit_10s/2
  scale_limit = if_else(max_value > scale_limit_5s, scale_limit_10s, scale_limit_5s)
  seq(0, scale_limit, length.out = 5)
}

aggregate_expenses <- function(amount, agg_type) {

  if(agg_type == 'sum') return(sum(amount))
  if(agg_type == 'mean') return(mean(amount))
  if(agg_type == 'count') return(length(amount))
}

get_stats_trend_to_plot <- function(relevant_data, bin_by, agg_type) {
  relevant_data %>%
    mutate(time_bin = lubridate::floor_date(date, bin_by)) %>%
    group_by(time_bin) %>%
    summarise(agg = aggregate_expenses(amount, agg_type)) %>%
    ungroup() %>%
    data.frame()
}

#' @export
get_relevant_input_data <- function(clean_data, category_to_filter, account_to_filter, transaction_type_to_filter, start_time, end_time, description_pattern) {
  clean_data %>%
    filter_for_account(account_to_filter) %>%
    filter_for_category(category_to_filter) %>%
    filter_for_transaction_type(transaction_type_to_filter) %>%
    filter_for_time_range(start_time, end_time) %>%
    filter_for_description(description_pattern)
}

filter_for_transaction_type <- function(df, transaction_type_to_filter) {

  if("all" %in% transaction_type_to_filter) return(df)
  if(!all(transaction_type_to_filter %in% c("income", "expense"))) stop("Unknown transaction type filters. Should only have these vlaues - 'all', 'income' or 'expense'")

  df %>%
    filter(transaction_type %in% transaction_type_to_filter) %>%
    mutate(amount = abs(amount))
}

filter_for_category <- function(df, category_to_filter) {

  if("all" %in% category_to_filter) return(df)
  all_categories = get_all_categories(df = df)
  if(!all(category_to_filter %in% all_categories)) {
    stop(stringr::str_interp("Unknown category filters. Should only have these vlaues - ${paste0(all_categories, collapse = ', ')}"))
  }

  df %>% filter(category %in% category_to_filter)
}

filter_for_account <- function(df, account_to_filter) {

  if("all" %in% account_to_filter) return(df)
  all_accounts = get_all_accounts(df = df)
  if(!all(account_to_filter %in% all_accounts)) {
    stop(stringr::str_interp("Unknown account filters. Should only have these vlaues - ${paste0(all_accounts, collapse = ', ')}"))
  }
  df %>% filter(account %in% account_to_filter)
}

filter_for_time_range <- function(df, start_time, end_time) {

  if(is.null(start_time)) start_time = min(df$date)
  if(is.null(end_time)) end_time = max(df$date)

  df %>% filter(date >= start_time, date <= end_time)
}

filter_for_description <- function(df, description_pattern) {

  df %>% filter(stringr::str_detect(description, description_pattern))
}
