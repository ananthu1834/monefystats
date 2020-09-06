<h1>
  Monefy Stats
</h1>

Package to visualize Monefy transaction data

### Introduction

Monefy Stats is a simple package to visualize Monefy transaction data over a period of time. This is an additional layer on top of existing Monefy features.
Monefy android app has been of great help to me with its amazing and simple UI/UX, along with elegant abstractions. But I wish it had a few more statistics and trend plots to help me get more insights into the data. Hence this package and the Shiny App

### Installation

Not yet available on cran. Can be installed using `devtools`

```{r}
devtools::install_github('ananthu1834/monefystats')
```
### Usage

The package uses csv data exported by the Monefy app. I could not find any APIs to get this data directly, so please inform me if someone know about it and I can add the capability to do so.

Here is an example screenshot to get a sense of what the app looks like (will add a demo soon). Run the follwoing command to get it running on your system

```{r}
runApp('monefyShiny')
```

<img src="https://raw.githubusercontent.com/ananthu1834/monefystats/master/man/figures/shiny_dashboard.png" width="800" /> 
