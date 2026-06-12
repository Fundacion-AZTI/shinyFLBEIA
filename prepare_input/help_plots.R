# Load libraries
library(ggplot2)
library(ggradar)

# Violin ------------------------------------------------------------------

# Create simple example data
set.seed(1)
fake_data <- data.frame(
  group = "Example",
  values = c(rnorm(200, mean = 70, sd = 10))
)

# Create violin plot
p1 = ggplot(fake_data, aes(x = group, y = values)) +
  geom_violin(fill = "#ffffff", color = "#ffffff") +
  # Add simple explanatory text
  annotate("text", x = 1.1, y = 95, label = "Rare results", size = 5, hjust = 0, color = '#ffffff') +
  annotate("text", x = 1.1, y = 45, label = "Rare results", size = 5, hjust = 0, color = '#ffffff') +
  annotate("text", x = 1, y = 70, label = "Most frequent results", size = 5) +
  # Clean theme for non-technical audience
  theme_void() +
  theme(plot.background = element_rect(fill = '#000000', colour = '#000000'))
ggsave(filename = file.path("www", 'violin.png'), plot = p1, 
       width = 80, height = 70, units = "mm", dpi = 300)


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
