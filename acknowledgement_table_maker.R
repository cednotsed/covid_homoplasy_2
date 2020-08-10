setwd("~/git_repos/covid_homoplasy_2/")
meta <- read.csv("Metadata_S1.tsv", sep = ";")
colnames(meta)
meta <- meta[, c("gisaid_epi_isl", "originating_lab", "submitting_lab", "authors")]
write.table(meta, "Metadata_S1.parsed.tsv", sep = "\t", row.names = F, col.names = T)
