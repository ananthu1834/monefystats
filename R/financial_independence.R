
.compounding_factor <- function(rate, years) (1+(0.01*rate))^years

.currency_inflation_factor <- function(currency_inflation, years) .compounding_factor(currency_inflation, years)
.lifestyle_inflation_factor <- function(lifestyle_inflation, years) .compounding_factor(lifestyle_inflation, years)
.mf_growth_factor <- function(mf_growth, years) .compounding_factor(mf_growth, years)

.mf_growth_factor_for_sip <- function(mf_growth, years, sip_growth = 0) {
  total = 0
  for(i in 1:years) total = total + ((1+0.01*sip_growth)^(years-i))*(1+0.01*mf_growth)^i
  total
}

future_expense <- function(current_expense, years, currency_inflation, lifestyle_inflation) {
  current_expense * .currency_inflation_factor(currency_inflation, years) * .lifestyle_inflation_factor(lifestyle_inflation, years)
}

total_expenses_for_period <- function(current_monthly_expense, start_year, withdrawal_period, currency_inflation, lifestyle_inflation) {
  years_of_period = start_year:(start_year + withdrawal_period)
  total_expenses = 0
  for (i in years_of_period) total_expenses = total_expenses + 12*future_expense(current_monthly_expense, i, currency_inflation, lifestyle_inflation)
  total_expenses
}

total_savings_for_period <- function(current_monthly_expense, start_year, withdrawal_period, currency_inflation, lifestyle_inflation, mf_growth, life_expectancy, age_current) {

  if((life_expectancy - age_current) < (start_year + withdrawal_period)) return(0)

  total_expenses_next_period = total_expenses_for_period(current_monthly_expense, start_year + withdrawal_period, withdrawal_period, currency_inflation, lifestyle_inflation)
  total_savings_next_period = total_savings_for_period(current_monthly_expense, start_year + withdrawal_period, withdrawal_period, currency_inflation, lifestyle_inflation, mf_growth, life_expectancy, age_current)

  mf_growth_factor = .mf_growth_factor(mf_growth, withdrawal_period)
  (total_expenses_next_period + total_savings_next_period)/mf_growth_factor
}

lumpsum_needed_for_ind <- function(current_monthly_expense, start_year, withdrawal_period, currency_inflation, lifestyle_inflation, mf_growth, life_expectancy, age_current) {

  total_expenses_start_period = total_expenses_for_period(current_monthly_expense, start_year, withdrawal_period, currency_inflation, lifestyle_inflation)
  total_savings_start_period = total_savings_for_period(current_monthly_expense, start_year, withdrawal_period, currency_inflation, lifestyle_inflation, mf_growth, life_expectancy, age_current)
  total_savings_start_period + total_expenses_start_period
}

#' @title Monthly inestment for Financial Independence
#' @description Get monthly investment needed into mutual funds as of now for achieving fin independence by a given period of time.
#' Returns the monthly investment needed for the current year. And if sip_growth > 0, this means the monthly investment is planned to increase by the same every year (maybe due to more earning, inflation etc)
#' @export
monthly_investments_till_financial_independence <- function(current_monthly_expense, start_year, withdrawal_period,
                                                            currency_inflation, lifestyle_inflation, mf_growth,
                                                            sip_growth, life_expectancy, age_current) {

  lumpsum_needed = lumpsum_needed_for_ind(current_monthly_expense, start_year, withdrawal_period, currency_inflation, lifestyle_inflation, mf_growth, life_expectancy, age_current)
  mf_growth_factor = .mf_growth_factor_for_sip(mf_growth, start_year, sip_growth)

  list(monthly_investment = (lumpsum_needed/mf_growth_factor)/12,
       lumpsum_needed_at_beginning_of_start_year = lumpsum_needed)
}

