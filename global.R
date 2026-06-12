
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

# -------------------------------------------------------------------------
# Select default MSE or MSE you want to explore

default_MSE = "NALB"
run_locally = TRUE # TRUE = run app locally, FALSE = when deploying on shinyapps.io


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