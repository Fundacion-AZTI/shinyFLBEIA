server = function(input, output, session) {
  
  # -------------------------------------------------------------------------
  # Upload MSE outputs:

  # Run locally
  # if(isTRUE(run_locally)) {
  #   my_data <- reactive({
  #     readRDS(file.path("data", paste0(default_MSE, ".flbeia")))
  #   })
  # }
  if(isTRUE(run_locally)) {

    my_data <- reactiveVal(NULL)
    # Auto-show the Load Data modal on startup
    showModal(modalDialog(
      title = tags$div(
        tags$img(src = "__AZTI_A_principal.png", width = "140px",
                 style = "display:block; margin: 0 auto 12px auto;"),
        tags$span("Welcome to the FLBEIA Shiny App!", style = "font-size:22px; font-weight:bold;"),
      ),
      tags$p("Select a .flbeia file to upload your MSE results:",
             style = "color:#555; margin-bottom:8px;"),
      fileInput("file", label = NULL,
                buttonLabel = "Browse...",
                placeholder = "No file selected",
                accept = c(".flbeia")),
      footer = NULL,
      easyClose = FALSE,
      fade = TRUE
    ))
    
    # Once a file is chosen, load it and close the modal
    observeEvent(input$file, {
      req(input$file)
      data <- readRDS(input$file$datapath)
      my_data(data)
      removeModal()
    })
  }
  
  # Deploy on shinyapps.io
  if(!isTRUE(run_locally)) {
    
    # Show the waiter on app startup
    waiter_show(
      html = tagList(
        img(src = "__AZTI_A_principal.png", width = "200px"),
        h3("Loading FLBEIA Shiny App...")
      ),
      color = "rgba(0, 0, 0, 0.7)"  # Semi-transparent overlay
    )
    
    # Your reactive expressions and server logic here...
    # Add a delay and hide the waiter when ready
    observe({
      # Replace this with your actual data loading/processing
      Sys.sleep(2)  # Simulate loading time
      waiter_hide()  # Hide the waiter when done
    }, priority = 100)  # High priority to run first
    
    my_data <- reactive({
      # Get query string
      query <- parseQueryString(session$clientData$url_search)
      dataset_name <- query$dataset
      # Default dataset if none provided
      if (is.null(dataset_name)) {
        dataset_name <- default_MSE
      }
      # Construct filename
      file_path <- paste0("data/", dataset_name, ".flbeia")
      # Validate allowed datasets (important for security)
      allowed <- c("NALB", "BET", "YFT", "SKJ", "TROP")
      if (!dataset_name %in% allowed) {
        stop("Invalid dataset")
      }
      readRDS(file_path)
    })
  }
  
  # -------------------------------------------------------------------------
  # Reactive language code
  lang_code <- reactive({
    lang_map <- c("English" = "en", "Español" = "es", "Français" = "fr")
    lang_map[input$lang]
  })
  
  # Example of dynamically updating UI elements
  observe({
    lang <- lang_code()
    # Update Nav titles:
    output$nav_about_title <- renderText(tt("about", lang))
    output$nav_ts_title <- renderText(tt("time_series", lang))
    output$nav_kobe_title <- renderText(tt("kobe", lang))
    output$nav_perf_title <- renderText(tt("performance", lang))
    output$nav_trafeoff_title <- renderText(tt("tradeoff", lang))
    output$nav_fleet_title <- renderText(tt("fleet", lang))
    # Update Nav card tabs titles:
    output$nav_ts_ov_title <- renderText(tt("ts_ov_title", lang))
    output$nav_ts_mp_title <- renderText(tt("ts_mp_title", lang))
    output$nav_ts_om_title <- renderText(tt("ts_om_title", lang))
    output$nav_kobe_ov_title <- renderText(tt("kobe_ov_title", lang))
    output$nav_kobe_time_title <- renderText(tt("kobe_time_title", lang))
    # About page:
    output$last_update_text <- renderText(tt("last_update", lang))
    output$summary_text <- renderText(tt("summary", lang))
    output$description_text <- renderText(tt("description_plots", lang))
    # Buttons:
    output$color_blind_text <- renderText(tt("color_blind", lang))
    output$language_text <- renderText(tt("language", lang))
    output$info_text <- renderText(tt("information", lang))
  })
  
  # ABOUT page description plots:
  output$description_title_ts <- renderUI({ strong(paste0(tt("time_series", lang_code()), ":")) })
  output$description_text_ts <- renderUI({ HTML( tt("description_ts", lang_code()) ) })
  output$description_title_kobe <- renderUI({ strong(paste0(tt("kobe", lang_code()), ":")) })
  output$description_text_kobe <- renderUI({ HTML( tt("description_kobe", lang_code()) ) })
  output$description_title_perf <- renderUI({ strong(paste0(tt("performance", lang_code()), ":")) })
  output$description_text_perf <- renderUI({ HTML( tt("description_perf", lang_code()) ) })
  output$description_title_td <- renderUI({ strong(paste0(tt("tradeoff", lang_code()), ":")) })
  output$description_text_td <- renderUI({ HTML( tt("description_td", lang_code()) ) })
  output$description_title_fleet <- renderUI({ strong(paste0(tt("fleet", lang_code()), ":")) })
  output$description_text_fleet <- renderUI({ HTML( tt("description_fleet", lang_code()) ) })
  
  # Sidebar Plot Description (One per section to work properly):
  output$about_title_ts = renderUI({
    span( tt("about_chart", lang_code()), style = "font-size: 20px; font-weight: bold;" )
  })
  output$about_title_kobe = renderUI({
    span( tt("about_chart", lang_code()), style = "font-size: 20px; font-weight: bold;" )
  })
  output$about_title_perf = renderUI({
    span( tt("about_chart", lang_code()), style = "font-size: 20px; font-weight: bold;" )
  })
  output$about_title_td = renderUI({
    span( tt("about_chart", lang_code()), style = "font-size: 20px; font-weight: bold;" )
  })
  output$about_title_fleet = renderUI({
    span( tt("about_chart", lang_code()), style = "font-size: 20px; font-weight: bold;" )
  })
  
  # Color blind active/inactive
  col_blind_act = reactive ({ tt("color_blind_yes", lang_code()) })
  col_blind_inact = reactive ({ tt("color_blind_no", lang_code()) })
  
  # Other options settings:
  # TS:
  oth_setts_ts_1 = reactive ({ 
    opts_vec = c("median", "mean")
    names(opts_vec) = c(tt("median", lang_code()),
                        tt("mean", lang_code()) )
    opts_vec
  })
  oth_setts_ts_2 = reactive ({ 
    opts_vec = c("inc_perc", "inc_mp_lab", "inc_hist")
    names(opts_vec) = c(tt("percentiles", lang_code()),
                        tt("mp_labels", lang_code()),
                        tt("historical", lang_code()) )
    opts_vec
  })
  oth_setts_ts_3 = reactive ({ tt("by_mp", lang_code()) })
  oth_setts_ts_4 = reactive ({ tt("ind_sim", lang_code()) })
  # Kobe:
  oth_setts_kobe_1 = reactive ({ tt("x_range", lang_code()) })
  oth_setts_kobe_2 = reactive ({ tt("y_range", lang_code()) })
  oth_setts_kobe_3 = reactive ({ tt("percentile_kobe", lang_code()) })
  oth_setts_kobe_4 = reactive ({ 
    opts_vec = c("err_kobe", "line_kobe", "inc_lab")
    names(opts_vec) = c(tt("error_bars", lang_code()),
                        tt("line_proj_period", lang_code()),
                        tt("mp_labels", lang_code()) )
    opts_vec
  })
  # Performance:
  oth_setts_perf_1 = reactive ({ tt("col_scaling", lang_code()) })
  oth_setts_perf_2 = reactive ({ tt("col_mp_leg", lang_code()) })
  # Fleet:
  oth_setts_fleet_1 = reactive ({ 
    opts_vec = c("median", "mean")
    names(opts_vec) = c(tt("median", lang_code()),
                        tt("mean", lang_code()) )
    opts_vec
  })
  oth_setts_fleet_2 = reactive ({ 
    opts_vec = c("inc_perc", "inc_mp_lab")
    names(opts_vec) = c(tt("percentiles", lang_code()),
                        tt("mp_labels", lang_code()) )
    opts_vec
  })
  
  # Update Download buttons:
  observe({
    lang <- lang_code()
    updateActionButton(inputId = "open_dwn_ts_ov", label = tt("download_plot", lang))
    updateActionButton(inputId = "open_dwn_ts_mp", label = tt("download_plot", lang))
    updateActionButton(inputId = "open_dwn_ts_om", label = tt("download_plot", lang))
    updateActionButton(inputId = "open_dwn_ts_om_i", label = tt("download_plot", lang))
    updateActionButton(inputId = "open_dwn_kobe_ov", label = tt("download_plot", lang))
    updateActionButton(inputId = "open_dwn_kobe_ti", label = tt("download_plot", lang))
    updateActionButton(inputId = "open_dwn_perf_box", label = tt("download_plot", lang))
    updateActionButton(inputId = "open_dwn_td", label = tt("download_plot", lang))
    updateActionButton(inputId = "open_dwn_flt", label = tt("download_plot", lang))
  })
  
  # Update Download Box:
  dwn_sett_1 = reactive ({ tt("dwn_box_title", lang_code()) })
  dwn_sett_2 = reactive ({ tt("dwn_box_name", lang_code()) })
  dwn_sett_3 = reactive ({ tt("dwn_box_width", lang_code()) })
  dwn_sett_4 = reactive ({ tt("dwn_box_height", lang_code()) })
  dwn_sett_5 = reactive ({ tt("dwn_box_res", lang_code()) })
  dwn_sett_6 = reactive ({ tt("dwn_box_cancel", lang_code()) })
  dwn_sett_7 = reactive ({ tt("dwn_box_download", lang_code()) })
  
  # Update Trade Off PI selection:
  observe({
    lang <- lang_code()
    updateSelectInput(inputId = "pi_x_td", label = tt("trafeoff_x_axis", lang))
    updateSelectInput(inputId = "pi_y_td", label = tt("trafeoff_y_axis", lang))
  })
  
  # Update accordion titles (cannot render text, so do it this way)
  observe({
    lang <- lang_code()
    # TS:
    accordion_panel_update(
      id = "acc_ts", target = "acc_ts_var", title = tt("select_variable", lang) )
    accordion_panel_update(
      id = "acc_ts", target = "acc_ts_mp", title = tt("select_mp", lang) )
    accordion_panel_update(
      id = "acc_ts", target = "acc_ts_oth", title = tt("other_settings", lang) )
    # Kobe:
    accordion_panel_update(
      id = "acc_kobe", target = "acc_kobe_mp", title = tt("select_mp", lang) )
    accordion_panel_update(
      id = "acc_kobe", target = "acc_kobe_oth", title = tt("other_settings", lang) )
    # Performance:
    accordion_panel_update(
      id = "acc_perf", target = "acc_perf_mp", title = tt("select_mp", lang) )
    accordion_panel_update(
      id = "acc_perf", target = "acc_perf_pi", title = tt("select_pi", lang) )
    # Tradeoff:
    accordion_panel_update(
      id = "acc_td", target = "acc_td_mp", title = tt("select_mp", lang) )
    accordion_panel_update(
      id = "acc_td", target = "acc_td_oth", title = tt("other_settings", lang) )
    # Fleet:
    accordion_panel_update(
      id = "acc_fleet", target = "acc_fleet_var", title = tt("select_variable", lang) )
    accordion_panel_update(
      id = "acc_fleet", target = "acc_fleet_flt", title = tt("select_fleet", lang) )
    accordion_panel_update(
      id = "acc_fleet", target = "acc_fleet_mp", title = tt("select_mp", lang) )
    accordion_panel_update(
      id = "acc_fleet", target = "acc_fleet_oth", title = tt("other_settings", lang) )
    # Information help button:
    accordion_panel_update(
      id = "acc_help", target = "acc_help_ts", title = tt("ts_variables", lang) )
    accordion_panel_update(
      id = "acc_help", target = "acc_help_om", title = tt("operating_models", lang) )
    accordion_panel_update(
      id = "acc_help", target = "acc_help_mp", title = tt("management_procedures", lang) )
    accordion_panel_update(
      id = "acc_help", target = "acc_help_pi", title = tt("performance_indicators", lang) )
    accordion_panel_update(
      id = "acc_help", target = "acc_help_fleet", title = tt("fleets", lang) )
  })
  # Select Stocks(s):
  stock_sett_title = reactive ({ tt("select_stock", lang_code()) })
  # Update plot:
  update_plot_title = reactive ({ tt("update_plot", lang_code()) })
  
  # -------------------------------------------------------------------------
  # Preprocess data:
  ts_dat = reactive({
    req(my_data())
    ts_dat = reshape2::melt(my_data()$timeseries$value)
    ts_dat = ts_dat %>% na.omit 
    ts_dat
  })
  ts_dat_summ = reactive({
    ts_dat_summ = ts_dat() %>% tidyr::pivot_wider(names_from = "Percentile", values_from = "value")
    ts_dat_summ = ts_dat_summ %>% dplyr::mutate(Stock = factor(Stock, levels = my_data()$stocks),
                                                MPs = factor(MPs),
                                                Var = factor(Var, levels = my_data()$timeseries$metadata[["en"]]$Code))
    ts_dat_summ
  })
  ts_dat_hist = reactive({ 
    ts_dat_hist = ts_dat_summ() %>% 
      dplyr::filter(Years <= my_data()$timeseries$timenow) %>%
      dplyr::select(-c(MPs)) %>%
      dplyr::group_by(Stock, Var, Years) %>% summarise_all(mean) # does not matter the function
    ts_dat_hist
  })
  tar_lim_dat = reactive({
    tar_lim_dat = data.frame(Target = my_data()$timeseries$target,
                             Limit = my_data()$timeseries$limit,
                             Var = my_data()$timeseries$metadata[["en"]]$Code)
    tar_lim_dat = purrr::map_dfr(my_data()$stocks, ~ mutate(tar_lim_dat, group = .x)) %>% 
      rename(Stock = group)
    tar_lim_dat = tar_lim_dat %>% dplyr::mutate(Stock = factor(Stock, levels = my_data()$stocks),
                                                Var = factor(Var, levels = my_data()$timeseries$metadata[["en"]]$Code))
    tar_lim_dat
  })
  kobe_dat = reactive({
    kobe_dat = reshape2::melt(my_data()$kobe$value) %>% dplyr::mutate(Stock = factor(Stock, levels = my_data()$stocks),
                                                                    OMs = factor(OMs, levels = 1:nrow(my_data()$om$metadata[["en"]])),
                                                                    MPs = factor(MPs))
    kobe_dat = kobe_dat %>% na.omit
    kobe_dat
  })
  lst_yr_kobe_dat = reactive({
    lst_yr_kobe_dat = kobe_dat() %>% filter(Years == max(Years))
    lst_yr_kobe_dat
  })
  median_lst_kobe_dat = reactive({
    median_lst_kobe_dat = lst_yr_kobe_dat() %>% group_by(Stock, MPs, Var) %>% 
      summarise(value = median(value), .groups = "drop") %>%
      mutate(ax_type = if_else(Var == my_data()$kobe$metadata$Code[1], "x_axis", "y_axis")) %>%
      select(-Var) %>% pivot_wider(names_from = "ax_type")
    median_lst_kobe_dat
  })
  median_frs_kobe_dat = reactive({
    frs_yr_kobe_dat = kobe_dat() %>% filter(Years == min(Years))
    median_frs_kobe_dat = frs_yr_kobe_dat %>% group_by(Stock, MPs, Var) %>% 
      summarise(value = median(value), .groups = "drop") %>%
      mutate(ax_type = if_else(Var == my_data()$kobe$metadata$Code[1], "x_axis", "y_axis")) %>%
      select(-Var) %>% pivot_wider(names_from = "ax_type")
    median_frs_kobe_dat
  })
  perf_dat = reactive({
    perf_dat = reshape2::melt(my_data()$pi$value) %>% dplyr::mutate(Stock = factor(Stock, levels = my_data()$stocks),
                                                                  OMs = factor(OMs, levels = 1:nrow(my_data()$om$metadata[["en"]])),
                                                                  MPs = factor(MPs))
    perf_dat = perf_dat %>% na.omit 
    perf_dat
  })
  fleet_dat_summ = reactive({
    fleet_dat = reshape2::melt(my_data()$fleet$value)
    fleet_dat = fleet_dat %>% na.omit 
    fleet_dat_summ = fleet_dat %>% tidyr::pivot_wider(names_from = "Percentile", values_from = "value")
    fleet_dat_summ = fleet_dat_summ %>% dplyr::mutate(Stock = factor(Stock, levels = my_data()$stocks),
                                                      MPs = factor(MPs),
                                                      Fleet = factor(Fleet, levels = my_data()$fleet$metadata[["en"]]$Code),
                                                      Var = factor(Var, levels = my_data()$fleet$variables$Code))
    fleet_dat_summ
  })
  col_mp_lab = reactive({
    req(my_data())
    col_mp_lab = list()
    for(i in 1:nrow(my_data()$mp$metadata[["en"]])) {
      col_mp_lab[[i]] = HTML(list_content(my_data()$mp$color[i], my_data()$mp$metadata[["en"]]$Code[i]))
    }
    col_mp_lab
  })
  blind_scale = reactive({
    blind_scale = viridis::turbo(n = nrow(my_data()$mp$metadata[["en"]]))
    names(blind_scale) = names(my_data()$mp$color)
    blind_scale
  })
  col_mp_lab_bl = reactive({
    col_mp_lab_bl = list()
    for(i in 1:nrow(my_data()$mp$metadata[["en"]])) {
      col_mp_lab_bl[[i]] = HTML(list_content(blind_scale()[i], my_data()$mp$metadata[["en"]]$Code[i]))
    }
    col_mp_lab_bl
  })

  # -------------------------------------------------------------------------
  # Output some objects for ui.R
  output$my_title <- renderText({ req(my_data()); my_data()$title[[lang_code()]] })
  output$my_date <- renderText({ req(my_data()); as.character(my_data()$date) })
  output$my_summary <- renderText({ 
    req(my_data())
    my_text <- my_data()$summary[[lang_code()]]
    HTML(markdown::markdownToHTML(
      text = my_text,
      fragment.only = TRUE
    ))
  })

  # -------------------------------------------------------------------------
  # Tooltips for description of tabs
  n_sim <- reactive({ req(my_data()); my_data()$n_sim })
  n_om <- reactive({ req(my_data()); nrow(my_data()$om$metadata[["en"]]) })
  # Text:
  std_txt_1 = reactive ({ tt("std_text_1", lang_code()) })
  std_txt_2 = reactive ({ tt("std_text_2", lang_code()) })
  std_txt_3 = reactive ({ tt("std_text_3", lang_code()) })
  std_txt_4 = reactive ({ tt("std_text_4", lang_code()) })
  std_txt_5 = reactive ({ tt("std_text_5", lang_code()) })
  # Text TS:
  ts_txt_1 = reactive ({ tt("help_ts_1", lang_code()) })
  ts_txt_2 = reactive ({ tt("help_ts_2", lang_code()) })
  ts_txt_3 = reactive ({ tt("help_ts_3", lang_code()) })
  ts_txt_4 = reactive ({ tt("help_ts_4", lang_code()) })
  # Text Kobe:
  kobe_txt_1 = reactive ({ tt("help_kobe_1", lang_code()) })
  kobe_txt_2 = reactive ({ tt("help_kobe_2", lang_code()) })
  kobe_txt_3 = reactive ({ tt("help_kobe_3", lang_code()) })
  kobe_txt_4 = reactive ({ tt("help_kobe_4", lang_code()) })
  # Text Performance:
  perf_txt_1 = reactive ({ tt("help_perf_1", lang_code()) })
  perf_txt_2 = reactive ({ tt("help_perf_2", lang_code()) })
  perf_txt_3 = reactive ({ tt("help_perf_3", lang_code()) })
  perf_txt_4 = reactive ({ tt("help_perf_4", lang_code()) })
  # Text tradeoff:
  td_txt_1 = reactive ({ tt("help_td_1", lang_code()) })
  td_txt_2 = reactive ({ tt("help_td_2", lang_code()) })
  # Text Fleet:
  fleet_txt_1 = reactive ({ tt("help_fleet_1", lang_code()) })
  fleet_txt_2 = reactive ({ tt("help_fleet_2", lang_code()) })
  fleet_txt_3 = reactive ({ tt("help_fleet_3", lang_code()) })
  
  # TS:
  output$ts_description <- renderUI({
    tooltip(
      icon("circle-question", style = "color: #FCDA01;"),
      tagList( 
        ts_txt_1(),
        std_txt_1(), # Standard text
        n_sim(),
        std_txt_2(), # Standard text
        n_om(),
        std_txt_3(), # Standard text
        br(),
        ts_txt_2(),
        br(),
        tags$img(src = "ts.png", height = "150px"),
        br(),
        ts_txt_3(),
        br(),
        br(),
        std_txt_4(), # Standard text
        ts_txt_4(),
        icon("circle-info"),
        std_txt_5() # Standard text
      ),
      placement = "right")
  })
  
  # KOBE:
  output$kobe_description <- renderUI({
    tooltip(
      icon("circle-question", style = "color: #FCDA01;"),
      tagList(
        kobe_txt_1(),
        std_txt_1(), # Standard text
        n_sim(),
        std_txt_2(), # Standard text
        n_om(),
        std_txt_3(), # Standard text
        br(),
        br(),
        kobe_txt_2(),
        br(),
        br(),
        kobe_txt_3(),
        br(),
        br(),
        std_txt_4(), # Standard text
        kobe_txt_4(),
        icon("circle-info"),
        std_txt_5() # Standard text
      ),
      placement = "right"
    )
  })
  
  # PERFORMANCE:
  output$perf_description <- renderUI({
    tooltip(
      icon("circle-question", style = "color: #FCDA01;"),
      tagList( 
        perf_txt_1(),
        std_txt_1(), # Standard text
        n_sim(),
        std_txt_2(), # Standard text
        n_om(),
        std_txt_3(), # Standard text
        br(),
        br(),
        perf_txt_2(),
        br(),
        tags$img(src = "spider.png", height = "180px"),
        br(),
        perf_txt_3(),
        br(),
        tags$img(src = "violin.png", height = "120px"),
        br(),
        std_txt_4(), # Standard text
        perf_txt_4(),
        icon("circle-info"),
        std_txt_5() # Standard text
      ),
      placement = "right"
    )  
  })
  
  # TRADEOFF:
  output$td_description <- renderUI({
    tooltip(
      icon("circle-question", style = "color: #FCDA01;"),
      tagList( 
        td_txt_1(), # Standard text
        n_sim(),
        std_txt_2(), # Standard text
        n_om(),
        std_txt_3(), # Standard text
        br(),
        br(),
        std_txt_4(), # Standard text
        td_txt_2(),
        icon("circle-info"),
        std_txt_5() # Standard text
      ),
      placement = "right"
    )  
  })
  
  # Fleet:
  output$flt_description <- renderUI({
    tooltip(
      icon("circle-question", style = "color: #FCDA01;"),
      tagList( 
        fleet_txt_1(), # Standard text
        n_sim(),
        std_txt_2(), # Standard text
        n_om(),
        std_txt_3(), # Standard text
        br(),
        fleet_txt_2(),
        br(),
        tags$img(src = "ts.png", height = "150px"),
        br(),
        br(),
        std_txt_4(), # Standard text
        fleet_txt_3(),
        icon("circle-info"),
        std_txt_5() # Standard text
      ),
      placement = "right"
    ) 
  })
  

  # -------------------------------------------------------------------------
  # Download Plot buttons
  
  # Download button TS OVERALL:
  observeEvent(input$open_dwn_ts_ov, {
    showModal(
      modalDialog(
        title = dwn_sett_1(),
        textInput("name_ts_ov", dwn_sett_2(), value = "fig_ts_ov"),
        numericInput("width_ts_ov", dwn_sett_3(), value = dwn_width, min = 1),
        numericInput("height_ts_ov", dwn_sett_4(), value = dwn_height, min = 1),
        numericInput("dpi_ts_ov", dwn_sett_5(), value = dwn_res, min = 72),
        footer = tagList(
          modalButton(dwn_sett_6()),
          downloadButton("dwn_plot_ts_ov", dwn_sett_7())
        )
      )
    )
  })
  # Download handler
  output$dwn_plot_ts_ov <- downloadHandler(
    filename = function() { paste0(input$name_ts_ov, ".png") },
    content = function(file) {
      ggsave(file, plot = my_ts_plot_var(), 
             width = input$width_ts_ov, 
             height = input$height_ts_ov, 
             dpi = input$dpi_ts_ov,
             units = dwn_units)
    }
  )
  
  # Download button TS MP:
  observeEvent(input$open_dwn_ts_mp, {
    showModal(
      modalDialog(
        title = dwn_sett_1(),
        textInput("name_ts_mp", dwn_sett_2(), value = "fig_ts_mp"),
        numericInput("width_ts_mp", dwn_sett_3(), value = dwn_width, min = 1),
        numericInput("height_ts_mp", dwn_sett_4(), value = dwn_height, min = 1),
        numericInput("dpi_ts_mp", dwn_sett_5(), value = dwn_res, min = 72),
        footer = tagList(
          modalButton(dwn_sett_6()),
          downloadButton("dwn_plot_ts_mp", dwn_sett_7())
        )
      )
    )
  })
  # Download handler
  output$dwn_plot_ts_mp <- downloadHandler(
    filename = function() { paste0(input$name_ts_mp, ".png") },
    content = function(file) {
      ggsave(file, plot = my_ts_plot_var_mp(), 
             width = input$width_ts_mp, 
             height = input$height_ts_mp, 
             dpi = input$dpi_ts_mp,
             units = dwn_units)
    }
  )

  # Download button KOBE Overall:
  observeEvent(input$open_dwn_kobe_ov, {
    showModal(
      modalDialog(
        title = dwn_sett_1(),
        textInput("name_kobe_ov", dwn_sett_2(), value = "fig_kobe_ov"),
        numericInput("width_kobe_ov", dwn_sett_3(), value = dwn_width, min = 1),
        numericInput("height_kobe_ov", dwn_sett_4(), value = dwn_height, min = 1),
        numericInput("dpi_kobe_ov", dwn_sett_5(), value = dwn_res, min = 72),
        footer = tagList(
          modalButton(dwn_sett_6()),
          downloadButton("dwn_plot_kobe_ov", dwn_sett_7())
        )
      )
    )
  })
  # Download handler
  output$dwn_plot_kobe_ov <- downloadHandler(
    filename = function() { paste0(input$name_kobe_ov, ".png") },
    content = function(file) {
      ggsave(file, plot = my_kobe_plot(), 
             width = input$width_kobe_ov, 
             height = input$height_kobe_ov, 
             dpi = input$dpi_kobe_ov,
             units = dwn_units)
    }
  ) 
  
  # Download button KOBE Time:
  observeEvent(input$open_dwn_kobe_ti, {
    showModal(
      modalDialog(
        title = dwn_sett_1(),
        textInput("name_kobe_ti", dwn_sett_2(), value = "fig_kobe_ti"),
        numericInput("width_kobe_ti", dwn_sett_3(), value = dwn_width, min = 1),
        numericInput("height_kobe_ti", dwn_sett_4(), value = dwn_height, min = 1),
        numericInput("dpi_kobe_ti", dwn_sett_5(), value = dwn_res, min = 72),
        footer = tagList(
          modalButton(dwn_sett_6()),
          downloadButton("dwn_plot_kobe_ti", dwn_sett_7())
        )
      )
    )
  })
  # Download handler
  output$dwn_plot_kobe_ti <- downloadHandler(
    filename = function() { paste0(input$name_kobe_ti, ".png") },
    content = function(file) {
      ggsave(file, plot = my_kobe_plot_ts(), 
             width = input$width_kobe_ti, 
             height = input$height_kobe_ti, 
             dpi = input$dpi_kobe_ti,
             units = dwn_units)
    }
  ) 
  
  # Download button PERF boxplot:
  observeEvent(input$open_dwn_perf_box, {
    showModal(
      modalDialog(
        title = dwn_sett_1(),
        textInput("name_perf_box", dwn_sett_2(), value = "fig_perf_box"),
        numericInput("width_perf_box", dwn_sett_3(), value = dwn_width, min = 1),
        numericInput("height_perf_box", dwn_sett_4(), value = dwn_height, min = 1),
        numericInput("dpi_perf_box", dwn_sett_5(), value = dwn_res, min = 72),
        footer = tagList(
          modalButton(dwn_sett_6()),
          downloadButton("dwn_plot_perf_box", dwn_sett_6())
        )
      )
    )
  })
  # Download handler
  output$dwn_plot_perf_box <- downloadHandler(
    filename = function() { paste0(input$name_perf_box, ".png") },
    content = function(file) {
      ggsave(file, plot = my_box_plot(), 
             width = input$width_perf_box, 
             height = input$height_perf_box, 
             dpi = input$dpi_perf_box,
             units = dwn_units)
    }
  ) 
  
  # Download button TRADEOFF:
  observeEvent(input$open_dwn_td, {
    showModal(
      modalDialog(
        title = dwn_sett_1(),
        textInput("name_td", dwn_sett_2(), value = "fig_td"),
        numericInput("width_td", dwn_sett_3(), value = dwn_width, min = 1),
        numericInput("height_td", dwn_sett_4(), value = dwn_height, min = 1),
        numericInput("dpi_td", dwn_sett_5(), value = dwn_res, min = 72),
        footer = tagList(
          modalButton(dwn_sett_6()),
          downloadButton("dwn_plot_td", dwn_sett_7())
        )
      )
    )
  })
  # Download handler
  output$dwn_plot_td <- downloadHandler(
    filename = function() { paste0(input$name_td, ".png") },
    content = function(file) {
      ggsave(file, plot = my_td_plot(), 
             width = input$width_td, 
             height = input$height_td, 
             dpi = input$dpi_td,
             units = dwn_units)
    }
  ) 
  
  # Download button FLEET:
  observeEvent(input$open_dwn_flt, {
    showModal(
      modalDialog(
        title = dwn_sett_1(),
        textInput("name_flt", dwn_sett_2(), value = "fig_flt"),
        numericInput("width_flt", dwn_sett_3(), value = dwn_width, min = 1),
        numericInput("height_flt", dwn_sett_4(), value = dwn_height, min = 1),
        numericInput("dpi_flt", dwn_sett_5(), value = dwn_res, min = 72),
        footer = tagList(
          modalButton(dwn_sett_6()),
          downloadButton("dwn_plot_flt", dwn_sett_7())
        )
      )
    )
  })
  # Download handler
  output$dwn_plot_flt <- downloadHandler(
    filename = function() { paste0(input$name_flt, ".png") },
    content = function(file) {
      ggsave(file, plot = my_flt_plot(), 
             width = input$width_flt, 
             height = input$height_flt, 
             dpi = input$dpi_flt,
             units = dwn_units)
    }
  ) 
  
  # -------------------------------------------------------------------------
  # Condition for variable TS:
  output$show_var_ts_mult <- renderUI({
      selectInput(inputId = "var_ts_mult", label = NULL,       
                  choices = my_data()$timeseries$metadata[["en"]]$Code,
                  selected = my_data()$timeseries$metadata[["en"]]$Code,
                  multiple = TRUE)
  })
  output$show_var_ts_uniq <- renderUI({
      selectInput(inputId = "var_ts_uniq", label = NULL,       
                  choices = my_data()$timeseries$metadata[["en"]]$Code,
                  selected = my_data()$timeseries$metadata[["en"]]$Code[1],
                  multiple = FALSE)
  })
  
  # -------------------------------------------------------------------------
  # Condition if show stock options:
  
  # TS:
  output$show_stock_ts_mult <- renderUI({
    if (my_data()$n_stocks > 1) {
      selectInput(inputId = "stock_ts_mult", label = strong(stock_sett_title()),       
                  choices = my_data()$stocks,
                  selected = my_data()$stocks,
                  multiple = TRUE)
    } 
  })
  output$show_stock_ts_uniq <- renderUI({
    if (my_data()$n_stocks > 1) {
      selectInput(inputId = "stock_ts_uniq", label = strong(stock_sett_title()),       
                  choices = my_data()$stocks,
                  selected = my_data()$stocks[1],
                  multiple = FALSE)
    } 
  })
  
  # Kobe:
  output$show_stock_kobe_mult <- renderUI({
    if (my_data()$n_stocks > 1) {
      selectInput(inputId = "stock_kobe_mult", label = strong(stock_sett_title()),       
                  choices = my_data()$stocks,
                  selected = my_data()$stocks,
                  multiple = TRUE)
    } 
  })
  output$show_stock_kobe_uniq <- renderUI({
    if (my_data()$n_stocks > 1) {
      selectInput(inputId = "stock_kobe_uniq", label = strong(stock_sett_title()),       
                  choices = my_data()$stocks,
                  selected = my_data()$stocks[1],
                  multiple = FALSE)
    } 
  })
  
  # Performance:
  output$show_stock_perf_uniq <- renderUI({
    if (my_data()$n_stocks > 1) {
      selectInput(inputId = "stock_perf_uniq", label = strong(stock_sett_title()),       
                  choices = my_data()$stocks,
                  selected = my_data()$stocks[1],
                  multiple = FALSE)
    } 
  })
  
  # Tradeoff:
  output$show_stock_td_mult <- renderUI({
    if (my_data()$n_stocks > 1) {
      selectInput(inputId = "stock_td_mult", label = strong(stock_sett_title()),       
                  choices = my_data()$stocks,
                  selected = my_data()$stocks,
                  multiple = TRUE)
    } 
  })
  
  # Fleet:
  output$show_stock_flt_mult <- renderUI({
    if (my_data()$n_stocks > 1) {
      selectInput(inputId = "stock_flt_mult", label = strong(stock_sett_title()),       
                  choices = my_data()$stocks,
                  selected = my_data()$stocks,
                  multiple = TRUE)
    } 
  })
  

  # -------------------------------------------------------------------------
  # Other options in settings:
  # TS:
  output$opts_ts_choices_1 <- renderUI({
    radioButtons(
      inputId = "central",
      label = NULL,
      choices = oth_setts_ts_1(),
      selected = "median",
      inline = TRUE
    )
  })
  output$opts_ts_choices_2 <- renderUI({
    checkboxGroupInput(
      inputId = "opts",
      label = NULL,
      choices = oth_setts_ts_2(),
      selected = c("inc_perc", "inc_mp_lab", "inc_hist"),
      inline = FALSE
    )
  })
  output$opts_ts_choices_3 <- renderUI({
    checkboxInput(inputId = "by_mp", label = oth_setts_ts_3())
  })
  # Kobe:
  output$opts_kobe_choices_1 <- renderUI({
    sliderInput(
      "x_range_kobe",
      strong(oth_setts_kobe_1()),
      min = 0,
      max = 10,
      value = c(0, 3),
      round = -1
    )
  })
  output$opts_kobe_choices_2 <- renderUI({
    sliderInput(
      "y_range_kobe",
      strong(oth_setts_kobe_2()),
      min = 0,
      max = 10,
      value = c(0, 3),
      round = -1
    )
  })
  output$opts_kobe_choices_3 <- renderUI({
    sliderInput(
      "perc_kobe",
      strong(oth_setts_kobe_3()),
      min = 0,
      max = 1,
      value = 0.75
    )
  })
  output$opts_kobe_choices_4 <- renderUI({
    checkboxGroupInput(
      inputId = "opts_kobe",
      label = NULL,
      choices = oth_setts_kobe_4(),
      selected = "inc_lab",
      inline = TRUE
    )
  })
  # Performance:
  output$opts_perf_choices_1 <- renderUI({
    checkboxInput(
      inputId = "opts_quilt",
      label = oth_setts_perf_1()
    )
  })
  output$opts_perf_choices_2 <- renderUI({
    checkboxInput(
      inputId = "opts_perf_spd",
      label = oth_setts_perf_2()
    )
  })
  # Fleet:
  output$opts_fleet_choices_1 <- renderUI({
    radioButtons(
      inputId = "central_flt",
      label = NULL,
      choices = oth_setts_fleet_1(),
      selected = "median",
      inline = TRUE
    )
  })
  output$opts_fleet_choices_2 <- renderUI({
    checkboxGroupInput(
      inputId = "opts_flt",
      label = NULL,
      choices = oth_setts_fleet_2(),
      selected = c("inc_perc", "inc_mp_lab"),
      inline = FALSE
    )
  })
  
  
  # -------------------------------------------------------------------------
  # Update color palette:
  
  # List of color for labels:
  my_col_list <- reactive({
    if (input$switch_col) {
      col_mp_lab_bl()
    } else {
      col_mp_lab()
    }
  })
  
  # Vector of color for plot:
  my_col_vec <- reactive({
    if (input$switch_col) {
      blind_scale()
    } else {
      my_data()$mp$color
    }
  })
  
  # UPDATE checkbox MP colors TS:
  observe({
      updateCheckboxGroupInput(
        session,
        "mps_ts",
        choiceNames = my_col_list(),
        choiceValues = my_data()$mp$metadata[["en"]]$Code,
        selected = my_data()$mp$metadata[["en"]]$Code
      )
  } )

  # UPDATE checkbox MP colors KOBE:
  observe({
      updateCheckboxGroupInput(
        session,
        "mps_kobe",
        choiceNames = my_col_list(),
        choiceValues = my_data()$mp$metadata[["en"]]$Code,
        selected = my_data()$mp$metadata[["en"]]$Code
      )
  } )
  
  # UPDATE checkbox MP colors PERFORMANCE:
  observe({
    updateCheckboxGroupInput(
      session,
      "mps_perf",
      choiceNames = my_col_list(),
      choiceValues = my_data()$mp$metadata[["en"]]$Code,
      selected = my_data()$mp$metadata[["en"]]$Code
    )
  } )

  # UPDATE checkbox MP colors TRADEOFF:
  observe({
      updateCheckboxGroupInput(
        session,
        "mps_td",
        choiceNames = my_col_list(),
        choiceValues = my_data()$mp$metadata[["en"]]$Code,
        selected = my_data()$mp$metadata[["en"]]$Code
      )
  } )
  
  # UPDATE checkbox MP colors FLEET:
  observe({
    updateCheckboxGroupInput(
      session,
      "mps_flt",
      choiceNames = my_col_list(),
      choiceValues = my_data()$mp$metadata[["en"]]$Code,
      selected = my_data()$mp$metadata[["en"]]$Code
    )
  } )
  

  # -------------------------------------------------------------------------
  # Update group of MPs:
  mp_grs = reactive({ c(names(my_data()$mp$preset), "None") })
  
  # TS PLOT:
  # Make buttons:
  output$mp_ts_btn <- renderUI({
    tagList(
      lapply(seq_along(mp_grs()), function(i) {
        actionButton(
          inputId = paste0("btn_mp_ts_", i),
          label   = mp_grs()[i],
          class = "my-gr-btn"
        )
      })
    )
  })
  # Update:
  observe({
    lapply(seq_along(mp_grs()), function(i) {
      observeEvent(input[[paste0("btn_mp_ts_", i)]], {
        updateCheckboxGroupInput(
          session,
          "mps_ts",
          selected = if(mp_grs()[i] == "None") character(0) else my_data()$mp$metadata[["en"]]$Code[my_data()$mp$preset[[i]]]
        )
      }, ignoreInit = TRUE)
    })
  })
  
  # KOBE PLOT:
  # Make buttons:
  output$mp_kobe_btn <- renderUI({
    tagList(
      lapply(seq_along(mp_grs()), function(i) {
        actionButton(
          inputId = paste0("btn_mp_kobe_", i),
          label   = mp_grs()[i],
          class = "my-gr-btn"
        )
      })
    )
  })
  # Update:
  observe({
    lapply(seq_along(mp_grs()), function(i) {
      observeEvent(input[[paste0("btn_mp_kobe_", i)]], {
        updateCheckboxGroupInput(
          session,
          "mps_kobe",
          selected = if(mp_grs()[i] == "None") character(0) else my_data()$mp$metadata[["en"]]$Code[my_data()$mp$preset[[i]]]
        )
      }, ignoreInit = TRUE)
    })
  })
  
  # Performance PLOT:
  # Make buttons:
  output$mp_perf_btn <- renderUI({
    tagList(
      lapply(seq_along(mp_grs()), function(i) {
        actionButton(
          inputId = paste0("btn_mp_perf_", i),
          label   = mp_grs()[i],
          class = "my-gr-btn"
        )
      })
    )
  })
  # Update:
  observe({
    lapply(seq_along(mp_grs()), function(i) {
      observeEvent(input[[paste0("btn_mp_perf_", i)]], {
        updateCheckboxGroupInput(
          session,
          "mps_perf",
          selected = if(mp_grs()[i] == "None") character(0) else my_data()$mp$metadata[["en"]]$Code[my_data()$mp$preset[[i]]]
        )
      }, ignoreInit = TRUE)
    })
  })
  
  # TRADEOFF PLOT:
  # Make buttons:
  output$mp_td_btn <- renderUI({
    tagList(
      lapply(seq_along(mp_grs()), function(i) {
        actionButton(
          inputId = paste0("btn_mp_td_", i),
          label   = mp_grs()[i],
          class = "my-gr-btn"
        )
      })
    )
  })
  # Update:
  observe({
    lapply(seq_along(mp_grs()), function(i) {
      observeEvent(input[[paste0("btn_mp_td_", i)]], {
        updateCheckboxGroupInput(
          session,
          "mps_td",
          selected = if(mp_grs()[i] == "None") character(0) else my_data()$mp$metadata[["en"]]$Code[my_data()$mp$preset[[i]]]
        )
      }, ignoreInit = TRUE)
    })
  })
  
  # FLEET PLOT:
  # Make buttons for MPs:
  output$mp_flt_btn <- renderUI({
    tagList(
      lapply(seq_along(mp_grs()), function(i) {
        actionButton(
          inputId = paste0("btn_mp_flt_", i),
          label   = mp_grs()[i],
          class = "my-gr-btn"
        )
      })
    )
  })
  # Update:
  observe({
    lapply(seq_along(mp_grs()), function(i) {
      observeEvent(input[[paste0("btn_mp_flt_", i)]], {
        updateCheckboxGroupInput(
          session,
          "mps_flt",
          selected = if(mp_grs()[i] == "None") character(0) else my_data()$mp$metadata[["en"]]$Code[my_data()$mp$preset[[i]]]
        )
      }, ignoreInit = TRUE)
    })
  })
  

  # -------------------------------------------------------------------------
  # Update plot based on MP selection
  
  # TS:
  output$mp_ts_update <- renderUI({
    actionButton(
          inputId = "mp_ts_updt",
          label   = update_plot_title(),
          class = "my-updt-btn"
    )
  })
  # MP selected
  sel_mps_ts <- eventReactive(input$mp_ts_updt, {
    input$mps_ts
  }, ignoreNULL = FALSE)
  
  # Kobe:
  output$mp_kobe_update <- renderUI({
    actionButton(
      inputId = "mp_kobe_updt",
      label   = update_plot_title(),
      class = "my-updt-btn"
    )
  })
  # MP selected
  sel_mps_kobe <- eventReactive(input$mp_kobe_updt, {
    input$mps_kobe
  }, ignoreNULL = FALSE)

  # Performance:
  output$mp_perf_update <- renderUI({
    actionButton(
      inputId = "mp_perf_updt",
      label   = update_plot_title(),
      class = "my-updt-btn"
    )
  })
  # MP selected
  sel_mps_perf <- eventReactive(input$mp_perf_updt, {
    input$mps_perf
  }, ignoreNULL = FALSE)
  
  # Tradeoff:
  output$mp_td_update <- renderUI({
    actionButton(
      inputId = "mp_td_updt",
      label   = update_plot_title(),
      class = "my-updt-btn"
    )
  })
  # MP selected
  sel_mps_td <- eventReactive(input$mp_td_updt, {
    input$mps_td
  }, ignoreNULL = FALSE)
  
  # Fleets:
  output$mp_flt_update <- renderUI({
    actionButton(
      inputId = "mp_flt_updt",
      label   = update_plot_title(),
      class = "my-updt-btn"
    )
  })
  # MP selected
  sel_mps_flt <- eventReactive(input$mp_flt_updt, {
    input$mps_flt
  }, ignoreNULL = FALSE)
  

  # -------------------------------------------------------------------------
  # Update Plot based on PI selection
  # Performance:
  output$pi_perf_update <- renderUI({
    actionButton(
      inputId = "pi_perf_updt",
      label   = update_plot_title(),
      class = "my-updt-btn"
    )
  })
  # PI selected
  sel_pis_perf <- eventReactive(input$pi_perf_updt, {
    input$pis_perf
  }, ignoreNULL = FALSE)
  
  # -------------------------------------------------------------------------
  # Update Plot based on Fleet selection
  # Fleet:
  output$fleet_flt_update <- renderUI({
    actionButton(
      inputId = "fleet_flt_updt",
      label   = update_plot_title(),
      class = "my-updt-btn"
    )
  })
  # Fleets selected
  sel_fleet_flt <- eventReactive(input$fleet_flt_updt, {
    input$fleet_flt
  }, ignoreNULL = FALSE)
  
  # -------------------------------------------------------------------------
  # Update dynamic objects in checkbox or selectinput
  
  # Performance PI checkbox:
  observe({
    updateCheckboxGroupInput(
      session,
      "pis_perf",
      choices = my_data()$pi$metadata[["en"]]$Code,
      selected = my_data()$pi$metadata[["en"]]$Code
    )
  })
  
  # Trafeoff PI select:
  observe({
    updateSelectInput(
      session,
      "pi_x_td",
      choices = my_data()$pi$metadata[["en"]]$Code,
      selected = my_data()$pi$metadata[["en"]]$Code[1]
    )
  })
  observe({
    updateSelectInput(
      session,
      "pi_y_td",
      choices = my_data()$pi$metadata[["en"]]$Code,
      selected = my_data()$pi$metadata[["en"]]$Code[2]
    )
  })
  
  # Fleet variable:
  observe({
    updateSelectInput(
      session,
      "var_fleet",
      choices = my_data()$fleet$variables$Code,
      selected = my_data()$fleet$variables$Code[1]
    )
  })
  
  # FLEET flt checkbox:
  observe({
    updateCheckboxGroupInput(
      session,
      "fleet_flt",
      choices = my_data()$fleet$metadata[["en"]]$Code,
      selected = my_data()$fleet$metadata[["en"]]$Code
    )
  })
  
  
  # -------------------------------------------------------------------------
  # Performance PLOT: Make button for PIs
  pi_grs = reactive({ names(my_data()$pi$preset) })
  
  output$pi_perf_btn <- renderUI({
    tagList(
      lapply(seq_along(pi_grs()), function(i) {
        actionButton(
          inputId = paste0("btn_pi_perf_", i),
          label   = pi_grs()[i],
          class = "my-gr-btn"
        )
      })
    )
  })
  # Update:
  observe({
    lapply(seq_along(pi_grs()), function(i) {
      observeEvent(input[[paste0("btn_pi_perf_", i)]], {
        updateCheckboxGroupInput(
          session,
          "pis_perf",
          selected = my_data()$pi$metadata[["en"]]$Code[my_data()$pi$preset[[i]]]
        )
      }, ignoreInit = TRUE)
    })
  })
  
  # FLEET PLOTS: Make buttons for fleets:
  fleet_grs = reactive({ names(my_data()$fleet$preset) })
  
  output$fleet_flt_btn <- renderUI({
    tagList(
      lapply(seq_along(fleet_grs()), function(i) {
        actionButton(
          inputId = paste0("btn_fleet_flt_", i),
          label   = fleet_grs()[i],
          class = "my-gr-btn"
        )
      })
    )
  })
  # Update:
  observe({
    lapply(seq_along(fleet_grs()), function(i) {
      observeEvent(input[[paste0("btn_fleet_flt_", i)]], {
        updateCheckboxGroupInput(
          session,
          "fleet_flt",
          selected = my_data()$fleet$metadata[["en"]]$Code[my_data()$fleet$preset[[i]]]
        )
      }, ignoreInit = TRUE)
    }) 
  }) 
  
  
  # ------------------------------------------------------------------------
  # Text to shown in switch color blind:
  output$col_text <- renderUI({
    if (input$switch_col) {
      div(
        style = "font-size: 17px;font-weight: bold;",
        col_blind_act()
      )
    } else {
      div(
        style = "font-size: 17px;font-weight: bold;",
        col_blind_inact()
      )
    }
  })

  # -------------------------------------------------------------------------
  # TIME SERIES PLOT
  my_ts_plot_var <- reactive({
    
    # Select stocks:
    if(my_data()$n_stocks > 1) {
      these_stocks = input$stock_ts_mult
    } else {
      these_stocks = my_data()$stocks
    }
    
    # Avoid error messages if variables are not available:
    req(input$var_ts_mult, these_stocks, sel_mps_ts())
    
    # Filter:
    histdat = ts_dat_hist() %>% 
                  dplyr::filter(Stock %in% these_stocks,
                                Var %in% input$var_ts_mult) 
    plotdat = ts_dat_summ() %>% dplyr::filter(Stock %in% these_stocks,
                                              Var %in% input$var_ts_mult, 
                                              Years >= my_data()$timeseries$timenow,
                                              MPs %in% sel_mps_ts())
    labdat = plotdat %>% dplyr::filter(Years == max(plotdat$Years))
    
    # Save x position for target and limit labels :
    min_x_lab = min(histdat$Years)
    tmp_tar_lim_dat = tar_lim_dat() %>% dplyr::filter(Stock %in% these_stocks,
                                                      Var %in% input$var_ts_mult)
    
    # Start plot:
    p1 = ggplot(plotdat, aes(x = Years))
    
    # Add axes limits:
    p1 = p1 +
      scale_color_manual(values = my_col_vec()) +
      scale_fill_manual(values = my_col_vec()) +
      ylab(NULL) + xlab(my_data()$timeseries$timelab) +
      theme(legend.position = "none",
            axis.title.x = element_text(size = axs_lbl_sz),
            axis.title.y = element_text(size = axs_lbl_sz),
            axis.text = element_text(size = axs_sz),
            axis.text.y = element_text(angle = 90, hjust = 0.5),
            strip.text = element_text(size = fct_ttl_sz, face = "bold"),
            strip.placement = "outside",
            strip.background = element_blank()) +
      scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE),
                         guide = guide_axis(check.overlap = TRUE))
    
    if("inc_perc" %in% input$opts) {
      p1 = p1 + 
        geom_ribbon(data = plotdat, aes(ymin = q10, ymax = q90, fill = MPs), alpha = 0.1) +
        geom_ribbon(data = plotdat, aes(ymin = q25, ymax = q75, fill = MPs), alpha = 0.1) +
        geom_line(data = histdat, aes(y = q10), color = "gray80", linetype = "dashed") +
        geom_line(data = histdat, aes(y = q90), color = "gray80", linetype = "dashed") +
        geom_ribbon(data = histdat, aes(ymin = q25, ymax = q75), fill = "gray80", alpha = 0.5)
    }
    
    # Central line:
    if(input$central == "mean") {
      p1 = p1 +
        geom_line(aes(y = avg, color = MPs)) +
        geom_line(data = histdat, aes(x = Years, y = avg), color = "gray80") 
    }
    if(input$central == "median") {
      p1 = p1 +
        geom_line(aes(y = q50, color = MPs)) +
        geom_line(data = histdat, aes(x = Years, y = q50), color = "gray80") 
    }
    
    if("inc_mp_lab" %in% input$opts) {
      p1 = p1 + 
        geom_text_repel(data = labdat, aes(x = Years, y = q50, label = MPs, color = MPs),
                        nudge_x = 4, direction = "y", hjust = "left",
                        size = rpl_sz, segment.linetype = 6)
    }
    
    if(!("inc_hist" %in% input$opts)) {
      p1 = p1 + 
        scale_x_continuous(limits = c(my_data()$timeseries$timenow, NA))
      min_x_lab = my_data()$timeseries$timenow
    }
    
    # Add Limit and Target labels:
    tmp_tar_lim_dat$min_x_lab = min_x_lab
    p1 = p1 +
      geom_hline(data = tmp_tar_lim_dat,
                 aes(yintercept = Target),
                 color = "#000000", linetype = "dashed", na.rm = TRUE) +
      geom_hline(data = tmp_tar_lim_dat,
                 aes(yintercept = Target),
                 color = "#000000", linetype = "dashed", na.rm = TRUE) +
      geom_text(data = tmp_tar_lim_dat, aes(x = min_x_lab, y = Target, label = "Target"),
                hjust = 0, size = 5, na.rm = TRUE) +
      geom_text(data = tmp_tar_lim_dat, aes(x = min_x_lab, y = Limit, label = "Limit"),
                hjust = 0, size = 5, na.rm = TRUE)
    
    # Coordinates:
    p1 = p1 + coord_cartesian(expand = FALSE, ylim = c(0, NA))
    
    # Make panels:
    if(length(these_stocks) > 1) {
      p1 = p1 + facet_grid2(Var ~ Stock, scales = "free_y", independent = "y", switch = "y")
    } else {
      p1 = p1 + facet_wrap( ~ Var, scales = "free_y", strip.position = "left")
      if(my_data()$n_stocks > 1) p1 = p1 + ggtitle(label = these_stocks)
    }
    
    # Print plot:
    print(p1)
    
  })
  # Now render it:
  output$ts_plot_var <- renderPlot({ my_ts_plot_var() })
  
  # TIME SERIES PLOT (BY MP)
  my_ts_plot_var_mp <- reactive({
    
    # Select stocks:
    if(my_data()$n_stocks > 1) {
      these_stocks = input$stock_ts_uniq
    } else {
      these_stocks = my_data()$stocks
    }
    
    # Avoid error messages if variables are not available:
    req(input$var_ts_uniq, these_stocks, sel_mps_ts())
    
    histdat = ts_dat_hist() %>% 
      dplyr::filter(Stock %in% these_stocks,
                    Var %in% input$var_ts_uniq) 
    plotdat = ts_dat_summ() %>% dplyr::filter(Stock == these_stocks,
                                            Var == input$var_ts_uniq, 
                                            Years >= my_data()$timeseries$timenow,
                                            MPs %in% sel_mps_ts())
    labdat = plotdat %>% dplyr::filter(Years == max(plotdat$Years))
    
    # Save x position for target and limit labels :
    min_x_lab = min(histdat$Years)
    
    # Start plot:
    p1 = ggplot(plotdat, aes(x = Years))
    
    # Add axes limits:
    p1 = p1 +
      scale_color_manual(values = my_col_vec()) +
      scale_fill_manual(values = my_col_vec()) +
      labs(y = input$var_ts_uniq, x = my_data()$timeseries$timelab) +
      theme(legend.position = "none",
            axis.title.x = element_text(size = axs_lbl_sz),
            axis.title.y = element_text(size = axs_lbl_sz),
            axis.text = element_text(size = axs_sz),
            axis.text.y = element_text(angle = 90, hjust = 0.5),
            strip.text = element_text(size = fct_ttl_sz, face = "bold"),
            strip.background = element_blank()) +
      scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE),
                         guide = guide_axis(check.overlap = TRUE))
    
    if("inc_perc" %in% input$opts) {
      p1 = p1 + 
        geom_ribbon(data = plotdat, aes(ymin = q10, ymax = q90, fill = MPs), alpha = 0.1) +
        geom_ribbon(data = plotdat, aes(ymin = q25, ymax = q75, fill = MPs), alpha = 0.1) +
        geom_line(data = histdat, aes(y = q10), color = "gray80", linetype = "dashed") +
        geom_line(data = histdat, aes(y = q90), color = "gray80", linetype = "dashed") +
        geom_ribbon(data = histdat, aes(ymin = q25, ymax = q75), fill = "gray80", alpha = 0.5)
    }
    
    # Central line:
    if(input$central == "mean") {
      p1 = p1 +
        geom_line(aes(y = avg, color = MPs)) +
        geom_line(data = histdat, aes(x = Years, y = avg), color = "gray80") 
    }
    if(input$central == "median") {
      p1 = p1 +
        geom_line(aes(y = q50, color = MPs)) +
        geom_line(data = histdat, aes(x = Years, y = q50), color = "gray80") 
    }
    
    if(!("inc_hist" %in% input$opts)) {
      p1 = p1 + 
        scale_x_continuous(limits = c(my_data()$timeseries$timenow, NA))
      min_x_lab = my_data()$timeseries$timenow
    }
    
    # Add Limit and Target labels:
    p1 = p1 + 
      geom_hline(yintercept = my_data()$timeseries$target[match(input$var_ts, my_data()$timeseries$metadata[["en"]]$Code)], 
                 color = "#000000", linetype = "dashed", na.rm = TRUE) +
      geom_hline(yintercept = my_data()$timeseries$limit[match(input$var_ts, my_data()$timeseries$metadata[["en"]]$Code)], 
                 color = "#000000", linetype = "dashed", na.rm = TRUE) +
      annotate("text", label = "Target", size = 5, color = "#000000", na.rm = TRUE, hjust = 0,
               x = min_x_lab, 
               y = my_data()$timeseries$target[match(input$var_ts, my_data()$timeseries$metadata[["en"]]$Code)]) +
      annotate("text", label = "Limit", size = 5, color = "#000000", na.rm = TRUE, hjust = 0,
               x = min_x_lab, 
               y = my_data()$timeseries$limit[match(input$var_ts, my_data()$timeseries$metadata[["en"]]$Code)]) 
    
    # Coordinates:
    p1 = p1 + coord_cartesian(expand = FALSE, ylim = c(0, NA)) 
    
    # Add Stock label only if n_stocks > 1
    if(my_data()$n_stocks > 1) {
      p1 = p1 + ggtitle(label = these_stocks)
    }
    
    # Add facets and print plot:
    p1 = p1 + facet_wrap(~ MPs)
    print(p1)
    
  })
  # Now render it:
  output$ts_plot_var_mp <- renderPlot({ my_ts_plot_var_mp() })
  
  # -------------------------------------------------------------------------
  # KOBE PLOT (OVERALL)
  my_kobe_plot <- reactive({
    
    # Select stocks:
    if(my_data()$n_stocks > 1) {
      these_stocks = input$stock_kobe_mult
    } else {
      these_stocks = my_data()$stocks
    }
    
    # Avoid error messages if variables are not available:
    req(input$perc_kobe, input$y_range_kobe, 
        input$x_range_kobe, these_stocks, sel_mps_kobe())
    
    # Polygon to make Kobe:
    poly_kobe = data.frame(id = rep(1:4, each = 5), 
                           x = c(1,1,20,20,1,-1,-1,1,1,-1,-1,-1,1,1,-1,1,1,20,20,1),
                           y = c(1,-1,-1,1,1,1,-1,-1,1,1,20,1,1,20,20,20,1,1,20,20))
    
    # Data to plot:
    lst_yr_dat = lst_yr_kobe_dat() %>% filter(Stock %in% these_stocks,
                                            MPs %in% sel_mps_kobe())

    # Get median last year over iter and OMs:
    median_lst_dat = median_lst_kobe_dat() %>% filter(Stock %in% these_stocks,
                                                    MPs %in% sel_mps_kobe()) 
    # Get first year data:
    median_frs_dat = median_frs_kobe_dat() %>% filter(Stock %in% these_stocks,
                                                    MPs %in% sel_mps_kobe()) 
    
    # Get quantiles last year over iter and OMs:
    quant_lst_dat = lst_yr_dat %>% group_by(Stock, MPs, Var) %>% 
      summarise(q1 = quantile(value, probs = (1-input$perc_kobe)/2),
                q2 = quantile(value, probs = 1 - (1-input$perc_kobe)/2),
                med = quantile(value, probs = 0.5),
                .groups = "drop") %>%
      mutate(ax_type = if_else(Var == my_data()$kobe$metadata$Code[1], "x", "y")) %>%
      select(-Var) %>% pivot_wider(names_from = "ax_type", values_from = c("q1", "med", "q2"))
    
    # Temporal trajectory:
    plot_ts_dat = kobe_dat() %>% filter(Stock %in% these_stocks,
                                      MPs %in% sel_mps_kobe()) %>%
      group_by(Stock, MPs, Var, Years) %>% 
      summarise(value = median(value), .groups = "drop") %>%
      mutate(ax_type = if_else(Var == my_data()$kobe$metadata$Code[1], "x_axis", "y_axis")) %>%
      select(-Var) %>% pivot_wider(names_from = "ax_type")
    
    # Make kobe:
    p1 = ggplot(data = poly_kobe, aes(x = x, y = y)) +
      geom_polygon(aes(fill = factor(id), group = factor(id)), alpha = 1) +
      scale_fill_manual(values = c('#8dd1a8', '#fae59b', '#e29986', '#fece80')) +
      guides(fill = 'none') +
      coord_cartesian(ylim = input$y_range_kobe, xlim = input$x_range_kobe, expand = FALSE)
    
    # Add points:
    p1 = p1 +
      geom_point(data = median_lst_dat, aes(x = x_axis, 
                                            y = y_axis,
                                            color = MPs), size = 5) +
      scale_color_manual(values = my_col_vec()) +
      ylab(my_data()$kobe$metadata$Code[2]) + xlab(my_data()$kobe$metadata$Code[1]) +
      theme(legend.position = "none",
            panel.grid.major = element_blank(), 
            panel.grid.minor = element_blank(),
            axis.title.x = element_text(size = axs_lbl_sz),
            axis.title.y = element_text(size = axs_lbl_sz),
            axis.text = element_text(size = axs_sz),
            strip.text = element_text(size = fct_ttl_sz, face = "bold"),
            strip.background = element_blank())
    
    # Include MP labels:
    if("inc_lab" %in% input$opts_kobe) {
      p1 = p1 + 
        geom_text_repel(data = median_lst_dat, aes(x = x_axis, 
                                                   y = y_axis,
                                                   color = MPs,
                                                   label = MPs),
                        nudge_x = 0.3, nudge_y = 0.3, segment.linetype = 6,
                        size = rpl_sz)
    }
    
    # Add temporal line:
    if("line_kobe" %in% input$opts_kobe) {
      p1 = p1 + 
        geom_path(data = plot_ts_dat, aes(x = x_axis, y = y_axis, color = MPs)) +
        geom_point(data = median_frs_dat, aes(x = x_axis, y = y_axis, color = MPs), 
                   shape = 18, size = 3)
    }
    
    # Include error bars:
    if("err_kobe" %in% input$opts_kobe) {
      p1 = p1 + 
        geom_segment(data = quant_lst_dat, aes(x = q1_x, xend = q2_x,
                                               y = med_y, yend = med_y,
                                               color = MPs),
                     linetype = "dotted", linewidth = 1.2) +
        geom_segment(data = quant_lst_dat, aes(x = med_x, xend = med_x,
                                               y = q1_y, yend = q2_y,
                                               color = MPs),
                     linetype = "dotted", linewidth = 1.2)
    }
    
    # Make panels:
    p1 = p1 + facet_wrap(~ Stock)
    
    # Hide facet titles if n_stocks == 1
    if(my_data()$n_stocks == 1) p1 = p1 + theme(strip.text.x = element_blank())
    
    # Print plot
    print(p1)
    
  })
  # Now render it:
  output$kobe_plot <- renderPlot({ my_kobe_plot() })
  
  
  # KOBE PLOT (TIME SERIES)
  my_kobe_plot_ts <- reactive({
    
    # Select stocks:
    if(my_data()$n_stocks > 1) {
      these_stocks = input$stock_kobe_uniq
    } else {
      these_stocks = my_data()$stocks
    }
    
    # Avoid error messages if variables are not available:
    req(these_stocks, sel_mps_kobe())
    
    # Define colors, make sure you use same colors as previous plot:
    col_pal = c('cat_g' = '#8dd1a8', 'cat_y' = '#fae59b',
                'cat_r' = '#e29986', 'cat_o' = '#fece80')

    # Sort data:
    plot_ts_dat = kobe_dat() %>% filter(Stock == these_stocks,
                                      MPs %in% sel_mps_kobe()) %>%
      mutate(ax_type = if_else(Var == my_data()$kobe$metadata$Code[1], "x_axis", "y_axis")) %>%
      select(-Var) %>% pivot_wider(names_from = "ax_type")
    # Find kobe categories over the years
    kobe_cat_dat = plot_ts_dat %>% 
      mutate(cat = if_else(x_axis > 1 & y_axis < 1, "cat_g",
                           if_else(x_axis < 1 & y_axis > 1, "cat_r",
                                   if_else(x_axis > 1 & y_axis > 1, "cat_o", "cat_y"))))
    kobe_cat_dat = kobe_cat_dat %>% 
      mutate(cat = factor(cat, levels = c("cat_r", "cat_y", "cat_o", "cat_g")))
    
    # Make plot:
    p1 = ggplot(kobe_cat_dat, aes(x = Years, fill = factor(cat))) +
      geom_bar(position = "fill", width = 1, alpha = 1) +
      scale_y_continuous(labels=scales::percent,
                         guide = guide_axis(check.overlap = TRUE)) +
      scale_fill_manual(values = col_pal) +
      xlab("Year") + ylab(NULL) +
      coord_cartesian(expand = FALSE) +
      theme(legend.position = "none",
            panel.grid.major = element_blank(), 
            panel.grid.minor = element_blank(),
            axis.title.x = element_text(size = axs_lbl_sz),
            axis.title.y = element_text(size = axs_lbl_sz),
            axis.text = element_text(size = axs_sz),
            strip.text = element_text(size = fct_ttl_sz, face = "bold"),
            strip.background = element_blank()) +
      facet_wrap( ~ MPs)
    
    # Add horizontal line Kobe target
    if(!is.null(my_data()$kobe$kobe_target)) {
      p1 = p1 +
        geom_hline(yintercept = my_data()$kobe$kobe_target,
                   color = "gray40", linetype = "dashed")
    }
    
    # Add Stock label only if n_stocks > 1
    if(my_data()$n_stocks > 1) {
      p1 = p1 + ggtitle(label = these_stocks)
    }
    
    # Print plot:
    print(p1)
    
  })
  # Now render it:
  output$kobe_plot_ts <- renderPlot({ my_kobe_plot_ts() })
  

  # -------------------------------------------------------------------------
  # QUILT TABLE
  my_quilt_table <- reactive({
    
    # Select stocks:
    if(my_data()$n_stocks > 1) {
      these_stocks = input$stock_perf_uniq
    } else {
      these_stocks = my_data()$stocks
    }
    
    # Avoid error messages if variables are not available:
    req(sel_mps_perf(), sel_pis_perf(), these_stocks)
    
    mytab = perf_dat() %>% filter(Stock == these_stocks,
                                MPs %in% sel_mps_perf(),
                                PIs %in% sel_pis_perf()) %>% 
      group_by(MPs, PIs) %>% 
      summarise(value = mean(value), .groups = "drop")
    mytab = mytab %>% pivot_wider(names_from = "PIs") %>%
      tibble::column_to_rownames("MPs") %>% as.data.frame
    # Find PIs with no min-max:
    noDecPIs = my_data()$pi$metadata[["en"]]$Code[!my_data()$pi$is_decimal]
    noDecPIs = noDecPIs[noDecPIs %in% sel_pis_perf()]
    decPIs = my_data()$pi$metadata[["en"]]$Code[my_data()$pi$is_decimal]
    decPIs = decPIs[decPIs %in% sel_pis_perf()]
    
    # Add Stock label only if n_stocks > 1
    if(my_data()$n_stocks > 1) {
      tab_caption = these_stocks
    } else {
      tab_caption = ""
    }
    
    t1 = datatable(mytab, filter = 'top', 
                   extensions = 'Buttons',
                   options = list(dom = 'tB',
                                  autoWidth = TRUE,
                                  buttons = c('copy', 'csv'),
                                  pageLength = nrow(mytab)),
                   caption = tags$caption(
                     style = "caption-side: top; font-weight: bold; font-size: 18px;",
                     tab_caption
                   ),
                   class = list(stripe = FALSE)
    ) %>%
      formatRound(decPIs, digits=2) %>%
      formatRound(noDecPIs, digits=0) %>%
      formatStyle(columns = " ",
                  fontWeight = "bold")
    
    if(isTRUE(input$opts_quilt)) {
      # Add background color by columns:
      colfunc = colorRampPalette(c("white", "#FCDA01"))
      for(k in 1:ncol(mytab)) {
        brks = quantile(mytab[k], probs = seq(0, 1, .05), na.rm = TRUE)
        clrs = colfunc(length(brks) + 1)
        t1 = t1 %>% formatStyle(colnames(mytab)[k], 
                                backgroundColor = styleInterval(brks, clrs) )
      }
    }
    
    # Print table:
    t1
    
  })
  # Now render it:
  output$quilt_table <- DT::renderDataTable({ my_quilt_table() })
  
  
  # SPIDER PLOT
  my_spd_plot <- reactive({
    
    # Select stocks:
    if(my_data()$n_stocks > 1) {
      these_stocks = input$stock_perf_uniq
    } else {
      these_stocks = my_data()$stocks
    }
    
    # Avoid error messages if variables are not available:
    req(sel_mps_perf(), sel_pis_perf(), these_stocks)
    
    # Sort data:
    mytab = perf_dat() %>% filter(Stock == these_stocks,
                                MPs %in% sel_mps_perf(),
                                PIs %in% sel_pis_perf()) %>%
      group_by(MPs, PIs) %>% 
      summarise(value = mean(value), .groups = "drop")
    mytab = mytab %>% pivot_wider(names_from = "PIs") %>%
      tibble::column_to_rownames("MPs") %>% as.data.frame
    # Rescale:
    mytab_res = mytab %>% ungroup() %>%
      mutate_all(my_scale_fun) 
    
    # Find selected metrics:
    these_metrics = colnames(mytab)
    
    # Start making plot:
    p1 = plot_ly(
      type = 'scatterpolar',
      fill = 'none',
      mode = "lines+markers",
      line = list(width = 2),
      hovertemplate = "MP: %{fullData.name}<br>Value: %{text:,.2f}<extra></extra>"
    )
    
    # Aggregate lines per MP:
    for(i in 1:nrow(mytab)) {
      
      # Find MP name:
      mp_name = rownames(mytab)[i]
      
      # Values per PI:
      plot_vec_res = mytab_res %>% slice(i) %>% as.numeric
      plot_vec = mytab %>% slice(i) %>% as.numeric
      
      # Aggregate to plot:
      p1 = p1 %>%
        add_trace(
          r = plot_vec_res,
          theta = paste0("<b>", these_metrics, "</b>"),
          name = mp_name,
          text = plot_vec,
          line = list(color = my_col_vec()[mp_name]),
          marker = list(color = my_col_vec()[mp_name])
        )
      
    }
    
    # Define title if n_stock > 1
    if(my_data()$n_stocks > 1) {
      plot_title = these_stocks
    } else {
      plot_title = ""
    }
    
    # Include legend colors (for printing):
    show_leg_spd = FALSE
    if(isTRUE(input$opts_perf_spd)) {
      show_leg_spd = TRUE
    }
    
    # Add custom:
    p1 = p1 %>%
      layout(
        title = list(
          text = paste0("<b>", plot_title, "</b>"), 
          x = 0,                         
          xanchor = "left"              
        ),
        showlegend = show_leg_spd,
        legend = list(
          font = list(
            size = 16
          )
        ),
        polar = list(
          angularaxis = list(
            tickfont = list(
              size = fct_ttl_sz
            )
          ),
          radialaxis = list(
            visible = FALSE
          )
        )
      )
    
    # Print:
    p1
    
  })
  # Now render it:
  output$spd_plot <- renderPlotly({ my_spd_plot() })

  
  # BOXPLOT
  my_box_plot <- reactive({

    # Select stocks:
    if(my_data()$n_stocks > 1) {
      these_stocks = input$stock_perf_uniq
    } else {
      these_stocks = my_data()$stocks
    }
    
    # Avoid error messages if variables are not available:
    req(sel_mps_perf(), sel_pis_perf(), these_stocks)

    # Sort data:
    mytab = perf_dat() %>% filter(Stock == these_stocks,
                                MPs %in% sel_mps_perf(),
                                PIs %in% sel_pis_perf()) 
    # mytab = mytab %>%
    #   group_by(MPs, PIs) %>%
    #   summarise(q1min = quantile(value, probs = 0.05), 
    #             q1max = quantile(value, probs = 0.95),
    #             q2min = quantile(value, probs = 0.25),
    #             q2max = quantile(value, probs = 0.75),
    #             med = quantile(value, probs = 0.5),
    #             .groups = "drop")
    
    # Make plot:
    p1 = ggplot(data = mytab, aes(x = MPs, y = value, fill = MPs)) +
      # geom_point(size = 2) +
      # geom_pointrange(aes(ymin = q1min, ymax = q1max)) +
      # geom_pointrange(aes(ymin = q2min, ymax = q2max), linewidth = 1.75) +
      geom_violin() +
      scale_fill_manual(values = my_col_vec()) +
      ylab(NULL) + xlab(NULL) +
      scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE),
                         guide = guide_axis(check.overlap = TRUE)) +
      theme(legend.position = "none",
            axis.title.x = element_text(size = axs_lbl_sz),
            axis.title.y = element_text(size = axs_lbl_sz),
            axis.text.y = element_text(angle = 90, hjust = 0.5),
            axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
            axis.text = element_text(size = axs_sz),
            strip.text = element_text(size = fct_ttl_sz, face = "bold"),
            strip.background = element_blank())
    
    # Make panels:
    p1 = p1 + facet_wrap(~ PIs, scales = "free_y")
    
    # Add Stock label only if n_stocks > 1
    if(my_data()$n_stocks > 1) {
      p1 = p1 + ggtitle(label = these_stocks)
    }
    
    # Print plot
    print(p1)

  })
  # Now render it:
  output$box_plot <- renderPlot({ my_box_plot() })


  # -------------------------------------------------------------------------
  # TRADEOFF PLOT
  my_td_plot <- reactive({

    # Select stocks:
    if(my_data()$n_stocks > 1) {
      these_stocks = input$stock_td_mult
    } else {
      these_stocks = my_data()$stocks
    }
    
    # Avoid error messages if variables are not available:
    req(sel_mps_td(), these_stocks)
    
    # Sort data:
    mytab = perf_dat() %>% filter(Stock %in% these_stocks,
                                 MPs %in% sel_mps_td()) %>% 
      group_by(Stock, MPs, PIs) %>% 
      summarise(value = mean(value), .groups = "drop")
    mytab = mytab %>% pivot_wider(names_from = "PIs")
    
    # Define cols to plot:
    x = parse_quo(input$pi_x_td, env = caller_env())
    y = parse_quo(input$pi_y_td, env = caller_env())
    
    # Make kobe:
    p1 = ggplot(data = mytab, aes(x = !!x, y = !!y)) +
      geom_point(aes(color = MPs), size = 4) +
      scale_color_manual(values = my_col_vec()) +
      ylab(input$pi_y_td) + xlab(input$pi_x_td) +
      geom_text_repel(aes(color = MPs, label = MPs), segment.linetype = 6,
                      size = rpl_sz) +
      scale_x_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE),
                         guide = guide_axis(check.overlap = TRUE)) +
      scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE),
                         guide = guide_axis(check.overlap = TRUE)) +
      theme(legend.position = "none",
            axis.title.x = element_text(size = axs_lbl_sz),
            axis.title.y = element_text(size = axs_lbl_sz),
            axis.text = element_text(size = axs_sz),
            axis.text.y = element_text(angle = 90, hjust = 0.5),
            strip.text = element_text(size = fct_ttl_sz, face = "bold"),
            strip.background = element_blank())
    
    # Make panels:
    p1 = p1 + facet_wrap(~ Stock, scales = "free")
    
    # Hide facet titles if n_stocks == 1
    if(my_data()$n_stocks == 1) p1 = p1 + theme(strip.text.x = element_blank())
    
    # Print plot
    print(p1)
    
  })
  # Now render it:
  output$td_plot <- renderPlot({ my_td_plot() })

  # -------------------------------------------------------------------------
  # FLEET CATCH PLOT
  my_flt_plot <- reactive({
    
    # Select stocks:
    if(my_data()$n_stocks > 1) {
      these_stocks = input$stock_flt_mult
    } else {
      these_stocks = my_data()$stocks
    }
    
    # Avoid error messages if variables are not available:
    req(sel_fleet_flt(), sel_mps_flt(), input$opts_flt, input$central_flt, 
        input$var_fleet, these_stocks)
    
    # Filter:
    plotdat = fleet_dat_summ() %>% dplyr::filter(Stock %in% these_stocks,
                                                 Var == input$var_fleet,
                                                 Fleet %in% sel_fleet_flt(), 
                                                 MPs %in% sel_mps_flt())
    labdat = plotdat %>% dplyr::filter(Years == max(plotdat$Years))
    
    # Start plot:
    p1 = ggplot(plotdat, aes(x = Years))
    
    # Add axes limits:
    p1 = p1 +
      scale_color_manual(values = my_col_vec()) +
      scale_fill_manual(values = my_col_vec()) +
      ylab(input$var_fleet) + xlab(my_data()$timeseries$timelab) +
      theme(legend.position = "none",
            axis.title.x = element_text(size = axs_lbl_sz),
            axis.title.y = element_text(size = axs_lbl_sz),
            axis.text = element_text(size = axs_sz),
            axis.text.y = element_text(angle = 90, hjust = 0.5),
            strip.text = element_text(size = fct_ttl_sz, face = "bold"),
            strip.placement = "outside",
            strip.background = element_blank()) +
      scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE),
                         guide = guide_axis(check.overlap = TRUE))
    
    if("inc_perc" %in% input$opts_flt) {
      p1 = p1 + 
        geom_ribbon(data = plotdat, aes(ymin = q10, ymax = q90, fill = MPs), alpha = 0.1) +
        geom_ribbon(data = plotdat, aes(ymin = q25, ymax = q75, fill = MPs), alpha = 0.1) 
    }
    
    # Central line:
    if(input$central_flt == "mean") {
      p1 = p1 +
        geom_line(aes(y = avg, color = MPs)) 
    }
    if(input$central_flt == "median") {
      p1 = p1 +
        geom_line(aes(y = q50, color = MPs))
    }
    
    if("inc_mp_lab" %in% input$opts_flt) {
      p1 = p1 + 
        geom_text_repel(data = labdat, aes(x = Years, y = q50, label = MPs, color = MPs),
                        nudge_x = 4, direction = "y", hjust = "left",
                        size = rpl_sz, segment.linetype = 6)
    }
    
    # Coordinates:
    p1 = p1 + coord_cartesian(expand = FALSE, ylim = c(0, NA))
    
    # Make panels:
    if(length(these_stocks) > 1) {
      p1 = p1 + facet_grid2(Fleet ~ Stock, scales = "free_y", independent = "y")
    } else {
      p1 = p1 + facet_wrap( ~ Fleet, scales = "free_y")
      if(my_data()$n_stocks > 1) p1 = p1 + ggtitle(label = these_stocks)
    }
    
    # Print plot:
    print(p1)
    
  })
  # Now render it:
  output$flt_plot <- renderPlot({ my_flt_plot() })

  # -------------------------------------------------------------------------
  
  # INFORMATION TABLE TS:
  output$info_tab_ts <- renderDT({
    tab <- my_data()$timeseries$metadata[[lang_code()]]
    DT::datatable(tab, rownames = FALSE, 
                  options = list(dom = 't', ordering=F, autoWidth = TRUE, pageLength = nrow(tab))) %>%
      formatStyle(columns = 1:ncol(tab), fontSize = "100%")
  })
  # INFORMATION TABLE OM:
  output$info_tab_om <- renderDT({
    tab <- my_data()$om$metadata[[lang_code()]]
    DT::datatable(tab, 
                  options = list(dom = 't', ordering=F, autoWidth = TRUE, pageLength = nrow(tab))) %>%
      formatStyle(columns = 1:ncol(tab), fontSize = "100%") %>%
      formatStyle(columns = " ", fontWeight = "bold")
  })
  # INFORMATION TABLE MP:
  output$info_tab_mp <- renderDT({
    tab <- my_data()$mp$metadata[[lang_code()]]
    DT::datatable(tab, rownames = FALSE,
                  options = list(dom = 't', ordering=F, autoWidth = TRUE, pageLength = nrow(tab))) %>%
      formatStyle(columns = 1:ncol(tab), fontSize = "100%")
  })
  # INFORMATION TABLE PI:
  output$info_tab_pi <- renderDT({
    tab <- my_data()$pi$metadata[[lang_code()]]
    DT::datatable(tab, rownames = FALSE,
                  options = list(dom = 't', ordering=F, autoWidth = TRUE, pageLength = nrow(tab))) %>%
      formatStyle(columns = 1:ncol(tab), fontSize = "100%")
  })
  # INFORMATION TABLE FLEET:
  output$info_tab_flt <- renderDT({
    tab <- my_data()$fleet$metadata[[lang_code()]]
    DT::datatable(tab, rownames = FALSE,
                  options = list(dom = 't', ordering=F, autoWidth = TRUE, pageLength = nrow(tab))) %>%
      formatStyle(columns = 1:ncol(tab), fontSize = "100%")
  })
  
}