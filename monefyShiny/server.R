
plot_transaction_trend_shiny <- function(input, cleaned_file, agg_type) {

    flog.info(str_interp("Plotting transaction trend for aggregation type: ${agg_type}"))
    plot_transaction_trend(category_to_filter = input$category,
                           account_to_filter = input$account,
                           start_time = input$date_range[1] %>% as.POSIXct(),
                           end_time = input$date_range[2] %>% as.POSIXct(),
                           bin_by = input$bin_by,
                           cleaned_file = cleaned_file,
                           transaction_type_to_filter = input$transaction_type,
                           description_pattern = input$description_pattern,
                           agg_type = agg_type)
}

filter_relevant_data <- function(df, input) {

    flog.info("Filtering out relevant clean data..")
    df %>% get_relevant_input_data(category_to_filter = input$category,
                                   account_to_filter = input$account,
                                   start_time = input$date_range[1],
                                   end_time = input$date_range[2],
                                   transaction_type_to_filter = input$transaction_type,
                                   description_pattern = input$description_pattern)
}

function(input, output, session) {

    raw_file_path <- reactive({

        flog.info("Running function: raw_file_path")

        input_file_path = existing_raw_file_path()

        if(length(input_file_path) == 0) {
            flog.info("Reactive fn: raw_file_path - Fetching existing file/demo data failed. Waiting for input")
            req(input$exported_file)
        }

        if(!is.null(input$exported_file$datapath)) input_file_path = input$exported_file$datapath

        flog.info(str_interp("Exported file path: ${input_file_path}"))
        input_file_path
    })

    clean_file_path <- reactive({

        flog.info("Running function: clean_file_path")
        read_and_clean_raw_data(delimiter_character = input$delimiter_character, decimal_separator = input$decimal_separator, file = raw_file_path())
    })

    output$transaction_plot_sum <- renderPlot({
        req(input$account)
        req(input$category)
        req(input$description_pattern)
        req(input$date_range)
        plot_transaction_trend_shiny(input, cleaned_file = clean_file_path(), agg_type = "sum")
    })

    output$transaction_plot_mean <- renderPlot({
        req(input$account)
        req(input$category)
        req(input$description_pattern)
        plot_transaction_trend_shiny(input, cleaned_file = clean_file_path(), agg_type = "mean")
    })

    output$transaction_plot_count <- renderPlot({
        req(input$account)
        req(input$category)
        req(input$description_pattern)
        plot_transaction_trend_shiny(input, cleaned_file = clean_file_path(), agg_type = "count")
    })

    output$account_filter <- renderUI({
        all_accounts = get_all_accounts(file = clean_file_path())
        selectInput("account", label = h4("Select Account"),
                    choices = c(all_accounts, "all"),
                    multiple = T,
                    selected = all_accounts[[1]])
    })

    output$category_filter <- renderUI({
        req(input$account)
        all_categories_for_account = get_all_categories_for_account(file = clean_file_path(), account_to_filter = input$account)
        selectInput("category", label = h4("Select Category"),
                    choices = c(all_categories_for_account, "all"),
                    multiple = T,
                    selected = all_categories_for_account[[1]])
    })

    output$range_filter <- renderUI({
        date_range = get_date_range(file = clean_file_path())
        dateRangeInput("date_range", h4("Date Range:"),
                       start = date_range[[1]], end = date_range[[2]],
                       min = NULL, max = NULL,
                       format = "yyyy-mm-dd", startview = "month", weekstart = 0,
                       language = "en", width = NULL)
    })

    output$description_filter <- renderUI({
        req(input$account)
        req(input$category)
        textInput("description_pattern",
                  label = h4("Regex match transaction description"),
                  value = ".*",
                  placeholder = "Add Regex pattern. For eg: .*kfc.*")
    })

    output$raw_data <- DT::renderDT({
        DT::datatable(read.csv(raw_file_path(), sep = input$delimiter_character, dec = input$decimal_separator),
                      options = list(scrollX = TRUE))
    })

    output$clean_data <- DT::renderDT({
        DT::datatable(readRDS(clean_file_path()) %>% filter_relevant_data(input),
                      options = list(scrollX = TRUE))
    })
}

