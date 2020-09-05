
plot_transaction_trend_shiny <- function(input, cleaned_file, agg_type) {
    plot_transaction_trend(category_to_filter = input$category,
                           account_to_filter = input$account,
                           start_time = input$date_range[1],
                           end_time = input$date_range[2],
                           bin_by = input$bin_by,
                           cleaned_file = cleaned_file,
                           transaction_type_to_filter = input$transaction_type)
}

function(input, output, session) {

    clean_file_path <- reactive({
        input_file_path = auto_find_input_file()
        if(length(input_file_path) == 0) req(input$exported_file)
        if(!is.null(input$exported_file$datapath)) input_file_path = input$exported_file$datapath
        read_and_clean_raw_data(delimiter_character = input$delimiter_character, decimal_separator = input$decimal_separator, file = input_file_path)
    })

    output$transaction_plot_sum <- renderPlot({
        plot_transaction_trend_shiny(input, cleaned_file = clean_file_path(), agg_type = "sum")
    })

    output$transaction_plot_mean <- renderPlot({
        plot_transaction_trend_shiny(input, cleaned_file = clean_file_path(), agg_type = "mean")
    })

    output$transaction_plot_count <- renderPlot({
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

}

