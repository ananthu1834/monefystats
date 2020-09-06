library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(dplyr)
library(monefystats)


dashboardpage_skin = "green"

plot_box_config = list(
    title = "Transaction Trend",
    status = "success",
    width = 12,
    height = "200px",
    spinner_color = "#228B22",
    solidHeader = TRUE,
    collapsible = FALSE)

header <- dashboardHeader(
    titleWidth = 350,
    title = "Monefy Stats"
)

transaction_trend_plot_sum = box(
    title = paste0(plot_box_config$title, " (sum)"),
    status = plot_box_config$status,
    width = plot_box_config$width,
    solidHeader = plot_box_config$solidHeader,
    collapsible = plot_box_config$collapsible,
    plotOutput("transaction_plot_sum", height = plot_box_config$height) %>% withSpinner(color=plot_box_config$spinner_color),
    br()
)

transaction_trend_plot_mean = box(
    title = paste0(plot_box_config$title, " (mean)"),
    status = plot_box_config$status,
    width = plot_box_config$width,
    solidHeader = plot_box_config$solidHeader,
    collapsible = plot_box_config$collapsible,
    plotOutput("transaction_plot_mean", height = plot_box_config$height) %>% withSpinner(color=plot_box_config$spinner_color),
    br()
)

transaction_trend_plot_count = box(
    title = paste0(plot_box_config$title, " (count)"),
    status = plot_box_config$status,
    width = plot_box_config$width,
    solidHeader = plot_box_config$solidHeader,
    collapsible = plot_box_config$collapsible,
    plotOutput("transaction_plot_count", height = plot_box_config$height) %>% withSpinner(color=plot_box_config$spinner_color),
    br()
)

body <- dashboardBody(
    div(class = "span",
        tabsetPanel(
            id = "Reiter",
            tabPanel("Trend Plots", value = "tab_trend",
                     fluidPage(
                         transaction_trend_plot_sum,
                         transaction_trend_plot_mean,
                         transaction_trend_plot_count
                     )
            ),
            tabPanel("Parsed Data", value = "tab_parsed_data",
                     DT::DTOutput("clean_data")
            ),
            tabPanel("Raw Data", value = "tab_raw_data",
                     fluidRow(
                         verbatimTextOutput("summary"),
                         DT::DTOutput("raw_data")
                     )
            )
        )
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
    uiOutput('description_filter'),
    selectInput("transaction_type", label = h4("Select Transaction Type"),
                choices = c("expense", "income", "all"),
                selected = "expense"),
    selectInput("bin_by", label = h4("Select period to bin by"),
                choices = c("day", "week", "month", "bimonth", "quarter", "season", "halfyear", "year"),
                selected = "month")
)

dashboardPage(header, sidebar, body, skin = dashboardpage_skin)
