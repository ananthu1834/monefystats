#' @import ggplot2

#' @export
plot_expense_trend <- function(category_to_plot, account_to_filter = 'Expenses-Regular', bin_by = 'month', file = 'expenses_clean.rds', agg_type = 'sum') {

  clean_data = readRDS(file)

  plot_data = clean_data %>% filter(account == account_to_filter, category %in% category_to_plot) %>%
    mutate_(.dots = setNames("lubridate::floor_date(date, bin_by)", bin_by)) %>%
    group_by_(bin_by) %>%
    summarise_(.dots = setNames("aggregate_expenses(amount, agg_type)", agg_type)) %>%
    ungroup()

  ggplot() + geom_bar(aes(x = plot_data[[bin_by]], y = plot_data[[agg_type]]), stat = 'identity', fill = 'steelblue')
}

aggregate_expenses <- function(amount, agg_type) {

  if(agg_type == 'sum') return(sum(amount))
  if(agg_type == 'mean') return(mean(amount))
  if(agg_type == 'count') return(length(amount))
}

