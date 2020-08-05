rm(list = ls())
setwd("~/git_repos/covid_homoplasy_2")
df <- read.csv("artefact_finder/encoded_homoplasies_040820.tsv", 
               sep = "\t", 
               stringsAsFactors = F,
               check.names = F)

meta <- read.csv("filtered-homoplasic-sites-table_alt2_vs_alt1_0.2.csv")
meta <- meta$bp

pos <- df$bp

# 208 duplicates!
# dups <- df[duplicated(df[, 2:ncol(df)]), ]
df <- df[, -(which(colnames(df) == "bp"))]

# Remove unwanted columns
colnames(df)[1:3] <- c("Consistency Index", "Min.No.ChangesOnTree", "SNP Count")

# Run PCA
pca <- prcomp(df, center = T, scale. = T, retx = T)
pc <- pca$x
prop_var <- pca$sdev ^ 2 / sum (pca$sdev ^ 2) * 100
plot_df <- data.frame(position = pos, PC1 = pc[, 1], PC2 = pc[, 2])

plot_df$homoplasy <- "No"
plot_df$homoplasy[plot_df$position %in% meta] <- "Yes"

require(ggplot2)
require(ggsci)
plt3 <- ggplot(plot_df, aes(x = PC1, y = PC2, color = position)) +
  geom_point() +
  labs(x = paste0("PC1", " (", round(prop_var[1], 1), "%)"),
       y = paste0("PC2", " (", round(prop_var[2], 1), "%)"),
       color = "Position") +
  theme(legend.position = "top", 
        axis.title = element_blank())
  # geom_point(aes(x = PC1[which(pos == 24390)], y = PC2[which(pos == 24390)]), color = "red") +
  # geom_text(aes(x = PC1[which(pos == 24390)] - 0.3,
  #               y = PC2[which(pos == 24390)] - 0.3,
  #               label = "24390"),
  #           color = "red",
  #           size = 3)
# ggsave("artefact_finder/pca_pos_120520.png", dpi = 600, width = 5, height = 4)

# Plot by homoplasy
plt4 <- ggplot(plot_df, aes(x = PC1, y = PC2, color = homoplasy)) +
  geom_point() +
  scale_color_manual(values = c("#CC0033", "#66CC00")) + 
  labs(x = paste0("PC1", " (", round(prop_var[1], 1), "%)"),
       y = paste0("PC2", " (", round(prop_var[2], 1), "%)"),
       color = "Pass Filters?") +
  theme(legend.position = "top", 
        axis.title = element_blank())
  # geom_point(aes(x = PC1[which(pos == 24390)], y = PC2[which(pos == 24390)]), color = "black") +
  # geom_text(aes(x = PC1[which(pos == 24390)] - 0.3,
  #               y = PC2[which(pos == 24390)] - 0.3,
  #               label = "24390"),
  #           color = "black",
  #           size = 3) +
  # theme(legend.title = element_text(size = 7),
  #       legend.text = element_text(size = 6))

# ggsave("artefact_finder/pca_homoplasy_120520.png", width = 5, height = 4)

# Plot loadings
loading_df1 <- data.frame(PC1 = pca$rotation[, 1], 
                         variable = colnames(df), 
                         stringsAsFactors = F, 
                         check.names = F)

loading_df2 <- data.frame(PC2 = pca$rotation[, 2], 
                          variable = colnames(df), 
                          stringsAsFactors = F, 
                          check.names = F)

loading_df1 <- loading_df1[order(loading_df1$PC1, decreasing = T),]
loading_df2 <- loading_df2[order(loading_df2$PC2, decreasing = T),]

loading_df1$variable <- factor(loading_df1$variable, levels=loading_df1$variable)
loading_df2$variable <- factor(loading_df2$variable, levels=loading_df2$variable)

w <- 0.5

plt1 <- ggplot(loading_df1, aes(x = variable, y = PC1, fill = PC1)) +
  geom_bar(stat = "identity", width = w) + 
  theme(axis.text.x = element_text(angle = 30, hjust = 1),
        plot.margin = unit(c(0,0,0,1), "cm"),
        axis.title.x = element_blank(),
        legend.position = "None") +
  scale_fill_gradient(low = "lightseagreen", high = "tomato1")

plt2 <- ggplot(loading_df2, aes(x = variable, y = PC2, fill = PC2)) +
  geom_bar(stat = "identity", width = w) + 
  theme(axis.text.x = element_text(angle = 30, hjust = 1),
        plot.margin = unit(c(0,0,0,1), "cm"),
        axis.title.x = element_blank(),
        legend.position = "None") +
  scale_fill_gradient(low = "lightseagreen", high = "tomato1")

require(ggpubr)  
ggarrange(plt1, plt2, ncol=1, nrow=2, align = "hv")
ggsave("artefact_finder/pca_loadings_040820.png", dpi = 600, width = 6, height = 4)

figure <- ggarrange(plt3, plt4, ncol=2, nrow=1, align = "hv")
annotate_figure(figure, left = text_grob(paste0("PC2", " (", round(prop_var[2], 1), "%)"), rot = 90),
                bottom = text_grob(paste0("PC1", " (", round(prop_var[1], 1), "%)")))

ggsave("artefact_finder/pca_plots_040820.png", dpi = 600, width = 6, height = 4)
