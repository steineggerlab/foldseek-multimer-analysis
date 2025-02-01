# foldseek-multimer-analysis
This repository contains the scripts needed for reproducing the results of [Rapid and Sensitive Protein Complex Alignment with Foldseek-Multimer](https://www.biorxiv.org/content/10.1101/2024.04.14.589414v1) by Kim et al. 2024.
### Obtaining Datasets
###### Download
The following script downloads files from [Zenodo](https://zenodo.org/records/11208705), organizes them and unites those of them that had to be split due to file size limitations:

    foldseek-multimer-analysis/datasets/download.sh
    mkdir foldseek-multimer-analysis/datasets/CRISPR/PDBs
Download CIF(.gz) files from wwpdb.org and put them in foldseek-multimer-analysis/datasets/CRISPR/PDBs
###### Remove
    foldseek-multimer-analysis/datasets/remove.sh
### Similar Pairs Benchmark
    foldseek-multimer-analysis/similar_pairs_benchmark/run_FS-MM_similar_pairs_benchmark.sh [Foldseek PATH] [TEMP DIR]
    foldseek-multimer-analysis/similar_pairs_benchmark/run_US-align_similar_pairs_benchmark.sh [US-align PATH] [TEMP DIR]
    foldseek-multimer-analysis/similar_pairs_benchmark/tot.py [TEMP DIR] [RESULT TSV]
### CRISPR Benchmark 
###### Createdb 
    foldseek-multimer-analysis/CRISPR_benchmark/run_CRISPR_createdb.sh [FOLDSEEK PATH] [THREADS] [DIR for DATABASE FILES]
###### Foldseek
    foldseek-multimer-analysis/CRISPR_benchmark/run_CRISPR_benchmark.sh [FOLDSEEK PATH] [DIR for DATABASE FILES] [TEMP DIR]
###### US-align: runtime with 1,000 targets
    foldseek-multimer-analysis/CRISPR_benchmark/run_US-align_CRISPR_runtime.sh [US-align PATH] [TEMP DIR] [OUTPUT FILE]
###### US-align: all positive results
    foldseek-multimer-analysis/CRISPR_benchmark/run_US-align_CRISPR_whole.sh [US-align PATH] [TEMP DIR] [OUTPUT PATH] [THREADS]
### 3DComplexV7 Benchmark
###### Createdb
    foldseek-multimer-analysis/3DComplexV7_benchmark/run_3DComplexV7_createdb.sh [FOLDSEEK PATH] [THREADS] [DIR for DATABASE FILES]
###### Database Search
    foldseek-multimer-analysis/3DComplexV7_benchmark/run_database_search.sh [US-align PATH] [FOLDSEEK PATH] [DIR for DATABASE FILES] [TSV OUTPUT PATH] [TEMP DIR]
###### Foldseek-MM Benchmark
    foldseek-multimer-analysis/3DComplexV7_benchmark/run_FS-MM_3DComplexV7_benchmark.sh [FOLDSEEK PATH] [DIR for DATABASE FILES] [CSV OUTPUT] [THREADS] [TEMP DIR]
    foldseek-multimer-analysis/3DComplexV7_benchmark/tot.py foldseek-multimer-analysis/datasets/3DComplexV7/QSalign_pairs.csv [CSV INPUT] [TSV OUTPUT PATH]

