# Create translation dictionaries for each language
i18n_translations <- list(
  en = list(
    # NAV titles:
    about = "About",
    time_series = "Time Series",
    kobe = "Kobe",
    performance = "Performance",
    tradeoff = "Trade-off",
    fleet = "Fleet",
    # CARD titles:
    ts_ov_title = "Overall",
    ts_mp_title = "By MP",
    ts_om_title = "By OM",
    kobe_ov_title = "Overall",
    kobe_time_title = "By Year",
    # SIDEBAR sections:
    about_chart = "About This Chart", 
    select_stock = "Select Stock(s)",
    select_variable = "Select Variable(s)",
    select_mp = "Select Management Procedure(s)",
    select_pi = "Select Performance Indicators(s)",
    select_fleet = "Select Fleet(s)",
    other_settings = "Other Settings",
    update_plot = "Apply Selection",
    # Help button About this plot:
    std_text_1 = " derived from ", # standard text for all navs
    std_text_2 = " different simulation runs across ", # standard text for all navs
    std_text_3 = " OMs.", # standard text for all navs
    std_text_4 = "For more information on ", # standard text for all navs
    std_text_5 = " on the top-right side of this site.", # standard text for all navs
    help_ts_1 = "This chart shows changes in a selected variable over time. Two periods are differentiated: historical (gray) and projection (colored). Colors represent different MPs. The continuous line represents the median or mean",
    help_ts_2 = "Uncertainty is shown as shadow: darker and lighter areas contain 50% and 90% of values, respectively. Note that, for the historical period, the 90% of values are shown as dashed lines.",
    help_ts_3 = "We can also display these quantities in different panels by MP (see tabs).",
    help_ts_4 = "variables, MPs, and OMs, see ",
    help_kobe_1 = "A Kobe plot is a visual way to show the status of a stock, which is commonly categorized into four colored quadrants.
         This categorization depends on fishing mortality and biomass relative to reference points (e.g., maximum sustainable yield).
         The larger colored dots represent the median value for the final year of the projection period, and they are",
    help_kobe_2 = "Error bars around medians, represented as dotted lines, can be added. Values over projection years can also be added.",
    help_kobe_3 = "Changes in stock status probability over projection years by MPs are shown in the 'By Year' tab.",
    help_kobe_4 = "MPs, see ",
    help_perf_1 = "The quilt table compares the selected PIs (columns) by MP (rows). 
         Color shading can be added, where color intensity ranges from lowest to highest value by PI (column). 
         Displayed PIs are the mean",
    help_perf_2 = "The spider (or radar) plot compares multiple PIs (axes) across different MPs, with each MP is shown as a separate colored line whose distance from the center reflects its values.",
    help_perf_3 = "The violin shows where the selected PI values are concentrated and how they are distributed, using width to represent frequency. 
         Panels represent selected PI while x-axis and colors represent MPs.",
    help_perf_4 = "MPs and PIs, see ",
    help_td_1 = "This chart shows the trade-off between two selected PIs by MP (colored dots). PIs are the mean",
    help_td_2 = "MPs and PIs, see ",
    help_fleet_1 = "This chart shows changes in fleet-specific variables over projection years. 
         Colors represent different MPs. The continuous line represents the median or mean",
    help_fleet_2 = "Uncertainty is shown as shadow: darker and lighter areas contain 50% and 90% of values, respectively.",
    help_fleet_3 = "variables, MPs and Fleets, see ",
    # About nav page:
    last_update = "Last update:",
    summary = "Summary",
    description_plots = "Description Of Plots",
    description_ts = "Figures show the changes over the years of user-specified variables (e.g., total allowable catch, spawning biomass) for two periods: historial and projection. Colors represent different management procedures (MPs).",
    description_kobe = "Four-quadrant figure that maps fishing mortality to biomass relative to reference points (e.g., maximum sustainable yield) for years in the projection period.",
    description_perf = "Quilt, Spider, and Violin figures to compare the performance among MPs by using a set of performance indicators (PIs).",
    description_td = "Scatterplot that compares two selected PIs among MPs.",
    description_fleet = "Catch per fleet and MP for every year in the projection period.",
    # Download options:
    download_plot = "Download Plot",
    dwn_box_title = "Download Settings",
    dwn_box_name = "File Name (PNG)",
    dwn_box_width = "Width (mm)",
    dwn_box_height = "Height (mm)",
    dwn_box_res = "Resolution (dpi)",
    dwn_box_cancel = "Cancel",
    dwn_box_download = "Download",
    median = "Median",
    mean = "Mean",
    percentiles = "Include Percentiles?",
    mp_labels = "Include MP Labels?",
    historical = "Include Historical?",
    error_bars = "Include Error Bars?",
    line_proj_period = "Show line for entire projection period?",
    by_mp = "By MP?",
    ind_sim = "By Individual Simulation?",
    col_scaling = "Add Color Scaling?",
    col_mp_leg = "Include MP Color Legend?",
    x_range = "X-Axis Range",
    y_range = "Y-Axis Range",
    percentile_kobe = "Percentile",
    trafeoff_x_axis = "X Axis Performance Indicator",
    trafeoff_y_axis = "Y Axis Performance Indicator",
    color_blind = "Use colorblind-friendly palette?",
    color_blind_yes = "Active",
    color_blind_no = "Inactive",
    language = "Select language:",
    information = "Information",
    ts_variables = "Time Series Variables",
    operating_models = "Operating Models (OMs)",
    management_procedures = "Management Procedures (MPs)",
    performance_indicators = "Performance Indicators (PIs)",
    fleets = "Fleets"
  ),
  es = list(
    about = "Acerca de",
    time_series = "Series Temporales",
    kobe = "Kobe",
    performance = "Desempeño",
    tradeoff = "Trade-off",
    fleet = "Flota",
    # CARD titles:
    ts_ov_title = "Global",
    ts_mp_title = "Por MP",
    ts_om_title = "Por OM",
    kobe_ov_title = "Global",
    kobe_time_title = "Por Año",
    # SIDEBAR sections:
    about_chart = "Acerca de este gráfico",
    select_stock = "Seleccionar Stock(s)",
    select_variable = "Seleccionar Variable(s)",
    select_mp = "Seleccionar Procedimiento de Manejo(s)",
    select_pi = "Seleccionar Indicador(es) de Desempeño",
    select_fleet = "Seleccionar Flota(s)",
    other_settings = "Otras Configuraciones",
    update_plot = "Aplicar Selección",
    # Help button About this plot:
    std_text_1 = " calculado de ", # standard text for all navs
    std_text_2 = " simulaciones a lo largo de ", # standard text for all navs
    std_text_3 = " OMs.", # standard text for all navs
    std_text_4 = "Para mayor información sobre ",
    std_text_5 = " en la esquina superior derecha de este sitio.", # standard text for all navs
    help_ts_1 = "Estos gráficos muestran cambios temporales en una variable selectionada. Dos periodos son diferenciados: histórico (gris) y proyección (coloreado). Colores representan diferentes MPs. La línea continua representa la media o mediana",
    help_ts_2 = "Incertidumbre es representada como sombras: áreas más oscuras y más claras contienen el 50% y 90% de valores, respectivamente. Notar que, para el periodo histórico, el 90% de valores es mostrado como líneas punteadas.",
    help_ts_3 = "También podemos mostrar estos valores en paneles por MP (ver pestañas).",
    help_ts_4 = "variables, MPs, y OMs, ver ",
    help_kobe_1 = "Un gráfico de Kobe es una forma visual de representar el estado de un stock, el cual puede ser categorizado en cuatro cuadrantes coloreados. 
    Esta categorización depende de valores de mortalidad por pesca y biomasa relativos a puntos de referencia (p.ej., máximo rendimiento sostenible).
    Los puntos más grandes representan la mediana para el año final del periodo de proyección,",
    help_kobe_2 = "Barras de errores alrededor de la mediana, representado por líneas punteadas, puede ser agregado. Valores para cada año del periodo de proyección también puede ser añadido.",
    help_kobe_3 = "Cambios en la probabilidad del estado del stock a lo largo de los años del periodo de proyección por MP es mostrado en la pestaña 'Por Año'.",
    help_kobe_4 = "MPs, ver ",
    help_perf_1 = "La tabla 'Quilt' compara los PIs seleccionados (columnas) por MP (filas).
         Sombreado para cada celda puede ser añadido, donde la intensidad de color varía desde el valor más bajo al más alto de cada PI.
         Los PIs mostrados son la media",
    help_perf_2 = "El gráfico 'Spider' (o de radar) compara varios PIs (ejes) entre diferentes MPs, y cada MP se representa mediante una línea de color independiente cuya distancia al centro refleja sus valores.",
    help_perf_3 = "El gráfico de violín muestra dónde se concentran los valores de PI seleccionados y cómo se distribuyen, utilizando la anchura para representar la frecuencia. 
         Los paneles representan los PI seleccionados, mientras que el eje X y los colores representan los MPs.",
    help_perf_4 = "MPs y PIs, ver ",
    help_td_1 = "Este gráfico muestra el 'trade-off' entre dos PI seleccionadas por MP (puntos coloreados). PIs son la media",
    help_td_2 = "MPs y PIs, ver ",
    help_fleet_1 = "Este gráfico muestra los cambios en la captura por flota a lo largo de los años del periodo de proyección.
          Colores representan diferentes MPs. La línea continua representa la media o mediana",
    help_fleet_2 = "La incertidumbre es representada como sombras: áreas oscuras y claras contienen el 50% y 90% de valores, respectivamente.",
    help_fleet_3 = "variables, MPs y Flotas, ver ",
    # About nav page:
    last_update = "Última actualización:",
    summary = "Resumen",
    description_plots = "Descripción de los gráficos",
    description_ts = "Gráficos muestran cambios anuales de variables especificadas por el usuario (e.g., captura total permisible, biomasa desovante) para dos periodos: histórico y proyección. Colores representan diferentes procedimientos de manejo (MPs).",
    description_kobe = "Gráfico de cuatro cuadrantes que muestra la mortalidad por pesca y biomasa relativo a puntos de referencia (p.ej., rendimiento máximo sostenible) para años en el periodo de proyección.",
    description_perf = "Gráficos Quilt, Spider, y Violin para comparar el desempeño entre MPs mediante el uso de un conjunto de indicadores de desempeño (PIs).",
    description_td = "Gráfico de dispersión que comparar dos PIs seleccionados entre MPs.",
    description_fleet = "Captura por flota y MP para los años del periodo de proyección.",
    # Download options:
    download_plot = "Descargar gráfico",
    dwn_box_title = "Configuración de Descarga",
    dwn_box_name = "Nombre de Archivo (PNG)",
    dwn_box_width = "Ancho (mm)",
    dwn_box_height = "Alto (mm)",
    dwn_box_res = "Resolución (dpi)",
    dwn_box_cancel = "Cancelar",
    dwn_box_download = "Descargar",
    median = "Mediana",
    mean = "Media",
    percentiles = "¿Incluir percentiles?",
    mp_labels = "¿Incluir etiquetas de MP?",
    historical = "¿Incluir histórico?",
    error_bars = "¿Incluir Barras de Error?",
    line_proj_period = "¿Mostrar línea para todo el periodo de proyección?",
    by_mp = "Por MP?",
    ind_sim = "Por Simulación Individual?",
    col_scaling = "Añadir Escala de Colores?",
    col_mp_leg = "Incluir Leyenda de Colores de MPs?",
    x_range = "Rango Eje X",
    y_range = "Rango Eje Y",
    percentile_kobe = "Percentil",
    trafeoff_x_axis = "Indicador de Desempeño Eje X",
    trafeoff_y_axis = "Indicador de Desempeño Eje Y",
    color_blind = "¿Usar paleta amigable para daltónicos?",
    color_blind_yes = "Activo",
    color_blind_no = "Inactivo",
    language = "Seleccionar idioma:",
    information = "Información",
    ts_variables = "Variables de Series Temporales",
    operating_models = "Modelos Operacionales (OM)",
    management_procedures = "Procedimientos de Manejo (MP)",
    performance_indicators = "Indicadores de Desempeño (PI)",
    fleets = "Flotas"
  ),
  fr = list(
    about = "À propos",
    time_series = "Séries Temporelles",
    kobe = "Kobe",
    performance = "Performance",
    tradeoff = "Trade-off",
    fleet = "Flotte",
    # CARD titles:
    ts_ov_title = "Global",
    ts_mp_title = "Par MP",
    ts_om_title = "Par OM",
    kobe_ov_title = "Global",
    kobe_time_title = "Par Année",
    # SIDEBAR sections:
    about_chart = "À propos de ce graphique",
    select_stock = "Sélectionner le(s) stock(s)",
    select_variable = "Sélectionner variable(s)",
    select_mp = "Sélectionner procédure(s) de gestion",
    select_pi = "Sélectionner indicateurs de performance",
    select_fleet = "Sélectionner flotte(s)",
    other_settings = "Autres paramètres",
    update_plot = "Appliquer Sélection",
    # Help button About this plot:
    std_text_1 = " tiré de ", # standard text for all navs
    std_text_2 = " différentes simulations réalisées ", # standard text for all navs
    std_text_3 = " OMs.", # standard text for all navs
    std_text_4 = "Pour plus d'informations sur ", # standard text for all navs
    std_text_5 = " en haut à droite de ce site.", # standard text for all navs
    help_ts_1 = "Ce graphique illustre l'évolution d'une variable donnée au fil du temps. On distingue deux périodes : la période historique (en gris) et la période de projection (en couleur). Les couleurs représentent différents députés. La ligne continue correspond à la médiane ou à la moyenne",
    help_ts_2 = "L'incertitude est représentée par des nuances d'ombre: les zones plus sombres et plus claires correspondent respectivement à 50 % et 90 % des valeurs. Notez que, pour la période historique, les 90 % des valeurs sont représentés par des lignes pointillées.",
    help_ts_3 = "Nous pouvons également afficher ces quantités dans différents panneaux par MP (voir les onglets).",
    help_ts_4 = "variables, MPs, et OMs, voir ",
    help_kobe_1 = "Un graphique de Kobe est un outil visuel permettant de représenter l'état d'un stock, généralement classé en quatre quadrants colorés.
         Cette classification dépend de la mortalité par pêche et de la biomasse par rapport à des points de référence (par exemple, le rendement maximal durable).
         Les points colorés les plus grands représentent la valeur médiane pour la dernière année de la période de projection, et ils sont",
    help_kobe_2 = "Il est possible d'ajouter des barres d'erreur autour des médianes, représentées par des lignes pointillées. Des valeurs pour les années de projection peuvent également être ajoutées.",
    help_kobe_3 = "Les variations de la probabilité de l'état des stocks au cours des années de projection, par MP, sont présentées dans l'onglet 'Par année'.",
    help_kobe_4 = "MPs, voir ",
    help_perf_1 = "Le tableau 'Quilt' présente les indices de performance (PI) sélectionnés (colonnes) par modèle de performance (MP) (lignes). 
         Il est possible d'ajouter un dégradé de couleurs, l'intensité de la couleur variant de la valeur la plus basse à la plus élevée pour chaque PI (colonne). 
         Les PI affichés correspondent à la moyenne",
    help_perf_2 = "Le graphique 'Spider' (ou radar) compare plusieurs PIs (axes) entre différents MPs, chaque MP étant représenté par une ligne colorée distincte dont la distance par rapport au centre reflète ses valeurs.",
    help_perf_3 = "Le graphique en violon montre où se concentrent les valeurs PI sélectionnées et comment elles sont réparties, la largeur représentant la fréquence. 
         Les panneaux représentent les PI sélectionnées, tandis que l'axe des x et les couleurs représentent les MPs.",
    help_perf_4 = "MPs et PIs, voir ",
    help_td_1 = "Ce graphique illustre le compromis entre deux indicateurs de performance (PI) sélectionnés par MP (points colorés). Les PI correspondent à la moyenne",
    help_td_2 = "MPs et PIs, voir ",
    help_fleet_1 = "Ce graphique présente l'évolution des variables spécifiques à la flotte au cours des années de projection. 
         Les couleurs représentent les différents MP. La ligne continue représente la médiane ou la moyenne",
    help_fleet_2 = "L'incertitude est représentée par des nuances d'ombre : les zones plus sombres et plus claires correspondent respectivement à 50 % et 90 % des valeurs.",
    help_fleet_3 = "variables, MPs et Flottes, voir ",
    # About nav page:
    last_update = "Dernière mise à jour:",
    summary = "Résumé",
    description_plots = "Description des graphiques",
    description_ts = "Les figures illustrent l’évolution, au fil des ans, des variables définies par l’utilisateur (par exemple, le total admissible des captures, la biomasse reproductrice) pour deux périodes : historique et prospective. Les couleurs représentent différentes procédures de gestion (MPs).",
    description_kobe = "Graphique à quatre quadrants qui représente la mortalité par pêche en fonction de la biomasse par rapport à des points de référence (par exemple, le rendement maximal durable) pour les années de la période de projection.",
    description_perf = "Graphiques Quilt, Spider et Violin pour comparer les performances des MP en utilisant un ensemble d'indicateurs de performance (PIs).",
    description_td = "Diagramme de dispersion comparant deux PI sélectionnés parmi les MP.",
    description_fleet = "Captures par flotte et MP pour chaque année de la période de projection.",
    # Download options:
    download_plot = "Télécharger le graphique",
    dwn_box_title = "Paramètres de téléchargement",
    dwn_box_name = "Nom du fichier (PNG)",
    dwn_box_width = "Largeur (mm)",
    dwn_box_height = "Hauteur (mm)",
    dwn_box_res = "Résolution (dpi)",
    dwn_box_cancel = "Annuler",
    dwn_box_download = "Télécharger",
    median = "Médiane",
    mean = "Moyenne",
    percentiles = "Inclure les percentiles?",
    mp_labels = "Inclure les étiquettes MP?",
    historical = "Inclure l'historique?",
    error_bars = "Inclure les barres d'erreur?",
    line_proj_period = "Afficher la ligne pour toute la période de projection?",
    by_mp = "Par MP?",
    ind_sim = "Par Simulation Individuelle?",
    col_scaling = "Ajouter l'échelle des couleurs?",
    col_mp_leg = "Inclure la légende des couleurs MP?",
    x_range = "Plage de l'axe X",
    y_range = "Plage de l'axe Y",
    percentile_kobe = "Percentile",
    trafeoff_x_axis = "Indicateur de Performance Axe X",
    trafeoff_y_axis = "Indicateur de Performance Axe Y",
    color_blind = "Utiliser une palette adaptée aux daltoniens?",
    color_blind_yes = "Active",
    color_blind_no = "Inactive",
    language = "Sélectionner langue:",
    information = "Information",
    ts_variables = "Variables de séries temporelles",
    operating_models = "Modèles opérationnels (OM)",
    management_procedures = "Procédures de gestion (MP)",
    performance_indicators = "Indicateurs de performance (PI)",
    fleets = "Flottes"
  )
)

# Function to get translated text
tt <- function(key, lang = "en") {
  if (lang %in% names(i18n_translations) && key %in% names(i18n_translations[[lang]])) {
    return(i18n_translations[[lang]][[key]])
  }
  # Fallback to English if translation not found
  if (key %in% names(i18n_translations$en)) {
    return(i18n_translations$en[[key]])
  }
  return(key)  # Return key if no translation found
}