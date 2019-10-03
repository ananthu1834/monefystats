
expense_future <- function(expense_current, years, currency_inflation, lifestyle_inflation) {
  currency_inflation_factor = (1+(0.01*currency_inflation))^years
  lifestyle_inflation_factor = (1+(0.01*lifestyle_inflation))^years
  expense_current*currency_inflation_factor*lifestyle_inflation_factor
}

total_expenses_for_period <- function(expense_current, start_year, withdrawal_period, currency_inflation, lifestyle_inflation) {
  years_of_period = start_year:(start_year + withdrawal_period)
  total_expenses = 0
  for (i in years_of_period) total_expenses = total_expenses + expense_future(expense_current, i, currency_inflation, lifestyle_inflation)
  total_expenses
}

total_savings_for_period <- function(expense_current, start_year, withdrawal_period, currency_inflation, lifestyle_inflation, mf_growth, life_expectancy, age_current) {

  if((life_expectancy - age_current) < start_year) return(0)

  total_expenses_next_period = total_expenses_for_period(expense_current, start_year + withdrawal_period, withdrawal_period, currency_inflation, lifestyle_inflation)
  total_savings_next_period = total_savings_for_period(expense_current, start_year + withdrawal_period, withdrawal_period, currency_inflation, lifestyle_inflation, mf_growth, life_expectancy, age_current)

  mf_growth_factor = (1+(0.01*mf_growth))^withdrawal_period
  (total_expenses_next_period + total_savings_next_period)/mf_growth_factor
}

lumpsum_needed_for_ind <- function(expense_current, start_year, withdrawal_period, currency_inflation, lifestyle_inflation, mf_growth, life_expectancy, age_current) {

  total_expenses_start_period = total_expenses_for_period(expense_current, start_year, withdrawal_period, currency_inflation, lifestyle_inflation)
  total_savings_start_period = total_savings_for_period(expense_current, start_year, withdrawal_period, currency_inflation, lifestyle_inflation, mf_growth, life_expectancy, age_current)
  total_savings_start_period + total_expenses_start_period
}

mf_growth_for_sip <- function(start_year, salary_growth, mf_growth) {
  k = 0
  for(i in 1:start_year) k = k + ((1+0.01*salary_growth)^(start_year-i))*(1+0.01*mf_growth)^i
  k
}

#' @export
monthly_investments <- function(expense_current, start_year, withdrawal_period, currency_inflation, lifestyle_inflation, mf_growth, salary_growth, life_expectancy, age_current) {
  lumpsum_needed = lumpsum_needed_for_ind(expense_current, start_year, withdrawal_period, currency_inflation, lifestyle_inflation, mf_growth, life_expectancy, age_current)
  mf_growth_factor = mf_growth_for_sip(start_year, salary_growth, mf_growth)
  (lumpsum_needed/mf_growth_factor)/12
}

