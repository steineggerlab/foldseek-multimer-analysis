#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd -P )"
rm -rf $DIR/tmp
while read line || [ -n "$line" ] ; do
  array=($(echo $line | tr " " "\n"))
  q=${array[0]}
  t=${array[1]}
  n=${array[2]}
  mkdir $DIR/tmp
  /usr/bin/time $1 easy-complexsearch $DIR/../datasets/similar_pairs_benchmark/PDBs/"$q".pdb $DIR/../datasets/similar_pairs_benchmark/PDBs/"$t".pdb $DIR/tmp/result $DIR/tmp --threads 1 --exhaustive-search 1 -v 0 2> $DIR/tmp/log.txt
  echo "${q} ${t} 0 0 0 0" >> $DIR/tmp/result_report
  awk 'FNR==NR {f=$1"\t"$2"\t"$5"\t"$6; nextfile;} /CPU/ {split($3, b, "e"); split(b[1], a, ":"); t=a[1]*60+a[2]; print f"\t"t}' $DIR/tmp/result_report $DIR/tmp/log.txt >> $2
  rm -rf $DIR/tmp
done < $DIR/../datasets/similar_pairs_benchmark/pairs.tsv
