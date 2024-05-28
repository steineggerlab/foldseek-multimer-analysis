#!/bin/bash
rm -rf tmp
mkdir tmp
while read line || [ -n "$line" ] ; do
    query=../datasets/3DComplexV7/PDBs/$line
    while read line || [ -n "$line" ] ; do
	target=../datasets/3DComplexV7/PDBs/$line
	/usr/bin/time $1 $query $target  -mm 1 -ter 0 -mol prot 2>> tmp/us_time.log
	/usr/bin/time $1 $query $target  -mm 1 -ter 0 -mol prot -fast 2>> tmp/uf_time.log
    done < ../datasets/3DComplexV7_runtime_target.list 
    /usr/bin/time $2 easy-complexsearch $query ./db/3DComplexV7_clusearchdb ./tmp/3DComplexV7_aln ./tmp/tmp --cluster-search 1 --threads 1 2>> fs_time.log
    /usr/bin/time $2 easy-complexsearch $query ./db/3DComplexV7_clusearchdb ./tmp/3DComplexV7_aln ./tmp/tmp --cluster-search 1 --threads 1 --alignment-type 1 2>> tmp/ft_time.log
done < ../datasets/3DComplexV7_runtime_query.list 
awk '/CPU/ {split($3, a, "e"); split(a[1], b, ":"); s+=b[1]*60+b[2]}' END {print "US-align: "s} .tmp/us_time.log
awk '/CPU/ {split($3, a, "e"); split(a[1], b, ":"); s+=b[1]*60+b[2]}' END {print "US-align (fast): "s} .tmp/uf_time.log
awk '/CPU/ {split($3, a, "e"); split(a[1], b, ":"); s+=b[1]*60+b[2]}' END {print "Foldseek multimer: "s} .tmp/fs_time.log
awk '/CPU/ {split($3, a, "e"); split(a[1], b, ":"); s+=b[1]*60+b[2]}' END {print "Foldseek multimer-TM: "s} .tmp/ft_time.log
