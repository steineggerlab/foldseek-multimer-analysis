#!/bin/bash
rm -rf tmp
mkdir tmp
for i in 1 2 3 4 5; do
  while read line || [ -n "$line" ] ; do
    array=($(echo $line | tr " " "\n"))
    q=${array[0]}
    t=${array[1]}
    n=${array[2]}
    mkdir tmp/tmp
    /usr/bin/time $1 ../datasets/similar_pairs_benchmark/PDBs/"$q".pdb  ../datasets/similar_pairs_benchmark/PDBs/"$t".pdb  -mm 1 -ter 0 -mol prot -outfmt 2 > tmp/tmp/result.tsv 2> tmp/tmp/log.txt
    awk 'FNR==NR && FNR==2 {split($1,a,"/"); split($2, b, "/"); split(a[length(a)], c, ":"); split(b[length(b)], d, ":"); f=c[1]"\t"d[1]"\t"$3"\t"$4; nextfile;} /CPU/ {split($3, b, "e"); split(b[1], a, ":"); t=a[1]*60+a[2]; print f"\t"t}' tmp/tmp/result.tsv tmp/tmp/log.txt >> tmp/us_$i.tsv
    rm -rf tmp/tmp
    
    mkdir tmp/tmp
    /usr/bin/time $1 ../datasets/similar_pairs_benchmark/PDBs/"$q".pdb  ../datasets/similar_pairs_benchmark/PDBs/"$t".pdb  -mm 1 -ter 0 -mol prot -outfmt 2 -fast > tmp/tmp/result.tsv 2> tmp/tmp/log.txt
    awk 'FNR==NR && FNR==2 {split($1,a,"/"); split($2, b, "/"); split(a[length(a)], c, ":"); split(b[length(b)], d, ":"); f=c[1]"\t"d[1]"\t"$3"\t"$4; nextfile;} /CPU/ {split($3, b, "e"); split(b[1], a, ":"); t=a[1]*60+a[2]; print f"\t"t}' tmp/tmp/result.tsv tmp/tmp/log.txt >> tmp/uf_$i.tsv
    rm -rf tmp/tmp
    
    mkdir tmp/tmp
    /usr/bin/time $2 easy-complexsearch ../datasets/similar_pairs_benchmark/PDBs/"$q".pdb ../datasets/similar_pairs_benchmark/PDBs/"$t".pdb tmp/tmp/result tmp/tmp --threads 1 --exhaustive-search 1 -v 0 2> tmp/tmp/log.txt
    echo "${q} ${t} 0 0 0 0" >> tmp/tmp/result_report
    awk 'FNR==NR {f=$1"\t"$2"\t"$5"\t"$6; nextfile;} /CPU/ {split($3, b, "e"); split(b[1], a, ":"); t=a[1]*60+a[2]; print f"\t"t}' tmp/tmp/result_report tmp/tmp/log.txt >> tmp/fs_$i.tsv
    rm -rf tmp/tmp

    mkdir tmp/tmp
    /usr/bin/time $2 easy-complexsearch ../datasets/similar_pairs_benchmark/PDBs/"$q".pdb ../datasets/similar_pairs_benchmark/PDBs/"$t".pdb tmp/tmp/result tmp/tmp --threads 1 --exhaustive-search 1 --alignment-type 1 -v 0 2> tmp/tmp/log.txt
    echo "${q} ${t} 0 0 0 0" >> tmp/tmp/result_report
    awk 'FNR==NR {f=$1"\t"$2"\t"$5"\t"$6; nextfile;} /CPU/ {split($3, b, "e"); split(b[1], a, ":"); t=a[1]*60+a[2]; print f"\t"t}' tmp/tmp/result_report tmp/tmp/log.txt >> tmp/ft_$i.tsv
    rm -rf tmp/tmp
  done < ../datasets/similar_pairs_benchmark/pairs.tsv
done

python fig.py
rm -rf tmp
