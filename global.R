
# Install dependencies when running shiny::runGithub():
if (!require("remotes")) install.packages("remotes")
remotes::install_deps(dependencies = TRUE)

# -------------------------------------------------------------------------
# Required libraries

library(shiny)
library(ggplot2)
library(bslib)
library(rlang)
library(curl)
library(dplyr)
library(reshape2)
library(tidyr)
library(ggrepel)
library(scales)
library(DT)
library(thematic)
library(colorspace)
library(shinycssloaders)
library(waiter)
library(viridis)
library(plotly)
library(ggh4x)
library(purrr)
library(htmltools)
library(markdown)
library(tibble)
options(shiny.maxRequestSize = 50 * 1024^2) # max object size = 50MB

# -------------------------------------------------------------------------
# Select default MSE or MSE you want to explore

default_MSE = "NALB"
run_locally = TRUE # TRUE = run app locally, FALSE = when deploying on shinyapps.io
# IMPORTANT: never commit run_locally = FALSE to Github repo

# -------------------------------------------------------------------------
# DEPLOYMENT DATA: load ONE independent MSE result once per R worker.
# Choose which result is deployed using default_MSE above.
MSE_GLOBAL = NULL
MSE_PREPROCESSED = NULL

# Extract only the requested slice of the time-series array.
# This avoids melting and storing the complete iteration-level time-series
# array. The function first subsets the array and then melts only the small
# requested subset.
extract_ts_iteration <- function(
    x,
    stocks,
    oms,
    mps,
    variable,
    iteration
) {
  
  # Original time-series array
  arr <- x$timeseries$value
  
  # Check that the array has named dimensions
  dn <- dimnames(arr)
  dim_names <- names(dn)
  
  if (is.null(dim_names) || any(dim_names == "")) {
    stop(
      "x$timeseries$value must have named dimensions. ",
      "Found dimensions: ",
      paste(dim_names, collapse = ", ")
    )
  }
  
  # Dimensions required by the plotting code
  required_dims <- c(
    "Stock",
    "OMs",
    "MPs",
    "Var",
    "Years",
    "Iter"
  )
  
  missing_dims <- setdiff(required_dims, dim_names)
  
  if (length(missing_dims) > 0) {
    stop(
      "Missing dimensions in x$timeseries$value: ",
      paste(missing_dims, collapse = ", ")
    )
  }
  
  # Convert inputs to character because array dimnames are normally character
  stocks <- as.character(stocks)
  oms <- as.character(oms)
  mps <- as.character(mps)
  variable <- as.character(variable)
  iteration <- as.character(iteration)
  
  # Check that requested values exist
  invalid_stocks <- setdiff(stocks, dn[["Stock"]])
  invalid_oms <- setdiff(oms, dn[["OMs"]])
  invalid_mps <- setdiff(mps, dn[["MPs"]])
  invalid_variables <- setdiff(variable, dn[["Var"]])
  
  if (length(invalid_stocks) > 0) {
    stop(
      "Unknown Stock value(s): ",
      paste(invalid_stocks, collapse = ", ")
    )
  }
  
  if (length(invalid_oms) > 0) {
    stop(
      "Unknown OM value(s): ",
      paste(invalid_oms, collapse = ", ")
    )
  }
  
  if (length(invalid_mps) > 0) {
    stop(
      "Unknown MP value(s): ",
      paste(invalid_mps, collapse = ", ")
    )
  }
  
  if (length(invalid_variables) > 0) {
    stop(
      "Unknown time-series variable(s): ",
      paste(invalid_variables, collapse = ", ")
    )
  }
  
  # Iter can be labelled "1", "2", ... or possibly stored differently.
  # First try exact matching against the iteration dimension names.
  iter_index <- match(iteration, dn[["Iter"]])
  
  # If exact character matching fails, try numeric matching.
  if (anyNA(iter_index)) {
    
    iter_numeric <- suppressWarnings(as.numeric(iteration))
    dim_iter_numeric <- suppressWarnings(as.numeric(dn[["Iter"]]))
    
    iter_index <- match(iter_numeric, dim_iter_numeric)
  }
  
  if (anyNA(iter_index)) {
    stop(
      "Requested iteration was not found: ",
      paste(iteration, collapse = ", ")
    )
  }
  
  # Create one index for every array dimension.
  # Unselected dimensions, principally Years, retain all their values.
  index <- lapply(dim(arr), seq_len)
  names(index) <- dim_names
  
  index[["Stock"]] <- match(stocks, dn[["Stock"]])
  index[["OMs"]] <- match(oms, dn[["OMs"]])
  index[["MPs"]] <- match(mps, dn[["MPs"]])
  index[["Var"]] <- match(variable, dn[["Var"]])
  index[["Iter"]] <- iter_index
  
  # Subset before melting. drop = FALSE is essential because it preserves
  # all array dimensions even when only one value is selected.
  arr_subset <- do.call(
    `[`,
    c(
      list(arr),
      unname(index),
      list(drop = FALSE)
    )
  )
  
  # Melt only the requested subset.
  result <- reshape2::melt(
    arr_subset,
    value.name = "value"
  )
  
  # Remove missing elements and restore the factor ordering used elsewhere.
  result <- result |>
    stats::na.omit() |>
    dplyr::mutate(
      Stock = factor(
        Stock,
        levels = x$stocks
      ),
      OMs = factor(
        OMs,
        levels = x$om$metadata$factor[["en"]]$Factor
      ),
      MPs = factor(
        MPs,
        levels = x$mp$metadata[["en"]]$Code
      ),
      Var = factor(
        Var,
        levels = x$timeseries$metadata[["en"]]$Code
      )
    )
  
  result
}

# Produce data objects that depend only on the MSE file. In deployment mode,
# this function is called once per dataset and per R worker, not per session.
preprocess_MSE = function(x) {
  
  ts_dat = reshape2::melt(x$timeseries$value) %>% stats::na.omit()
  
  ts_dat_summ = ts_dat %>%
    dplyr::group_by(Stock, OMs, MPs, Var, Years) %>%
    dplyr::summarise(
      q10 = stats::quantile(value, 0.05),
      q25 = stats::quantile(value, 0.25),
      q50 = stats::quantile(value, 0.50),
      q75 = stats::quantile(value, 0.75),
      q90 = stats::quantile(value, 0.95),
      avg = mean(value), .groups = "drop"
    ) %>%
    dplyr::mutate(
      Stock = factor(Stock, levels = x$stocks), MPs = factor(MPs),
      OMs = factor(OMs, levels = x$om$metadata$factor[["en"]]$Factor),
      Var = factor(Var, levels = x$timeseries$metadata[["en"]]$Code)
    )
  
  ts_dat_hist = ts_dat_summ %>%
    dplyr::filter(Years <= x$timeseries$timenow) %>%
    dplyr::select(-c(MPs, OMs)) %>%
    dplyr::group_by(Stock, Var, Years) %>%
    dplyr::summarise(dplyr::across(dplyr::everything(), mean), .groups = "drop")
  
  # The complete melted table is no longer required.
  # Remove it before Kobe, performance and fleet objects are processed to
  # reduce peak memory during the remainder of preprocessing.
  rm(ts_dat)
  invisible(gc())
  
  tar_lim_dat = data.frame(
    Target = x$timeseries$target, Limit = x$timeseries$limit,
    Var = x$timeseries$metadata[["en"]]$Code
  )
  tar_lim_dat = purrr::map_dfr(
    x$stocks, ~ dplyr::mutate(tar_lim_dat, Stock = .x)
  ) %>% dplyr::mutate(
    Var = factor(Var, levels = x$timeseries$metadata[["en"]]$Code)
  )
  
  kobe_dat = reshape2::melt(x$kobe$value) %>%
    dplyr::mutate(
      Stock = factor(Stock, levels = x$stocks),
      OMs = factor(OMs, levels = x$om$metadata$factor[["en"]]$Factor),
      MPs = factor(MPs)
    ) %>% stats::na.omit()
  
  lst_yr_kobe_dat = kobe_dat %>% dplyr::filter(Years == max(Years))
  
  median_lst_kobe_dat = lst_yr_kobe_dat %>%
    dplyr::group_by(Stock, MPs, OMs, Var) %>%
    dplyr::summarise(value = median(value), .groups = "drop") %>%
    dplyr::mutate(ax_type = dplyr::if_else(
      Var == x$kobe$metadata$Code[1], "x_axis", "y_axis")) %>%
    dplyr::select(-Var) %>% tidyr::pivot_wider(names_from = "ax_type")
  
  median_frs_kobe_dat = kobe_dat %>%
    dplyr::filter(Years == min(Years)) %>%
    dplyr::group_by(Stock, MPs, OMs, Var) %>%
    dplyr::summarise(value = median(value), .groups = "drop") %>%
    dplyr::mutate(ax_type = dplyr::if_else(
      Var == x$kobe$metadata$Code[1], "x_axis", "y_axis")) %>%
    dplyr::select(-Var) %>% tidyr::pivot_wider(names_from = "ax_type")
  
  perf_dat = reshape2::melt(x$pi$value) %>%
    dplyr::mutate(
      Stock = factor(Stock, levels = x$stocks),
      OMs = factor(OMs, levels = x$om$metadata$factor[["en"]]$Factor),
      MPs = factor(MPs)
    ) %>% stats::na.omit()
  
  fleet_dat_summ = reshape2::melt(x$fleet$value) %>% stats::na.omit() %>%
    dplyr::mutate(
      Stock = factor(Stock, levels = x$stocks),
      OMs = factor(OMs, levels = x$om$metadata$factor[["en"]]$Factor),
      MPs = factor(MPs),
      Fleet = factor(Fleet, levels = x$fleet$metadata[["en"]]$Code),
      Var = factor(Var, levels = x$fleet$variables$Code)
    )
  
  list(
    ts_dat_summ = ts_dat_summ,
    ts_dat_hist = ts_dat_hist, tar_lim_dat = tar_lim_dat,
    kobe_dat = kobe_dat, lst_yr_kobe_dat = lst_yr_kobe_dat,
    median_lst_kobe_dat = median_lst_kobe_dat,
    median_frs_kobe_dat = median_frs_kobe_dat,
    perf_dat = perf_dat, fleet_dat_summ = fleet_dat_summ
  )
}

if (!isTRUE(run_locally)) {
  mse_path = file.path("data", paste0(default_MSE, ".flbeia"))
  if (!file.exists(mse_path)) stop("FLBEIA dataset not found: ", mse_path)
  MSE_GLOBAL = readRDS(mse_path)
  MSE_PREPROCESSED = preprocess_MSE(MSE_GLOBAL)
  message("Loaded only ", default_MSE, ": object = ",
          round(as.numeric(object.size(MSE_GLOBAL))/1024^2,1), " MB; preprocessed = ",
          round(as.numeric(object.size(MSE_PREPROCESSED))/1024^2,1), " MB")
  invisible(gc())
}

# -------------------------------------------------------------------------
# -------------------------------------------------------------------------
# Enlarged auto fonts
thematic::thematic_shiny(
  font = thematic::font_spec("auto", scale = 2, update = TRUE)
)

# Set theme for ggplot
set_theme(theme_bw())

# Source translations
source("R/translations.R")

# Create reactive values for selected language
lang_reactive <- reactiveVal("English")

# -------------------------------------------------------------------------
# Define download resolution and dimensions
dwn_units = "mm"
dwn_width = 250 
dwn_height = 130
dwn_res = 300

# Just placeholders:
ts_var_sett_title = ""
mp_sett_title = ""
pi_sett_title = ""
fleet_sett_title = ""
om_sett_title = ""
oth_sett_title = ""

# AZTI Color:
azti_col = "#FCDA01"
# Loading icon in shinycssloaders:
load_img_type = 8
# Plot area height:
plot_height = "600px"
# Facet title font size:
fct_ttl_sz = 16
# Axes label font size:
axs_lbl_sz = 16
# Axes ticks text size:
axs_sz = 15
# Repel text size MP labels:
rpl_sz = 5

# -------------------------------------------------------------------------
# Define theme:
theme <- bs_theme(
  version = 5,
  # Controls the default grayscale palette
  bg = "#FFFFFF", fg = "#000000",
  navbar_bg = "#FFFFFF", navbar_fg = "#000000",
  # Controls the accent (e.g., hyperlink, button, etc) colors
  primary = azti_col, secondary = "#000000",
  base_font = font_google("Inter"),
  code_font = c("Courier", "monospace"),
  heading_font = font_google("Inter"),
  font_scale = 1,
  "accordion-button-bg" = "#000000",   # Header background
  "accordion-button-color" = "white"   # Header text color
) %>% 
  bs_add_variables(
    "badge-font-size" = "200%"
  ) %>%
  bs_add_rules(
    "
      .card-header-main {
         background-color: #000000 !important;
         color: white;
         height: 65px;
         font-size: 25px !important;
      }
      "
  )