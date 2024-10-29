#!/bin/bash

DATA="$( cd "$( dirname "$0" )" && pwd -P )"/../datasets
USALIGN=$1
FOLDSEEK=$2
DB=$3
RES=$4
DIR=$5
mkdir $DIR
for q in $(ls $DATA/similar_pairs_benchmark/PDBs | head); do
    Q=$(basename $q .pdb)
    query=$DATA/similar_pairs_benchmark/PDBs/$q
    for t in $(head $DATA/3DComplexV7/3DComplexV7_runtime_target.list); do
        T=$(basename $t .pdb)
        target=$DATA/3DComplexV7/PDBs/$t
        /usr/bin/time $USALIGN $query $target  -mm 1 -ter 0 -mol prot -outfmt 2 > $DIR/us_"$Q"_"$T".tsv 2>> $DIR/us_"$Q".time
        /usr/bin/time $USALIGN $query $target  -mm 1 -ter 0 -mol prot -outfmt 2 > $DIR/uf_"$Q"_"$T".tsv -fast 2>> $DIR/uf_"$Q".time
    done
    /usr/bin/time $FOLDSEEK easy-complexsearch $query $DB/3DComplexV7_clusearchdb $DIR/fs_"$Q"_res $DIR/tmp --threads 1 --monomer-include-mode 1 --cluster-search 1 --db-load-mode 2  -v 3 > $DIR/fs_"$Q"_search.log 2> $DIR/fs_"$Q".time
    /usr/bin/time $FOLDSEEK easy-complexsearch $query $DB/3DComplexV7_clusearchdb $DIR/fs_"$Q"_res $DIR/tmp --threads 1 --monomer-include-mode 1 --cluster-search 1 --db-load-mode 2  -v 3 --alignment-type 1 > $DIR/ft_"$Q"_search.log 2> $DIR/ft_"$Q".time
    awk '/CPU/ {split($3, a, "e"); split(a[1], b, ":"); s+=b[1]*60+b[2]} END {print s}' $DIR/us_"$Q".time >> $DIR/"$Q".time
    awk '/CPU/ {split($3, a, "e"); split(a[1], b, ":"); s+=b[1]*60+b[2]} END {print s}' $DIR/uf_"$Q".time >> $DIR/"$Q".time
    awk '/CPU/ {split($3, a, "e"); split(a[1], b, ":"); s+=b[1]*60+b[2]; print s}' $DIR/fs_"$Q".time >> $DIR/"$Q".time
    awk '/CPU/ {split($3, a, "e"); split(a[1], b, ":"); s+=b[1]*60+b[2]; print s}' $DIR/ft_"$Q".time >> $DIR/"$Q".time
    awk -v q=$Q 'FNR==1 {a=$0} FNR==2 {b=$0} FNR==3 {c=$0} FNR==4 {d=$0} END {print q"\t"a"\t"b"\t"c"\t"d}' $DIR/"$Q".time >> $DIR/runtime_sum.tsv
done
awk 'BEGIN {print "q\tch\tUS-align\tUS-align-fast\tFS-MM\tFS-MM-TM"} FNR==NR {f[$1]=$3; f[$2]=$3; next} {c=f[$1]; print $1"\t"c"\t"$2"\t"$3"\t"$4"\t"$5}' $DATA/similar_pairs_benchmark/pairs.tsv $DIR/runtime_sum.tsv > $RES

