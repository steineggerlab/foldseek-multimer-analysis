#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd -P )"
rm -rf $DIR/tmp
while read line || [ -n "$line" ] ; do
  array=($(echo $line | tr " " "\n"))
  q=${array[0]}
  t=${array[1]}
  n=${array[2]}
  mkdir $DIR/tmp
  /usr/bin/time $1 $DIR/../datasets/similar_pairs_benchmark/PDBs/"$q".pdb  $DIR/../datasets/similar_pairs_benchmark/PDBs/"$t".pdb  -mm 1 -ter 0 -mol prot -outfmt 2 > $DIR/tmp/result.tsv 2> $DIR/tmp/log.txt
  awk 'FNR==NR && FNR==2 {split($1,a,"/"); split($2, b, "/"); split(a[length(a)], c, ":"); split(b[length(b)], d, ":"); f=c[1]"\t"d[1]"\t"$3"\t"$4; nextfile;} /CPU/ {split($3, b, "e"); split(b[1], a, ":"); t=a[1]*60+a[2]; print f"\t"t}' $DIR/tmp/result.tsv $DIR/tmp/log.txt >> $2
  rm -rf $DIR/tmp
done < $DIR/../datasets/similar_pairs_benchmark/pairs.tsv
