#!/bin/bash
while read line || [ -n "$line" ] ; do
  array=($(echo $line | tr " " "\n"))
  q=${array[0]}
  t=${array[1]}
  n=${array[2]}
  mkdir tmp
  /usr/bin/time $1 easy-complexsearch ./pairwise_db/"$q".pdb ./pairwise_db/"$t".pdb tmp/result tmp --threads 1 --exhaustive-search 1 -v 0 2> tmp/log.txt
  echo "${q} ${t} 0 0 0 0" >> tmp/result_report
  awk 'FNR==NR {f=$1"\t"$2"\t"$5"\t"$6; nextfile;} /CPU/ {split($3, b, "e"); split(b[1], a, ":"); t=a[1]*60+a[2]; print f"\t"t}' tmp/result_report tmp/log.txt >> $2
  rm -rf tmp
done < pairwise_db/pairs.tsv
