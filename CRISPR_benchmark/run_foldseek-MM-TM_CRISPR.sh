#!/bin/bash

mkdir tmp
/usr/bin/time $1 easy-complexsearch ../datasets/CRISPR/pHS1543_NZ_CP025815_Csf3_5Csf2_unrelaxed_rank_001_alphafold2_multimer_v3_model_5_seed_000.pdb ../datasets/CRISPR/pdb100 tmp/result tmp --threads 1  --alignment-type 1  --cluster-search 1 # -v 0 
awk '$5>=0.5 {print $0}' tmp/result_report > $2
rm -rf tmp
