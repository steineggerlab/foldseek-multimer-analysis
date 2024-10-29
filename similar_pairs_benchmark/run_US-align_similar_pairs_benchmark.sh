#!/bin/bash

DATA="$( cd "$( dirname "$0" )" && pwd -P )"/../datasets/similar_pairs_benchmark/
USALIGN=$1
DIR=$2
mkdir $DIR
for i in 1 2 3 4 5; do
  while read line || [ -n "$line" ] ; do
    array=($(echo $line | tr " " "\n"))
    q=${array[0]}
    t=${array[1]}
    n=${array[2]}
    
    RES=us_"$q"_"$t"_"$i"
    /usr/bin/time $USALIGN $DATA/PDBs/"$q".pdb $DATA/PDBs/"$t".pdb -mm 1 -ter 0 -mol prot -outfmt 2  > $DIR/"$RES".tsv 2> $DIR/"$RES".time
    awk 'FNR==NR && FNR==2 {split($1,a,"/"); split($2, b, "/"); split(a[length(a)], c, ":"); split(b[length(b)], d, ":"); f=c[1]"\t"d[1]"\t"$3"\t"$4; nextfile;} /CPU/ {split($3, b, "e"); split(b[1], a, ":"); t=a[1]*60+a[2]; print f"\t"t}' $DIR/"$RES".tsv  $DIR/"$RES".time >> $DIR/us_$i.tsv
    
    RES=uf_"$q"_"$t"_"$i"
    /usr/bin/time $USALIGN $DATA/PDBs/"$q".pdb $DATA/PDBs/"$t".pdb -mm 1 -ter 0 -mol prot -outfmt 2 -fast > $DIR/"$RES".tsv  2> $DIR/"$RES".time
    awk 'FNR==NR && FNR==2 {split($1,a,"/"); split($2, b, "/"); split(a[length(a)], c, ":"); split(b[length(b)], d, ":"); f=c[1]"\t"d[1]"\t"$3"\t"$4; nextfile;} /CPU/ {split($3, b, "e"); split(b[1], a, ":"); t=a[1]*60+a[2]; print f"\t"t}' $DIR/"$RES".tsv $DIR/"$RES".time >> $DIR/uf_$i.tsv
    done < $DATA/pairs.tsv
done
