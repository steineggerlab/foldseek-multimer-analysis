#!/bin/bash
DATA="$( cd "$( dirname "$0" )" && pwd -P )"../datasets/CRISPR/
USALIGN=$1
DIR=$2
OUT=$3
QUERY=$DATA/pHS1543_NZ_CP025815_Csf3_5Csf2_unrelaxed_rank_001_alphafold2_multimer_v3_model_5_seed_000.pdb
mkdir $DIR

while read line || [ -n "$t" ] ; do
    /usr/bin/time $USALIGN $QUERY  $DATA/PDBs/$t.pdb  -mm 1 -ter 0 -mol prot -outfmt 2 >> $DIR/"$t"_result.txt  2>> $DIR/runtimes.txt
done < $DATA/runtime_targets.list

awk '/CPU/ {split($3, a, "e"); split(a[1], b, ":"); s+=b[1]*60+b[2] } END {print s}' $DIR/runtimes.txt  > $OUT
