#!/bin/bash
DATA="$( cd "$( dirname "$0" )" && pwd -P )"/../datasets/similar_pairs_benchmark/
FOLDSEEK=$1
DIR=$2
mkdir $DIR
for i in 1 2 3 4 5; do
  while read line || [ -n "$line" ] ; do
    array=($(echo $line | tr " " "\n"))
    q=${array[0]}
    t=${array[1]}
    n=${array[2]}
    
    RES=fs_"$q"_"$t"_"$i"
    /usr/bin/time $FOLDSEEK easy-complexsearch $DATA/PDBs/"$q".pdb $DATA/PDBs/"$t".pdb $DIR/"$RES"_res $DIR/tmp --threads 1 --exhaustive-search 1 --monomer-include-mode 1 -v 3 > $DIR/"$RES".log 2> $DIR/"$RES".time
    awk 'FNR==NR {f=$1"\t"$2"\t"$5"\t"$6; nextfile;} /CPU/ {split($3, b, "e"); split(b[1], a, ":"); t=a[1]*60+a[2]; print f"\t"t}' $DIR/"$RES"_res_report $DIR/"$RES".time >> $DIR/fs_$i.tsv
    
    RES=ft_"$q"_"$t"_"$i"
    /usr/bin/time $FOLDSEEK easy-complexsearch $DATA/PDBs/"$q".pdb $DATA/PDBs/"$t".pdb $DIR/"$RES"_res $DIR/tmp --threads 1 --exhaustive-search 1 --monomer-include-mode 1 --alignment-type 1 -v 3 >$DIR/"$RES".log 2> $DIR/"$RES".time
    awk 'FNR==NR {f=$1"\t"$2"\t"$5"\t"$6; nextfile;} /CPU/ {split($3, b, "e"); split(b[1], a, ":"); t=a[1]*60+a[2]; print f"\t"t}' $DIR/"$RES"_res_report $DIR/"$RES".time >> $DIR/ft_$i.tsv
  done < $DATA/pairs.tsv
done
