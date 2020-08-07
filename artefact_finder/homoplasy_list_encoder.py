import numpy as np
import pandas as pd
from Bio import SeqIO
from pathlib import Path
from sklearn.preprocessing import OneHotEncoder
cwd = Path.cwd()

df = pd.read_csv(cwd / '../SNP_homoplasy_counts_table.deMaio_mask.20.06.2020.csv', sep='\t')
ref = pd.Series(np.array(SeqIO.read(cwd / '../wuhan-hu-1.fasta', 'fasta').seq))
df['ref'] = ref

# Drop invariant sites
df = df.loc[df['CountsACGT'] != '0', :]

# Split SNP count column
snps = df['CountsACGT'].str.split(':', expand=True)
snps.columns = ['snp_A', 'snp_C', 'snp_G', 'snp_T']

# One Hot encoding
dummies = pd.get_dummies(df[['ref']])

# Retrieve desired columns
df = df[['consistency_index', 'bp', 'Min.No.ChangesonTree', 'SNP_count']]
df = pd.concat([df, dummies, snps], axis=1)

df.to_csv(cwd / 'encoded_homoplasies_040820.tsv', sep='\t', header=True, index=False)
