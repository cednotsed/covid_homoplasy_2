rm(list = ls())
setwd("~/git_repos/covid_homoplasy_2")
homo <- read.csv("homopolymers/homopolymers.tsv", sep = "\t", stringsAsFactors = F, check.names = F)

# Define homopolymer as > 4nt
homo <- homo[homo$homopolymer_len >= 4, ]

homo_vec <- c()

for (i in seq(nrow(homo))) {
  pos <- homo[i, 2:3]
  homo_vec <- c(homo_vec, seq(pos$start_pos - 1, pos$end_pos + 1))
}

length(homo_vec)

filt <- read.csv("filtered-homoplasic-sites-table_alt2_vs_alt1_0.2.csv", stringsAsFactors = F, check.names = F)
filt$homopolymer <- 0
filt$homopolymer[filt$bp %in% homo_vec] <- 1
write.csv(filt, "homopolymers/filtered-homoplasic-sites-table_040820.homopolymer.csv", row.names = F)

# Count number of homopolymers
nrow(filt) # No. of filtered homoplasies
sum(filt$homopolymer == 1) # No. of filtered homoplasies in homopolymer regions

# Binom test
binom.test(x = sum(filt$homopolymer == 1), 
           n = nrow(filt), 
           p = length(homo_vec) / 29903, 
           alternative = "less")
