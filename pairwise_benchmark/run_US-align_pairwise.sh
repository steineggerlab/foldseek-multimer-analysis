#!/bin/bash
while read line || [ -n "$line" ] ; do
  array=($(echo $line | tr " " "\n"))
  q=${array[0]}
  t=${array[1]}
  n=${array[2]}
  mkdir tmp
  /usr/bin/time $1 ./pairwise_db/"$q".pdb  ./pairwise_db/"$t".pdb  -mm 1 -ter 0 -mol prot -outfmt 2 > tmp/result.tsv 2> tmp/log.txt
  awk 'FNR==NR && FNR==2 {split($1,a,"/"); split($2, b, "/"); split(a[length(a)], c, ":"); split(b[length(b)], d, ":"); f=c[1]"\t"d[1]"\t"$3"\t"$4; nextfile;} /CPU/ {split($3, b, "e"); split(b[1], a, ":"); t=a[1]*60+a[2]; print f"\t"t}' tmp/result.tsv tmp/log.txt >> $2
  rm -rf tmp
done < pairwise_db/pairs.tsv
