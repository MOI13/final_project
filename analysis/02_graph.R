here::i_am(
  "analysis/02_graph.R"
)

library(tidyverse)
library(patchwork)
library(ggplot2)
library(ggpubr)


survey <- readRDS(here::here("data/intermediate/survey.rds"))

# PHQ-9 Density Plot
p1 <- ggplot(survey, aes(x = `PHQ Total`)) +
  geom_density(fill = "skyblue", alpha = 0.6) +
  geom_vline(xintercept = 20, linetype = "dashed", color = "red") +
  labs(title = "PHQ-9 Total Scores Cut Point", x = "PHQ-9 Total Score", y = "Density") +
  theme_bw()

# GAD-7 Density Plot
p2 <- ggplot(survey, aes(x = `GAD Total`)) +
  geom_density(fill = "lightgreen", alpha = 0.6) +
  geom_vline(xintercept = 15, linetype = "dashed", color = "red") +
  labs(title = "GAD-7 Total Scores Cut Point", x = "GAD-7 Total Score", y = "Density") +
  theme_bw()

p <- p1/p2

saveRDS(p, here::here("output/graph.rds"))

