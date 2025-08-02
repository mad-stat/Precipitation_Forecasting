library(ggplot2)
library(scales)
library(dplyr)
library(readr)
############ FACET plot 

library(tidyverse)

# Load the dataset
df <- read.csv("weekly_summary_1991-2021.csv")
colnames(df) = c("Date", "Precipitation", "Mean air temperature",
                 "Mean relative humidity", "Mean cloud cover",
                 "Average air pressure")

# Convert Date to proper date format
df$Date <- as.Date(df$Date, format = "%d/%m/%Y")

# Reshape to long format
df_long <- df %>%
  pivot_longer(cols = -Date, names_to = "Variable", values_to = "Value")

# Set custom facet order using factor
df_long$Variable <- factor(df_long$Variable, levels = c(
  "Precipitation",
  "Mean air temperature",
  "Mean relative humidity",
  "Mean cloud cover",
  "Average air pressure"
))

ggplot(df_long, aes(x = Date, y = Value, color = Variable)) +
  geom_line(size = 0.5) +
  facet_wrap(~Variable, scales = "free_y", ncol = 1) +
  labs(title = "",
       x = "Date", y = "Value") +
  theme_classic(base_size = 12) +
  theme(
    strip.text = element_text(face = "bold"),
    legend.position = "none",
    panel.spacing = unit(0.5, "lines"),
    axis.title = element_text(face = "bold"),
    axis.text = element_text(face = "bold")
  )

# Save with adjusted width and height
ggsave("facet_plot_tall.png", width = 6, height = 6, dpi = 900)
