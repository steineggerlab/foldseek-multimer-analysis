# foldseek-multimer-analysis
This repository contains the scripts needed for reproducing the results of [Rapid and Sensitive Protein Complex Alignment with Foldseek-Multimer](https://www.biorxiv.org/content/10.1101/2024.04.14.589414v1) by Kim et al. 2024.
### Obtaining Datasets
###### Download
The following script downloads files from [Zenodo](https://zenodo.org/records/11208705), organizes them and unites those of them that had to be split due to file size limitations:

    foldseek-multimer-analysis/datasets/download.sh
###### Remove
    foldseek-multimer-analysis/datasets/remove.sh
### Similar Pairs Benchmark 
    foldseek-multimer-analysis/pairwise_benchmark/run_similar_pairs_benchmark.sh [US-align PATH] [FOLDSEEK PATH]
###### Foldseek-MM
    foldseek-multimer-analysis/pairwise_benchmark/run_foldseek-MM_pairwise.sh [FOLDSEEK PATH] [OUTPUT PATH]
###### Foldseek-MM-TM
    foldseek-multimer-analysis/pairwise_benchmark/run_foldseek-MM-TM_pairwise.sh [FOLDSEEK PATH] [OUTPUT PATH]
###### US-align
    foldseek-multimer-analysis/pairwise_benchmark/run_US-align_pairwise.sh [US-align PATH] [OUTPUT PATH]
###### US-align-fast
    foldseek-multimer-analysis/pairwise_benchmark/run_US-align-fast_pairwise.sh [US-align PATH] [OUTPUT PATH]
### CRISPR Benchmark 
###### Foldseek-MM
    foldseek-multimer-analysis/CRISPR_benchmark/run_foldseek-MM_CRISPR.sh [FOLDSEEK PATH] [OUTPUT PATH]
###### Foldseek-MM-TM
    foldseek-multimer-analysis/CRISPR_benchmark/run_foldseek-MM-TM_CRISPR.sh [FOLDSEEK PATH] [OUTPUT PATH]
###### US-align: runtime with 1,000 targets
    foldseek-multimer-analysis/CRISPR_benchmark/run_US-align_CRISPR_runtime.sh [US-align PATH] [OUTPUT PATH]
###### US-align: all positive results
    foldseek-multimer-analysis/CRISPR_benchmark/run_US-align_CRISPR_whole.sh [US-align PATH] [OUTPUT PATH]
### 3DComplexV7 Benchmark    
###### Foldseek-MM
    foldseek-multimer-analysis/3DComplexV7_benchmark/run_3DComplexV7_benchmark.sh [FOLDSEEK PATH] [OUTPUT PATH]
