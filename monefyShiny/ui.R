library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(dplyr)

header <- dashboardHeader(
    titleWidth = 350,
    title = "Monefy Stats",
    dropdownMenu(
        type = "messages",
        icon = icon("cog")
    )
)

transaction_trend_plot_sum = box(
    title = "Transaction Trend (sum)",
    status = "primary",
    width = 12,
    solidHeader = TRUE,
    collapsible = FALSE,
    plotOutput("transaction_plot_sum", height = "200px") %>% withSpinner(color="#0dc5c1"),
    br()
)

transaction_trend_plot_mean = box(
    title = "Transaction Trend (mean)",
    status = "primary",
    width = 12,
    solidHeader = TRUE,
    collapsible = FALSE,
    plotOutput("transaction_plot_mean", height = "200px") %>% withSpinner(color="#0dc5c1"),
    br()
)

transaction_trend_plot_count = box(
    title = "Transaction Trend (count)",
    status = "primary",
    width = 12,
    solidHeader = TRUE,
    collapsible = FALSE,
    plotOutput("transaction_plot_count", height = "200px") %>% withSpinner(color="#0dc5c1"),
    br()
)

body <- dashboardBody(
    fluidPage(
        transaction_trend_plot_sum,
        transaction_trend_plot_mean,
        transaction_trend_plot_count
    )
)

sidebar <- dashboardSidebar(
    width = 350,
    selectInput("decimal_separator", label = h4("Select Decimal Separator for CSV"),
                choices = c(",", "."),
                selected = "."),
    selectInput("delimiter_character", label = h4("Select Delimiter Character for CSV"),
                choices = c(";", ","),
                selected = ","),
    fileInput("exported_file",
              label = h4("Monefy exported csv file path"),
              buttonLabel = "Choose CSV file",
              accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv"),
              placeholder = if_else(length(auto_find_input_file()) == 0,
                                    "File not chosen",
                                    stringr::str_interp("Auto detected file: ${auto_find_input_file()}"))),
    uiOutput('account_filter'),
    uiOutput('category_filter'),
    uiOutput('range_filter'),
    selectInput("transaction_type", label = h4("Select Transaction Type"),
                choices = c("expense", "income", "all"),
                selected = "expense"),
    selectInput("bin_by", label = h4("Select period to bin by"),
                choices = c("second", "minute", "hour", "day", "week", "month", "bimonth", "quarter", "season", "halfyear", "year"),
                selected = "month")
)

dashboardPage(header, sidebar, body)
