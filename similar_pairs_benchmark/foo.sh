#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd -P )"
while read line || [ -n "$line" ] ; do
  array=($(echo $line | tr " " "\n"))
  q=${array[0]}
  t=${array[1]}
  n=${array[2]}
  mkdir $DIR/tmp2
  /usr/bin/time $1 easy-complexsearch $DIR/../datasets/similar_pairs_benchmark/PDBs/"$q".pdb $DIR/../datasets/similar_pairs_benchmark/PDBs/"$t".pdb $DIR/tmp2/result $DIR/tmp2 --threads 1 --exhaustive-search 1 -v 0 2> $DIR/tmp2/log.txt
  echo "${q} ${t} 0 0 0 0" >> $DIR/tmp2/result_report
  awk 'FNR==NR {f=$1"\t"$2"\t"$5"\t"$6; nextfile;} /CPU/ {split($3, b, "e"); split(b[1], a, ":"); t=a[1]*60+a[2]; print f"\t"t}' $DIR/tmp2/result_report $DIR/tmp2/log.txt >> $2
  rm -rf $DIR/tmp2
done < $DIR/../datasets/similar_pairs_benchmark/pairs.tsv
