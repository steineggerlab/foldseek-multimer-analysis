#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd -P )"
rm -rf $DIR/tmp
mkdir $DIR/tmp
for i in 1 2 3 4 5; do
  while read line || [ -n "$line" ] ; do
    array=($(echo $line | tr " " "\n"))
    q=${array[0]}
    t=${array[1]}
    n=${array[2]}
    mkdir $DIR/tmp/tmp
    /usr/bin/time $1 $DIR/../datasets/similar_pairs_benchmark/PDBs/"$q".pdb  $DIR/../datasets/similar_pairs_benchmark/PDBs/"$t".pdb  -mm 1 -ter 0 -mol prot -outfmt 2 > $DIR/tmp/tmp/result.tsv 2> $DIR/tmp/tmp/log.txt
    awk 'FNR==NR && FNR==2 {split($1,a,"/"); split($2, b, "/"); split(a[length(a)], c, ":"); split(b[length(b)], d, ":"); f=c[1]"\t"d[1]"\t"$3"\t"$4; nextfile;} /CPU/ {split($3, b, "e"); split(b[1], a, ":"); t=a[1]*60+a[2]; print f"\t"t}' $DIR/tmp/tmp/result.tsv $DIR/tmp/tmp/log.txt >> $DIR/tmp/us_$i.tsv
    rm -rf $DIR/tmp/tmp

    mkdir $DIR/tmp/tmp
    /usr/bin/time $1 $DIR/../datasets/similar_pairs_benchmark/PDBs/"$q".pdb  $DIR/../datasets/similar_pairs_benchmark/PDBs/"$t".pdb  -mm 1 -ter 0 -mol prot -outfmt 2 -fast > $DIR/tmp/tmp/result.tsv 2> $DIR/tmp/tmp/log.txt
    awk 'FNR==NR && FNR==2 {split($1,a,"/"); split($2, b, "/"); split(a[length(a)], c, ":"); split(b[length(b)], d, ":"); f=c[1]"\t"d[1]"\t"$3"\t"$4; nextfile;} /CPU/ {split($3, b, "e"); split(b[1], a, ":"); t=a[1]*60+a[2]; print f"\t"t}' $DIR/tmp/tmp/result.tsv $DIR/tmp/tmp/log.txt >> $DIR/tmp/uf_$i.tsv
    rm -rf $DIR/tmp/tmp

    mkdir $DIR/tmp/tmp
    /usr/bin/time $2 easy-complexsearch $DIR/../datasets/similar_pairs_benchmark/PDBs/"$q".pdb $DIR/../datasets/similar_pairs_benchmark/PDBs/"$t".pdb $DIR/tmp/tmp/result $DIR/tmp/tmp --threads 1 --exhaustive-search 1 -v 0 2> $DIR/tmp/tmp/log.txt
    echo "${q} ${t} 0 0 0 0" >> $DIR/tmp/tmp/result_report
    awk 'FNR==NR {f=$1"\t"$2"\t"$5"\t"$6; nextfile;} /CPU/ {split($3, b, "e"); split(b[1], a, ":"); t=a[1]*60+a[2]; print f"\t"t}' $DIR/tmp/tmp/result_report $DIR/tmp/tmp/log.txt >> $DIR/tmp/fs_$i.tsv
    rm -rf $DIR/tmp/tmp

    mkdir $DIR/tmp/tmp
    /usr/bin/time $2 easy-complexsearch $DIR/../datasets/similar_pairs_benchmark/PDBs/"$q".pdb $DIR/../datasets/similar_pairs_benchmark/PDBs/"$t".pdb $DIR/tmp/tmp/result $DIR/tmp/tmp --threads 1 --exhaustive-search 1 --alignment-type 1 -v 0 2> $DIR/tmp/tmp/log.txt
    echo "${q} ${t} 0 0 0 0" >> $DIR/tmp/tmp/result_report
    awk 'FNR==NR {f=$1"\t"$2"\t"$5"\t"$6; nextfile;} /CPU/ {split($3, b, "e"); split(b[1], a, ":"); t=a[1]*60+a[2]; print f"\t"t}' $DIR/tmp/tmp/result_report $DIR/tmp/tmp/log.txt >> $DIR/tmp/ft_$i.tsv
    rm -rf $DIR/tmp/tmp
  done < $DIR/../datasets/similar_pairs_benchmark/pairs.tsv
done
python $DIR/tot.py $DIR/../datasets/similar_pairs_benchmark/pairs.tsv  $3
rm -rf $DIR/tmp
