# FLBEIA Shiny App

This is the source code of the FLBEIA Shiny App, designed to explore results from Management Strategy Evaluations (MSE).

An URL link should be provided by the MSE developers to the interested audience in order to access the Shiny App with loaded MSE results.

For R users, the Shiny App can also be run locally following these steps:

### 1. Clone or Download This Repository

If you are familiar with Github, clone this repository on your computer.

If you are not familiar with Github, download this repository by clicking the green button "Code", and then "Download ZIP".

### 2. Open Project on RStudio

Open the R project (.Rproj) in RStudio (or any other IDE).

### 3. Install Required R packages

See the `global.R` script. Make sure to install all the R packages used in this Shiny App.

### 4. Select MSE Results

Select the MSE results you want to explore in the second section of the `global.R` file:

- `default_MSE = ALB`: North Atlantic Albacore MSE
- `default_MSE = SKJ`: Single-stock Eastern Atlantic Skipjack MSE
- `default_MSE = BET`: Single-stock Atlantic Bigeye MSE
- `default_MSE = YFT`: Single-stock Atlantic Yellowfin MSE
- `default_MSE = TT`: Multi-stock Atlantic Tropical Tunas MSE

### 5. Run App

Make sure that `run_locally = TRUE` in the second section of the `global.R` file. Then, run `shiny::runApp()` in the R console to run the App locally. 