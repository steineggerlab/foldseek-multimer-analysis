# foldseek-multimer-analysis
This repository contains the scripts needed for reproducing the results of [Rapid and Sensitive Protein Complex Alignment with Foldseek-Multimer](https://www.biorxiv.org/content/10.1101/2024.04.14.589414v1) by Kim et al. 2024.
### Obtaining Datasets
###### Download
The following script downloads files from [Zenodo](https://zenodo.org/records/11208705), organizes them and unites those of them that had to be split due to file size limitations:

    foldseek-multimer-analysis/datasets/download.sh
    mkdir foldseek-multimer-analysis/datasets/CRISPR/PDBs
Download PDB files from wwpdb.org and put them in foldseek-multimer-analysis/datasets/CRISPR/PDBs
###### Remove
    foldseek-multimer-analysis/datasets/remove.sh
### Similar Pairs Benchmark 
    foldseek-multimer-analysis/pairwise_benchmark/run_similar_pairs_benchmark.sh [US-align PATH] [FOLDSEEK PATH] [TSV OUTPUT PATH]
    foldseek-multimer-analysis/pairwise_benchmark/fig.py [TSV OUTPUT PATH] [FIGURE(PNG) OUTPUT PATH]
###### Foldseek-MM
    foldseek-multimer-analysis/pairwise_benchmark/run_foldseek-MM_similar_pairs.sh [FOLDSEEK PATH] [OUTPUT PATH]
###### Foldseek-MM-TM
    foldseek-multimer-analysis/pairwise_benchmark/run_foldseek-MM-TM_similar_pairs.sh [FOLDSEEK PATH] [OUTPUT PATH]
###### US-align
    foldseek-multimer-analysis/pairwise_benchmark/run_US-align_similar_pairs.sh [US-align PATH] [OUTPUT PATH]
###### US-align-fast
    foldseek-multimer-analysis/pairwise_benchmark/run_US-align-fast_similar_pairs.sh [US-align PATH] [OUTPUT PATH]
### CRISPR Benchmark 
###### Createdb 
    foldseek-multimer-analysis/CRISPR_benchmark/run_CRISPR_createdb.sh [FOLDSEEK PATH] [threads]
###### Foldseek-MM
    foldseek-multimer-analysis/CRISPR_benchmark/run_foldseek-MM_CRISPR.sh [FOLDSEEK PATH] [OUTPUT PATH]
###### Foldseek-MM-TM
    foldseek-multimer-analysis/CRISPR_benchmark/run_foldseek-MM-TM_CRISPR.sh [FOLDSEEK PATH] [OUTPUT PATH]
###### US-align: runtime with 1,000 targets
    foldseek-multimer-analysis/CRISPR_benchmark/run_US-align_CRISPR_runtime.sh [US-align PATH] [OUTPUT PATH]
###### US-align: all positive results
    foldseek-multimer-analysis/CRISPR_benchmark/run_US-align_CRISPR_whole.sh [US-align PATH] [OUTPUT PATH] [threads]
### 3DComplexV7 Benchmark
###### Createdb
    foldseek-multimer-analysis/3DComplexV7_benchmark/run_3DComplexV7_createdb.sh [FOLDSEEK PATH] [threads]
###### Runtime
    foldseek-multimer-analysis/3DComplexV7_benchmark/run_3DComplexV7_runtime.sh [US-align PATH] [FOLDSEEK PATH] [OUTPUT PATH]
###### Foldseek-MM
    foldseek-multimer-analysis/3DComplexV7_benchmark/run_3DComplexV7_benchmark.sh [FOLDSEEK PATH] [CSV OUTPUT PATH] [threads]
###### Figures [With your Data]
    foldseek-multimer-analysis/pairwise_benchmark/fig.py foldseek-multimer-analysis/datasets/3DComplexV7/QSalign_pairs.csv [CSV PATH] [FIGURE(PNG) OUTPUT PATH]
###### Figures [With Ready-made Data]  
    foldseek-multimer-analysis/pairwise_benchmark/fig.py foldseek-multimer-analysis/datasets/3DComplexV7/QSalign_pairs.csv foldseek-multimer-analysis/datasets/3DComplexV7/FS-MM.csv [FIGURE(PNG) OUTPUT PATH]
