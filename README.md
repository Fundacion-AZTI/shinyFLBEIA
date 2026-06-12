# FLBEIA Shiny App

This is the source code of the FLBEIA Shiny App, designed to explore results from Management Strategy Evaluations (MSE).

An URL link should be provided by the MSE developers to the interested audience in order to access the Shiny App with loaded MSE results.

For R users, the Shiny App can also be run locally in two recommended ways presented below.

### 1. Using Github

If you are familiar with Github, follow these steps: 

- Clone this repository
- Open the project: `shinyFLBEIA.Rproj` in Rstudio or any other IDE
- Run `shiny::runApp()` (make sure you have the `shiny` R package installed)

### 2. Using R only

You only need to run the following line in R:

`shiny::runGithub("shinyFLBEIA", "Fundacion-AZTI")`

Regardless the method you choose to run the app locally, the first thing you will be asked is to upload the MSE results (`.flbeia` file). The MSE developers should provide you that file.