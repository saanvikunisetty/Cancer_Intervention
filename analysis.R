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