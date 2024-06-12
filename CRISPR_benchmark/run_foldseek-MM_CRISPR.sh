#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd -P )"
rm -rf $DIR/tmp
mkdir $DIR/tmp
/usr/bin/time $1 easy-complexsearch $DIR/../datasets/CRISPR/pHS1543_NZ_CP025815_Csf3_5Csf2_unrelaxed_rank_001_alphafold2_multimer_v3_model_5_seed_000.pdb $DIR/db/pdb100_clusearchdb $DIR/tmp/result $DIR/tmp/tmp --threads 1  --cluster-search 1  -v 0 --db-load-mode 2 
awk '$5>=0.5 {print $0}' $DIR/tmp/result_report > $2
rm -rf $DIR/tmp
