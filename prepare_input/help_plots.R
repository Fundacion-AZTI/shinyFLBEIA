# Load libraries
library(ggplot2)
library(ggradar)

# Violin (old) ------------------------------------------------------------------

# # Create simple example data
# set.seed(1)
# fake_data <- data.frame(
#   group = "Example",
#   values = c(rnorm(200, mean = 70, sd = 10))
# )
# 
# # Create violin plot
# p1 = ggplot(fake_data, aes(x = group, y = values)) +
#   geom_violin(fill = "#ffffff", color = "#ffffff") +
#   # Add simple explanatory text
#   annotate("text", x = 1.1, y = 95, label = "Rare results", size = 5, hjust = 0, color = '#ffffff') +
#   annotate("text", x = 1.1, y = 45, label = "Rare results", size = 5, hjust = 0, color = '#ffffff') +
#   annotate("text", x = 1, y = 70, label = "Most frequent results", size = 5) +
#   # Clean theme for non-technical audience
#   theme_void() +
#   theme(plot.background = element_rect(fill = '#000000', colour = '#000000'))
# ggsave(filename = file.path("www", 'violin.png'), plot = p1, 
#        width = 80, height = 70, units = "mm", dpi = 300)


# Violin (errorbar) ------------------------------------------------------------------

# Create simple example data
set.seed(1)
fake_data <- data.frame(
  group = "MP_1",
  value = c(rnorm(200, mean = 70, sd = 10))
)
data_summ = fake_data %>%
  group_by(group) %>%
  summarise(q1min = quantile(value, probs = 0.05),
            q1max = quantile(value, probs = 0.95),
            q2min = quantile(value, probs = 0.25),
            q2max = quantile(value, probs = 0.75),
            med = quantile(value, probs = 0.5),
            .groups = "drop")

# Create violin plot
p1 = ggplot(data = fake_data, aes(x = group, y = value)) +
  geom_point(size = 0.5, alpha = 0.3, position = position_jitter(width = 0.05, height = 0), color = '#ffffff') +
  geom_pointrange(data = data_summ, aes(y = med, ymin = q1min, ymax = q1max), color = '#ffffff') +
  geom_pointrange(data = data_summ, aes(y = med, ymin = q2min, ymax = q2max), linewidth = 1.75, color = '#ffffff') +
  geom_point(data = data_summ, aes(y = med), size = 2.75, color = '#ffffff') +
  # Add simple explanatory text
  annotate("text", x = 1.06, y = 85, label = "Where 90% of values fall", size = 4.5, hjust = 0, color = '#ffffff') +
  annotate("text", x = 1.08, y = 65, label = "Where 50% of values fall", size = 4.5, hjust = 0, color = '#ffffff') +
  annotate("text", x = 1.11, y = 70, label = "Most typical value", hjust = 0, size = 4.5, color = '#ffffff') +
  # Add brackets 1:
  annotate("segment", x = 1.05, xend = 1.05, y = data_summ$q1min, yend = data_summ$q1max, 
           size = 0.9, color = "#ffffff") +
  annotate("segment", x = 1.03, xend = 1.05, y = data_summ$q1min, yend = data_summ$q1min, 
           size = 0.9, color = "#ffffff") +
  annotate("segment", x = 1.03, xend = 1.05, y = data_summ$q1max, yend = data_summ$q1max, 
           size = 0.9, color = "#ffffff") +
  # Add brackets 2:
  annotate("segment", x = 1.07, xend = 1.07, y = data_summ$q2min, yend = data_summ$q2max, 
           size = 0.9, color = "#ffffff") +
  annotate("segment", x = 1.04, xend = 1.07, y = data_summ$q2min, yend = data_summ$q2min, 
           size = 0.9, color = "#ffffff") +
  annotate("segment", x = 1.04, xend = 1.07, y = data_summ$q2max, yend = data_summ$q2max, 
           size = 0.9, color = "#ffffff") +
  # Add arrow for median:
  geom_segment(x = 1.02, xend = 1.1, y = data_summ$med, yend = data_summ$med, 
               arrow =  arrow(length = unit(0.15, "cm")), 
               color = "#ffffff") +
  # Clean theme for non-technical audience
  theme_void() +
  theme(plot.background = element_rect(fill = '#000000', colour = '#000000'))
ggsave(filename = file.path("www", 'violin.png'), plot = p1, 
       width = 120, height = 65, units = "mm", dpi = 300)


# Time Series -------------------------------------------------------------

# Load libraries
library(ggplot2)
library(dplyr)

# Create example time series data
fake_data = data.frame(time = 1:5, median = c(50, 51, 53, 52, 54))
fake_data = fake_data %>% mutate(lower1 = median * 0.8, upper1 = median * 1.2,
                                 lower2 = median * 0.9, upper2 = median * 1.1)

# Plot
p1 = ggplot(fake_data, aes(x = time)) +
  # Ribbon
  geom_ribbon(aes(ymin = lower1, ymax = upper1), fill = "gray90") +
  geom_ribbon(aes(ymin = lower2, ymax = upper2), fill = "gray70") +
  # Median line
  geom_line(aes(y = median), color = "#000000", size = 1.2) +
  # Add brackets 1:
  annotate("segment", x = 5.25, xend = 5.25, y = fake_data$lower1[5], yend = fake_data$upper1[5], 
           size = 1, color = "#ffffff") +
  annotate("segment", x = 5.15, xend = 5.28, y = fake_data$lower1[5], yend = fake_data$lower1[5], 
           size = 1, color = "#ffffff") +
  annotate("segment", x = 5.15, xend = 5.28, y = fake_data$upper1[5], yend = fake_data$upper1[5], 
           size = 1, color = "#ffffff") +
  # Add brackets 2:
  annotate("segment", x = 5.45, xend = 5.45, y = fake_data$lower2[5], yend = fake_data$upper2[5], 
           size = 1, color = "#ffffff") +
  annotate("segment", x = 5.35, xend = 5.48, y = fake_data$lower2[5], yend = fake_data$lower2[5], 
           size = 1, color = "#ffffff") +
  annotate("segment", x = 5.35, xend = 5.48, y = fake_data$upper2[5], yend = fake_data$upper2[5], 
           size = 1, color = "#ffffff") +
  # Add arrow for median:
  geom_segment(x = 5.6, xend = 5.05, y = fake_data$median[5], yend = fake_data$median[5], 
               arrow =  arrow(length = unit(0.15, "cm")), 
               color = "#ffffff") +
  # Annotations (simple explanations)
  annotate("text", x = 5.35, y = max(fake_data$upper1-2),
           label = "Where 90% of values fall",
           hjust = 0, size = 5, color = "#ffffff") +
  annotate("text", x = 5.55, y = max(fake_data$upper2-2),
           label = "Where 50% of values fall",
           hjust = 0, size = 5, color = "#ffffff") +
  annotate("text", x = 5.65, y = fake_data$median[n_sim],
           label = "Most typical value",
           hjust = 0, size = 5, color = "#ffffff") +
  # Give space for labels
  coord_cartesian(xlim = c(1, 11)) +
  # Clean look
  theme_void() +
  theme(plot.background = element_rect(fill = '#000000', colour = '#000000'))
ggsave(filename = file.path("www", 'ts.png'), plot = p1, 
       width = 110, height = 70, units = "mm", dpi = 300)


# Spider ------------------------------------------------------------------

# Create simple comparison data (values still arbitrary)
df <- data.frame(
  group = c("MP_1", "MP_2"),
  PI_1 = c(0.7, 0.4),
  PI_2 = c(0.5, 0.8),
  PI_3 = c(0.8, 0.6),
  PI_4 = c(0.6, 0.7)
)
lcols <- c("gray60", "white")

# Base radar plot
p1 <- ggradar(
  df,
  grid.min = 0, grid.mid = 1, grid.max = 1,
  grid.label.size = 0, 
  axis.label.size = 4,
  legend.position = "none",
  group.line.width = 1.2,
  group.point.size = 2,
  background.circle.transparency = 0,    # Adjust transparency
  group.colours = lcols
)

# Change color labels axes:
is_text <- sapply(p1$layers, function(x) inherits(x$geom, "GeomText") && any(x$data$text %in% names(df)))
p1$layers[is_text] <- lapply(p1$layers[is_text], function(x) { x$aes_params$colour <- "white"; x})

# Add MP labels
p1 = p1 +
  annotate("text", x = 0.72, y = 0.82,
           label = "MP_1",
           size = 4, hjust = 0.5, color = "white") +
  geom_curve(x = 0.45, y = 0.75, xend = 0.25, yend = 0.55,
    arrow = arrow(length = unit(0.025, "npc")),
    curvature = 0, color = "white"
  ) +
  annotate("text", x = 0.92, y = 0.52,
           label = "MP_2",
           size = 4, hjust = 0.5, color = "white") +
  geom_curve(x = 0.85, y = 0.42, xend = 0.75, yend = 0.15,
             arrow = arrow(length = unit(0.025, "npc")),
             curvature = 0, color = "white"
  ) 
# Add Value labels:
p1 = p1 +
  geom_segment(x = 0.32, y = -0.7, xend = 0.06, yend = -0.7,
               arrow = arrow(length = unit(0.02, "npc")), color = "white") +
  annotate("text", x = 0.35, y = -0.7, label = "Smaller value", 
           size = 3, hjust = 0, color = "white") +
  geom_segment(x = 0.32, y = -0.9, xend = 0.06, yend = -0.9,
               arrow = arrow(length = unit(0.02, "npc")), color = "white") +
  annotate("text", x = 0.35, y = -0.9, label = "Larger value", 
           size = 3, hjust = 0, color = "white")
# Add background color:
p1 = p1 + theme(panel.background = element_rect(fill = "#000000", colour = "#000000"),
           plot.background = element_rect(fill = '#000000', colour = '#000000'))
ggsave(filename = file.path("www", 'spider.png'), plot = p1, 
       width = 80, height = 70, units = "mm", dpi = 300)


# Kobe Time Series --------------------------------------------------------

fake_data = data.frame(Year = rep(paste0("Year_", 1:3), each = 4),
                       cat = rep(paste0("cat_", 1:4), times = 3),
                       value = c(0.6, 0.2, 0.1, 0.1,
                               0.5, 0.3, 0.15, 0.05,
                               0.55, 0.25, 0.1, 0.1))
col_pal = c("cat_1" = "gray90", "cat_2" = "gray75", "cat_3" = "gray60", "cat_4" = "gray45")

p1 = ggplot(fake_data, aes(x = Year, y = value, fill = factor(cat))) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = col_pal) +
  scale_y_continuous(labels = percent_format(scale = 100)) +
  scale_x_discrete(expand = expansion(mult = c(0, 2))) +
  # Add brackets 4:
  annotate("segment", x = 3.6, xend = 3.6, y = 0.455, yend = 1, 
           size = 0.75, color = "#ffffff") +
  annotate("segment", x = 3.5, xend = 3.6, y = 0.455, yend = 0.455,
           size = 0.75, color = "#ffffff") +
  annotate("segment", x = 3.5, xend = 3.6, y = 1, yend = 1,
           size = 0.75, color = "#ffffff") +
  # Annotations (simple explanations)
  annotate("text", x = 3.8, y = 0.76,
           label = "% of iterations in this Kobe",
           hjust = 0, size = 4, color = "#ffffff") +
  annotate("text", x = 3.8, y = 0.69,
           label = "category",
           hjust = 0, size = 4, color = "#ffffff") +
  theme_minimal() +
  theme(legend.position = "none",
        panel.background = element_rect(fill = "#000000", colour = "#000000"),
        plot.background = element_rect(fill = '#000000', colour = '#000000'),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
ggsave(filename = file.path("www", 'kobe_time.png'), plot = p1, 
       width = 120, height = 65, units = "mm", dpi = 300)
