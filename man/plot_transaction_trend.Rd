% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stats.R
\name{plot_transaction_trend}
\alias{plot_transaction_trend}
\title{Plot transaction trend}
\usage{
plot_transaction_trend(
  category_to_filter = "all",
  account_to_filter = "all",
  transaction_type_to_filter = "all",
  start_time = NULL,
  end_time = NULL,
  description_pattern = ".*",
  cleaned_file = "expenses_clean.rds",
  bin_by = "month",
  agg_type = "sum"
)
}
\arguments{
\item{category_to_filter}{The Monefy 'category' for which the chart has to be plotted.
This can be a vector of categories to plot for more than one. Also, use 'all' for selecting all categories}

\item{account_to_filter}{The Monefy 'account' for which the chart has to be plotted.
This can be a vector of accounts to plot for more than one. Also, use 'all' for selecting all accounts}

\item{transaction_type_to_filter}{The transaction type for which the chart has to be plotted. This could be either "income" or "expense".
Use 'all' for selecting both - this will consider amount as is, which means expenses will have the value of 'amount' as negative}

\item{start_time}{start time from which histogram should be plotted. Default - start of data}

\item{end_time}{end time from which histogram should be plotted. Default - end of data}

\item{description_pattern}{regex pattern to match transaction description}

\item{cleaned_file}{path to the cleaned and ready to consume file with Monefy data. To create clean file, use \code{\link{read_and_clean_raw_data}}}

\item{bin_by}{the period to bin the aggregation. Default - 'month'}

\item{agg_type}{the type of summary stat to be plotted. One of "sum", "count" or "mean". Default - "sum"}
}
\description{
Plot histogram chart for transaction statistics for a single category in an account over a period of time
}
