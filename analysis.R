library(tidyverse)
data <- tribble(
  ~Group, ~Plate, ~Genotype, ~Sun_Exposure, ~Population_Count,
  1, 1, "WT", "No Sun", 10,
  1, 2, "WT", "No Sun", 17,
  1, 3, "WT", "No Sun", 7,
  1, 4, "WT", "No Sun", 3,
  2, 1, "Mutant", "No Sun", 17,
  2, 2, "Mutant", "No Sun", 32,
  2, 3, "Mutant", "No Sun", 2,
  2, 4, "Mutant", "No Sun", 19,
  3, 1, "WT", "Sun", 3,
  3, 2, "WT", "Sun", 3,
  3, 3, "WT", "Sun", 0,
  3, 4, "WT", "Sun", 5,
  4, 1, "Mutant", "Sun", 4,
  4, 2, "Mutant", "Sun", 1,
  4, 3, "Mutant", "Sun", 0,
  4, 4, "Mutant", "Sun", 1
)

print(data)
summary(data)

stats_summary <- data %>%
  group_by(Genotype, Sun_Exposure) %>%
  summarise(
    Mean_Pop = mean(Population_Count),
    SD_Pop = sd(Population_Count),
    SE_Pop = sd(Population_Count) / sqrt(n()),
    n = n()
  )

print(stats_summary)

install.packages(c("gt", "webshot2", "dplyr"))
library(gt)
library(dplyr)
library(webshot2)
table_gt <- stats_summary %>%
  gt() %>%
  tab_header(
    title = md("**Summary Statistics of Experimental Data**"),
    subtitle = "Generated from Cancer_Intervention Dataset"
  ) %>%
  fmt_number(
    columns = where(is.numeric),
    decimals = 2
  ) %>%
  tab_options(
    table.font.names = "Times New Roman",
    table.font.size = 12,
    heading.align = "center",
    data_row.padding = px(6),
    table.border.top.color = "black",
    table.border.bottom.color = "black"
  ) %>%
  tab_style(
    style = list(
      cell_fill(color = "#f8f9fa"),
      cell_borders(sides = "bottom", color = "gray80", weight = px(1))
    ),
    locations = cells_body()
  )
print(table_gt)

mean_pop_plot <- ggplot(stats_summary, aes(x = Sun_Exposure, y = Mean_Pop, fill = Genotype)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.9)) +
  geom_errorbar(aes(ymin = Mean_Pop - SE_Pop, ymax = Mean_Pop + SE_Pop),
                position = position_dodge(width = 0.9), width = 0.3) +
  labs(
    title = "Mean Population Count by Genotype and Sun Exposure",
    x = "Sun Exposure",
    y = "Mean Population Count",
    fill = "Genotype"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 28, face = "bold"),       
    axis.title.x = element_text(size = 22, face = "bold"),     
    axis.title.y = element_text(size = 22, face = "bold"),   
    axis.text.x = element_text(size = 18),                
    axis.text.y = element_text(size = 18),           
    legend.title = element_text(size = 20, face = "bold"),    
    legend.text = element_text(size = 18)                      
  )

anova_model <- aov(Population_Count ~ Genotype * Sun_Exposure, data = data)
summary(anova_model)
install.packages(c("broom", "gt"))

library(broom)
library(gt)

# Convert ANOVA model to tidy data frame
anova_tidy <- broom::tidy(anova_model)

# Make it a nice gt table
anova_table <- anova_tidy %>%
  gt() %>%
  tab_header(
    title = md("**Two-Way ANOVA Results**"),
    subtitle = "Genotype × Sun Exposure effects on Population Count"
  ) %>%
  fmt_number(
    columns = c("sumsq", "meansq", "statistic", "p.value"),
    decimals = 3
  ) %>%
  tab_options(
    table.font.names = "Times New Roman",
    table.font.size = 12,
    heading.align = "center"
  ) %>%
  cols_label(
    term = "Factor",
    df = "DF",
    sumsq = "Sum of Squares",
    meansq = "Mean Square",
    statistic = "F-value",
    p.value = "p-value"
  ) %>%
  tab_style(
    style = cell_text(weight = "bold"),
    locations = cells_column_labels(everything())
  )
anova_table
