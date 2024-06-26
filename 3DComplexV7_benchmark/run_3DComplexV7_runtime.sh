#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd -P )"
rm -rf $DIR/tmp
mkdir $DIR/tmp
while read line || [ -n "$line" ] ; do
    query=$DIR/../datasets/similar_pairs_benchmark/PDBs/$line
    while read line || [ -n "$line" ] ; do
	target=$DIR/../datasets/3DComplexV7/PDBs/$line
	/usr/bin/time $1 $query $target  -mm 1 -ter 0 -mol prot > $DIR/tmp/us_aln 2>> $DIR/tmp/us_time.log
	/usr/bin/time $1 $query $target  -mm 1 -ter 0 -mol prot > $DIR/tmp/uf_aln -fast 2>> $DIR/tmp/uf_time.log
    done < $DIR/../datasets/3DComplexV7_runtime_target.list 
    /usr/bin/time $2 easy-complexsearch $query $DIR/db/3DComplexV7_clusearchdb $DIR/tmp/3DComplexV7_aln $DIR/tmp/tmp --cluster-search 1 --threads 1 -v 0  2>> $DIR/tmp/fs_time.log
    /usr/bin/time $2 easy-complexsearch $query $DIR/db/3DComplexV7_clusearchdb $DIR/tmp/3DComplexV7_aln $DIR/tmp/tmp --cluster-search 1 --threads 1 -v 0 --alignment-type 1 2>> $DIR/tmp/ft_time.log
done < $DIR/../datasets/3DComplexV7_runtime_query.list 
awk '/CPU/ {split($3, a, "e"); split(a[1], b, ":"); s+=b[1]*60+b[2]} END {print "US-align: "s}' $DIR/tmp/us_time.log >> $3
awk '/CPU/ {split($3, a, "e"); split(a[1], b, ":"); s+=b[1]*60+b[2]} END {print "US-align (fast): "s}' $DIR/tmp/uf_time.log >> $3
awk '/CPU/ {split($3, a, "e"); split(a[1], b, ":"); s+=b[1]*60+b[2]} END {print "Foldseek multimer: "s}' $DIR/tmp/fs_time.log >> $3
awk '/CPU/ {split($3, a, "e"); split(a[1], b, ":"); s+=b[1]*60+b[2]} END {print "Foldseek multimer-TM: "s}' $DIR/tmp/ft_time.log >> $3
rm -rf $DIR/tmp
