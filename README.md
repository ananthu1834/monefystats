<h1>
  Monefy Stats
</h1>

Package to visualize Monefy transaction data

### Introduction

Monefy Stats is a simple package to visualize Monefy transaction data over a period of time. This is an additional layer on top of existing Monefy features.
Monefy android app has been of great help to me with its amazing and simple UI/UX, along with elegant abstractions. The only thing i wish it has in addition to this is a way to visualize trends, so i created this package to help with the same

### Installation

Not yet available on cran. Can be installed using `devtools`

```{r}
devtools::install_github('ananthu1834/monefystats')
```
### Usage

The package uses csv data exported by the Monefy app. I could not find any APIs to get this data directly, so please inform me if someone know about it and I can add the capability to do so.

Here is an example of how data can be visualized for a period of time.

```{r}
plot_transaction_trend(category_to_filter = "Eating out",
                       account_to_filter = "all",
                       transaction_type_to_filter  = "expense",
                       start_time = "2019-08-01",
                       end_time = "2020-01-01",
                       bin_by = "week",
                       agg_type = "sum")
```

<img src="https://raw.githubusercontent.com/ananthu1834/monefystats/master/man/figures/trend.png" width="500" /> 
