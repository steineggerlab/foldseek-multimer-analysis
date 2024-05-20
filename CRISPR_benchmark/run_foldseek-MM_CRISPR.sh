#!/bin/bash

rm -rf tmp
mkdir tmp
$1 createdb ../datasets/CRISPR/PDBs tmp/pdb100 --threads ?
$1 createindex tmp/pdb100 tmp/tmp --threads ? 
$1 cluster tmp/pdb100 tmp/pdb100_clu tmp/tmp --min-seq-id 0.9 -c 0.99 -e 0.00001 --threads ?
$1 createclusearchdb tmp/pdb100 tmp/pdb100_clu tmp/pdb100_clusearchdb --threads ?
/usr/bin/time $1 easy-complexsearch ../datasets/CRISPR/pHS1543_NZ_CP025815_Csf3_5Csf2_unrelaxed_rank_001_alphafold2_multimer_v3_model_5_seed_000.pdb ./tmp/pdb100 ./tmp/result ./tmp/tmp --threads 1  --cluster-search 1  -v 0 
awk '$5>=0.5 {print $0}' tmp/result_report > $2
rm -rf tmp
