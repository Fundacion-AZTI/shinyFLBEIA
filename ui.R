ui = fluidPage( 
  title = "FLBEIA Shiny App",

  # Initialize waiter
  use_waiter(),
  
  page_navbar(
  
  theme = theme,
  title = tags$a(
      href = "https://flbeia.azti.es/",
      target = "_blank",
      rel = "noopener",
      tags$img(
        src = "FLBEIA.png",
        width = "150px",
        style = "margin:0px 0px -10px 0px"
      ),
      tags$span("") # Empty text title
    ),
  id = "navbar",
  fillable_mobile = TRUE,
  footer = 
    tags$div(
      style = "text-align: center; color: #FFFFFF; padding: 10px; font-size: 10px; 
      background-color: #000000; border-top: 1px solid #000000;",
      tags$a(
        href = "https://azti.es/",
        target = "_blank",
        rel = "noopener",
        tags$img(
          src = "__AZTI_secundario_BlancoAmarillo.png",
          height = "37px"
        ),
        tags$span("") # Empty text title
      ),
      tags$br(),
      "© 2026 AZTI. All rights reserved."
    ),
  
  # Custom CSS to change font size of nav_panel titles
  tags$head(
    tags$link(rel = "icon", type = "image/svg+xml", href = "azti.svg"),
    tags$style(HTML("
      /* Make switch wider */
      .form-switch .form-check-input {
        width: 3.5em;
        height: 1.8em;
        position: relative;
      }
      .nav-link {
        font-size: 18px; /* Adjust size here */
        color: black;
        font-weight: 400;
      }
      .nav-link.active {
        font-weight: bold !important;
        border-bottom-color: #FCDA01 !important;
      }
      .accordion-button {
        font-weight: bold;
      }
      /* Accordion arrow color */
      .accordion-button::after {
        background-image: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16' fill='%23FCDA01'%3E%3Cpath fill-rule='evenodd' d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3E%3C/svg%3E\");
      }
      /* Accordion Body */
      .accordion-body {
        background-color: #000000;
        color: #FFFFFF;
      }
      /* Change body background for only this accordion */
      .info-accordion .accordion-body {
        background-color: #FFFFFF;
      }
      .scrollable-popover {
        max-width: 600px !important;
        width: 600px !important;
      }
     .scrollable-popover .popover-body {
        max-height: 400px; /* Set your desired maximum height */
        overflow-y: auto;  /* Enable vertical scroll */
        overflow-x: hidden; /* Hide horizontal scroll */
     }
     /* Tick marks */
     .irs-grid-pol {
        background: #FCDA01 !important;
     }
     /* Tick labels */
     .irs-grid-text {
        color: #FCDA01 !important;
     }
     /* Popover background color */
      .popover-header {
        background-color: white !important;
        color: #000000 !important;
        font-weight: bold;
        font-size: 20px;
      }
      /* Card border color */
      .my-card {
        border: 2px solid #000000 !important;
      }
      /* Title font type sidebar */
      .sidebar .sidebar-title {
        font-weight: bold;
        font-size: 23px;
      }
    /* Tooltip */
      .tooltip-inner {
        max-width: 550px !important;  /* Increase width */
        width: 550px;
        text-align: left;             /* Optional */
      }
      .tooltip.show {
        opacity: 1 !important;
      }
      /* Change colors of actionButton */
      .btn {
        border-color: #FFFFFF;
      }
      .btn:hover {
        background-color: #FCDA01;
        border-color: #FCDA01;
      }
    /* Change font color of card title tabs */
    .nav-tabs .nav-link {
      color: #000000 !important;
      font-weight: 400;
    }
    /* Active tab */
    .nav-tabs .nav-link.active {
      color: #000000 !important;
      font-weight: bold !important;
    }
    /* Button MP group */
    .my-gr-btn {
      border-color: #FCDA01;
      color: #FCDA01;
      padding: 1px 3px;
    }
    .my-gr-btn:hover {
      background-color: #FCDA01;
      color: #000000
    }
    /* Update Plot button */
    .my-updt-btn {
      border-color: #FCDA01;
      background-color: #FCDA01;
      color: #000000;
      padding: 3px 5px;
      font-weight: bold !important;
      font-size: 17px;
      margin-top: 5px;
      margin-bottom: 10px;
    }
    .my-updt-btn:hover {
      background-color: #FFFFFF;
      color: #000000
    }
    /* Selected item background */
    .selectize-control.multi .selectize-input > div {
      background-color: #FCDA01 !important;
      color: black !important;
    }
    /* Dropdown selected option */
    .selectize-dropdown .active {
      background-color: #FCDA01 !important;
      color: black !important;
    }
    .selectize-dropdown .option.selected {
      background-color: #FCDA01 !important;
      color: black !important;
    }
      /* Change the filled track color Slider */
      .irs-bar {
        background: #FCDA01 !important;
        border-top: 1px solid #FCDA01 !important;
        border-bottom: 1px solid #FCDA01 !important;
      }
      /* Remove gray ticked line Slider */
      .irs-line {
        background: none !important;
        border: none !important;
      }
      /* Change the slider handle color */
      .irs-handle {
        background: #FCDA01 !important;
        border: 1px solid #FCDA01 !important;
      }
      /* Left value Slider */
      .irs-from {
        color: black !important;
        background: #FCDA01 !important;
      }
      /* Right value Slider */
      .irs-to {
        color: black !important;
        background: #FCDA01 !important;
      }
      /* If using single slider */
      .irs-single {
        color: black !important;
        background: #FCDA01 !important;
      }
      
      /* Download buttons below plots */
      .btn-dwn {
        background-color: #000000; 
        color: #FFFFFF; 
        width: 30%;
      }
      .btn-dwn:hover {
        color: #000000;
      }
      /* Cancel button in dialog box */
      .btn-default:hover {
        color: #000000 !important;
      }
      
    /* File input button */
    .btn-file {
      background-color: #000000;
      color: white;
      border-color: #000000;
    }
    /* Hover File button */
    .btn-file:hover {
      background-color: #FCDA01;
      color: #000000;
      border-color: #FCDA01;
    }

    "))
  ),
  
  # Add panel: ABOUT
  nav_panel(
    title = textOutput("nav_about_title", inline = TRUE),
    icon = icon("clipboard-list", style = "color: #FCDA01;"),
    card(
      card_header(uiOutput("my_title"), class = "card-header-main"),
      p(strong(textOutput("last_update_text", inline = TRUE)), 
        textOutput("my_date", inline = TRUE)),
      layout_columns(
        card(
          class = "my-card",
          card_body(
            strong(textOutput("summary_text", inline = TRUE), 
                   style = "font-size:20px"),
            uiOutput("my_summary")
          )
        ),
        card(
          class = "my-card",
          card_body(
            strong(textOutput("description_text", inline = TRUE), 
                   style = "font-size:20px"),
            tags$ul(
              tags$li(tags$i(class = "fa-solid fa-chart-line", style = "color: #FCDA01;"), 
                      uiOutput("description_title_ts", inline = TRUE),
                      uiOutput("description_text_ts", inline = TRUE) ),
              tags$li(tags$i(class = "glyphicon glyphicon-th-large", style = "color: #FCDA01;"), 
                      uiOutput("description_title_kobe", inline = TRUE),
                      uiOutput("description_text_kobe", inline = TRUE)),
              tags$li(tags$i(class = "fa-solid fa-gauge-high", style = "color: #FCDA01;"), 
                      uiOutput("description_title_perf", inline = TRUE),
                      uiOutput("description_text_perf", inline = TRUE)),
              tags$li(tags$i(class = "fa-solid fa-scale-unbalanced", style = "color: #FCDA01;"), 
                      uiOutput("description_title_td", inline = TRUE),
                      uiOutput("description_text_td", inline = TRUE)),
              tags$li(tags$i(class = "fa-solid fa-ship", style = "color: #FCDA01;"), 
                      uiOutput("description_title_fleet", inline = TRUE),
                      uiOutput("description_text_fleet", inline = TRUE))
            )
          )
        )
      )
    )
  ),
  
  # Add panel: TIME SERIES
  nav_panel(
    title = textOutput("nav_ts_title", inline = TRUE),
    icon = icon("chart-line", style = "color: #FCDA01;"),
    layout_sidebar(
      sidebar = sidebar(
        title = div(
          class = "d-flex align-items-center flex-nowrap gap-2",
          uiOutput("about_title_ts", inline = TRUE),
          uiOutput("ts_description")
        ),
        width = 350,
        bg = "#000000",
        fg = "#FFFFFF",
        conditionalPanel(
          condition = "input.ts_tab == 'overall'", 
          uiOutput("show_stock_ts_mult")
        ),
        conditionalPanel(
          condition = "input.ts_tab != 'overall'", 
          uiOutput("show_stock_ts_uniq")
        ),
        accordion(
          id = "acc_ts",
          open = TRUE,
          accordion_panel(
            title = ts_var_sett_title,
            value = "acc_ts_var",
            conditionalPanel(
              condition = "input.ts_tab == 'overall'", 
              uiOutput("show_var_ts_mult")
            ),
            conditionalPanel(
              condition = "input.ts_tab != 'overall'", 
              uiOutput("show_var_ts_uniq")
            )
          ),
          accordion_panel(
            title = mp_sett_title,
            value = "acc_ts_mp",
            uiOutput("mp_ts_update"),
            checkboxGroupInput(
              "mps_ts",
              NULL
            ),
            uiOutput("mp_ts_btn")
          ),
          accordion_panel(
            title = oth_sett_title,
            value = "acc_ts_oth",
            uiOutput("opts_ts_choices_1"),
            uiOutput("opts_ts_choices_2")
          )
        )
      ),
      navset_card_tab(
        id = "ts_tab",
        height = 700,
        full_screen = TRUE,
        title = NULL,
        nav_panel(
          title = textOutput("nav_ts_ov_title", inline = TRUE),
          value = "overall",
          shinycssloaders::withSpinner(
              plotOutput("ts_plot_var", height = plot_height),
              type = load_img_type,
              color = azti_col
          ),
          actionButton(inputId = "open_dwn_ts_ov", label = "",
                       icon = icon("download", style = "color: #FFFFFF;"),
                       class = "btn-dwn")
        ),
        nav_panel(
          title = textOutput("nav_ts_mp_title", inline = TRUE),
          value = "by_mp",
            shinycssloaders::withSpinner(
              plotOutput("ts_plot_var_mp", height = plot_height),
              type = load_img_type,
              color = azti_col
            ),
            actionButton(inputId = "open_dwn_ts_mp", label = "",
                         icon = icon("download", style = "color: #FFFFFF;"),
                         class = "btn-dwn")
        )
      )
    )
  ),
  
  # Add panel: KOBE
  nav_panel(
    title = textOutput("nav_kobe_title", inline = TRUE),
    icon = icon("th-large", lib = "glyphicon", style = "color: #FCDA01;"),
    layout_sidebar(
      sidebar = sidebar(
        title = div(
          class = "d-flex align-items-center flex-nowrap gap-2",
          uiOutput("about_title_kobe", inline = TRUE),
          uiOutput("kobe_description")
        ),
        width = 350,
        bg = "#000000",
        fg = "#FFFFFF",
        conditionalPanel(
          condition = "input.kobe_tab == 'overall'", 
          uiOutput("show_stock_kobe_mult")
        ),
        conditionalPanel(
          condition = "input.kobe_tab != 'overall'", 
          uiOutput("show_stock_kobe_uniq")
        ),
        accordion(
          id = "acc_kobe",
          open = TRUE,
          accordion_panel(
            title = mp_sett_title,
            value = "acc_kobe_mp",
            uiOutput("mp_kobe_update"),
            checkboxGroupInput(
              "mps_kobe",
              NULL
            ),
            uiOutput("mp_kobe_btn")
          ),
          accordion_panel(
            title = oth_sett_title,
            value = "acc_kobe_oth",
            conditionalPanel(
              condition = "input.kobe_tab == 'overall'", 
              uiOutput("opts_kobe_choices_1"),
              uiOutput("opts_kobe_choices_2"),
              uiOutput("opts_kobe_choices_3")
            )
          )
        )
      ),
      navset_card_tab(
        id = "kobe_tab",
        height = 700,
        full_screen = TRUE,
        title = NULL,
        nav_panel(
          title = textOutput("nav_kobe_ov_title", inline = TRUE),
          value = "overall",
          fluidRow(
            uiOutput("opts_kobe_choices_4")
          ),
          shinycssloaders::withSpinner(
            plotOutput("kobe_plot", height = plot_height),
            type = load_img_type,
            color = azti_col
          ),
          actionButton(inputId = "open_dwn_kobe_ov", label = "",
                       icon = icon("download", style = "color: #FFFFFF;"),
                       class = "btn-dwn")
        ),
        nav_panel(
          title = textOutput("nav_kobe_time_title", inline = TRUE),
          value = "kobe_time",
            shinycssloaders::withSpinner(
              plotOutput("kobe_plot_ts", height = plot_height),
              type = load_img_type,
              color = azti_col
            ),
            actionButton(inputId = "open_dwn_kobe_ti", label = "",
                         icon = icon("download", style = "color: #FFFFFF;"),
                         class = "btn-dwn")
        )
      )
    )
  ),
  
  # Add panel PERFORMANCE
  nav_panel(
    title = textOutput("nav_perf_title", inline = TRUE),
    icon = icon("gauge-high", style = "color: #FCDA01;"),
    layout_sidebar(
      sidebar = sidebar(
        title = div(
          class = "d-flex align-items-center flex-nowrap gap-2",
          uiOutput("about_title_perf", inline = TRUE),
          uiOutput("perf_description")
        ),
        width = 350,
        bg = "#000000",
        fg = "#FFFFFF",
        uiOutput("show_stock_perf_uniq"),
        accordion(
          id = "acc_perf",
          open = TRUE,
          accordion_panel(
            title = mp_sett_title,
            value = "acc_perf_mp",
            uiOutput("mp_perf_update"),
            checkboxGroupInput(
              "mps_perf",
              NULL
            ),
            uiOutput("mp_perf_btn")
          ),
          accordion_panel(
            title = pi_sett_title,
            value = "acc_perf_pi",
            uiOutput("pi_perf_update"),
            checkboxGroupInput(
              "pis_perf",
              NULL
            ),
            uiOutput("pi_perf_btn")
          )
        )
      ),
      navset_card_tab(
        id = "perf_tab",
        height = 700,
        full_screen = TRUE,
        title = NULL,
        nav_panel(
          "Quilt",
          fluidRow(
            uiOutput("opts_perf_choices_1")
          ),
          shinycssloaders::withSpinner(
            DT::dataTableOutput("quilt_table"),
            type = load_img_type,
            color = azti_col
          )
        ),
        nav_panel(
          "Spider",
          uiOutput("opts_perf_choices_2"),
          shinycssloaders::withSpinner(
            plotlyOutput("spd_plot", height = plot_height),
            type = load_img_type,
            color = azti_col
          )
        ),
        nav_panel(
          "Violin",
          shinycssloaders::withSpinner(
            plotOutput("box_plot", height = plot_height),
            type = load_img_type,
            color = azti_col
          ),
          actionButton(inputId = "open_dwn_perf_box", label = "",
                       icon = icon("download", style = "color: #FFFFFF;"),
                       class = "btn-dwn")
        )
      )
    )
  ),
  
  # Add panel: TRADEOFF
  nav_panel(
    title = textOutput("nav_trafeoff_title", inline = TRUE),
    icon = icon("scale-unbalanced", style = "color: #FCDA01;"),
    layout_sidebar(
      sidebar = sidebar(
        title = div(
          class = "d-flex align-items-center flex-nowrap gap-2",
          uiOutput("about_title_td", inline = TRUE),
          uiOutput("td_description")
        ),
        width = 350,
        bg = "#000000",
        fg = "#FFFFFF",
        uiOutput("show_stock_td_mult"),
        accordion(
          id = "acc_td",
          open = TRUE,
          accordion_panel(
            title = mp_sett_title,
            value = "acc_td_mp",
            uiOutput("mp_td_update"),
            checkboxGroupInput(
              "mps_td",
              NULL
            ),
            uiOutput("mp_td_btn")
          ),
          accordion_panel(
            title = oth_sett_title,
            value = "acc_td_oth",
            selectInput("pi_x_td", 
                        "", 
                        choices = NULL),
            selectInput("pi_y_td", 
                        "", 
                        choices = NULL)
          )
        )
      ),
      shinycssloaders::withSpinner(
        plotOutput("td_plot", height = plot_height),
        type = load_img_type,
        color = azti_col
      ),
      actionButton(inputId = "open_dwn_td", label = "",
                   icon = icon("download", style = "color: #FFFFFF;"),
                   class = "btn-dwn")
    )
  ),
  
  # Add panel: FLEET
  nav_panel(
    title = textOutput("nav_fleet_title", inline = TRUE),
    icon = icon("ship", style = "color: #FCDA01;"),
    layout_sidebar(
      sidebar = sidebar(
        title = div(
          class = "d-flex align-items-center flex-nowrap gap-2",
          uiOutput("about_title_fleet", inline = TRUE),
          uiOutput("flt_description")
        ),
        width = 350,
        bg = "#000000",
        fg = "#FFFFFF",
        uiOutput("show_stock_flt_mult"),
        accordion(
          id = "acc_fleet",
          open = TRUE,
          accordion_panel(
            title = ts_var_sett_title,
            value = "acc_fleet_var",
            selectInput("var_fleet", 
                        "",
                        choices = NULL)
          ),
          accordion_panel(
            title = mp_sett_title,
            value = "acc_fleet_mp",
            uiOutput("mp_flt_update"),
            checkboxGroupInput(
              "mps_flt",
              NULL
            ),
            uiOutput("mp_flt_btn")
          ),
          accordion_panel(
            title = fleet_sett_title,
            value = "acc_fleet_flt",
            uiOutput("fleet_flt_update"),
            checkboxGroupInput(
              "fleet_flt",
              NULL
            ),
            uiOutput("fleet_flt_btn")
          ),
          accordion_panel(
            title = oth_sett_title,
            value = "acc_fleet_oth",
            uiOutput("opts_fleet_choices_1"),
            uiOutput("opts_fleet_choices_2")
          )
        )
      ),
      shinycssloaders::withSpinner(
        plotOutput("flt_plot", height = plot_height),
        type = load_img_type,
        color = azti_col
      ),
      actionButton(inputId = "open_dwn_flt", label = "",
                   icon = icon("download", style = "color: #FFFFFF;"),
                   class = "btn-dwn")
    )
  ),
  
  # Add spacer:
  nav_spacer(),
  
  # COLOR BLIND button:
  nav_item(
    popover(
      trigger = actionButton("col_btn", NULL, 
                             icon = icon("eye", 
                                         class = "fa-lg", # make icon larger
                                         style = "color: #000000;"),
                             style = "padding: 5px 5px;"),
      title = textOutput("color_blind_text", inline = TRUE),
      placement = "right",
      layout_columns(
        col_widths = c(4, 8),
        input_switch(id = "switch_col", 
                     label = NULL),
        uiOutput("col_text")
      )
    )
  ),
  
  # LANGUAGE button:
  nav_item(
    popover(
      trigger = actionButton("col_btn", NULL, 
                             icon = icon("language", 
                                         class = "fa-lg", # make icon larger
                                         style = "color: #000000;"),
                             style = "padding: 5px 5px;"),
      title = textOutput("language_text", inline = TRUE),
      placement = "right",
      selectInput(inputId = "lang", label = NULL, 
                  choices = c("English", "Español", "Français"),
                  selected = "English",
                  multiple = FALSE)
    )
  ),
  
  # HELP sidebar:
  nav_item(
    popover(
      trigger = actionButton("help_btn", NULL, 
                             icon = icon("circle-info", 
                                         class = "fa-lg", # make icon larger
                                         style = "color: #000000;"),
                             style = "padding: 5px 5px;"),
      title = textOutput("info_text", inline = TRUE),
      accordion(
        open = FALSE,
        id = "acc_help",
        accordion_panel(
          title = "Time Series Variables",
          value = "acc_help_ts",
          DT::dataTableOutput('info_tab_ts')
        ),
        accordion_panel(
          title = "Operating Models (OMs)",
          value = "acc_help_om",
          DT::dataTableOutput('info_tab_om')
        ),
        accordion_panel(
          title = "Management Procedures (MPs)",
          value = "acc_help_mp",
          DT::dataTableOutput('info_tab_mp')
        ),
        accordion_panel(
          title = "Performance Indicators (PIs)",
          value = "acc_help_pi",
          DT::dataTableOutput('info_tab_pi')
        ),
        accordion_panel(
          title = "Fleets",
          value = "acc_help_fleet",
          DT::dataTableOutput('info_tab_flt')
        ),
        class = "info-accordion"
      ),
      placement = "right",
      options = list(customClass = "scrollable-popover")
    )
  )
  
) # page_navbar

) # fluidPage