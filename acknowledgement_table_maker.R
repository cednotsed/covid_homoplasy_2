setwd("~/git_repos/covid_homoplasy_2/")
meta <- read.csv("23090_accessions.csv", header = F)
df1 <- read.csv("gisaid_hcov-19_acknowledgement_table_2020_06_16_09.csv", header = F)
df2 <- read.csv("gisaid_hcov-19_acknowledgement_table_2020_06_16_09 (1).csv", header = F)
df3 <- read.csv("gisaid_hcov-19_acknowledgement_table_2020_06_16_09 (2).csv", header = F)
df4 <- read.csv("gisaid_hcov-19_acknowledgement_table_2020_06_16_09 (3).csv", header = F)

dim(df1) + dim(df2) + dim(df3) + dim(df4)

df <- rbind(df1, df2, df3, df4)
df <- unique(df)

require(dplyr)
final <- left_join(meta, df, by = "V1")

write.table(final, "Table_S1.csv", row.names = F, col.names = F)