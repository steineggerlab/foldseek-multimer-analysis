#!/bin/bash
QUERY="$( cd "$( dirname "$0" )" && pwd -P )"/../datasets/CRISPR/pHS1543_NZ_CP025815_Csf3_5Csf2_unrelaxed_rank_001_alphafold2_multimer_v3_model_5_seed_000.pdb
FOLDSEEK=$1
DB=$2
DIR=$3
mkdir $DIR
for i in 1 2 3 4 5; do
    /usr/bin/time $FOLDSEEK easy-complexsearch $QUERY $DB/pdb100_clusearchdb $DIR/fs_"$i" $DIR/tmp --threads 1  --cluster-search 1  -v 3 --db-load-mode 2 --monomer-include-mode 1 > $DIR/fs_"$i".log 2> $DIR/fs_"$i".runtime
    awk '$5>=0.5 {print $0}' $DIR/fs_"$i"_report > $DIR/fs_"$i".tsv
    /usr/bin/time $FOLDSEEK easy-complexsearch $QUERY $DB/pdb100_clusearchdb $DIR/ft_"$i" $DIR/tmp --threads 1  --cluster-search 1  -v 3 --db-load-mode 2 --monomer-include-mode 1 --alignment-type 1 > $DIR/ft_"$i".log 2> $DIR/ft_"$i".runtime
    awk '$5>=0.5 {print $0}' $DIR/ft_"$i"_report > $DIR/ft_"$i".tsv
done
