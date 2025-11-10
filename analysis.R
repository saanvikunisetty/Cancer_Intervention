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