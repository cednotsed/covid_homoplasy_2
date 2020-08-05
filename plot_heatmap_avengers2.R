setwd("~/git_repos/covid_homoplasy_2")
load("1000_reps_heatmap_data_no_inf_2.2.RData")

cm <- data.frame(out_matrix)
rownames(cm) <- rownames(out_matrix)
colnames(cm) <- colnames(out_matrix)

require(reshape2)
cm$inc <- rownames(cm)
melted <- melt(cm)
melted$value <- melted$value * 100
melted$inc <- as.character(as.numeric(melted$inc) * 100)

require(ggplot2)
ggplot(melted, aes(y = inc, x = variable, fill = value)) +
  geom_tile() +
  geom_text(aes(label = round(value, 1)), size = 3) +
  labs(x = "No. of Independent Emergences",
       y = "Offspring Imbalance (%)",
       fill = "Power") +
  scale_fill_gradient(low="yellow", high="red") +
  theme_bw()

ggsave("power_analysis_heatmap.png", dpi=300, width = 5, height = 4)
