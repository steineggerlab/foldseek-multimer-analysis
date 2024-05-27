#!/bin/bash
rm -rf tmp
mkdir tmp
$2 createdb ../datasets/3DComplexV7/PDBs ./tmp/3DComplexV7_db --threads $3
$2 createindex ./tmp/3DComplexV7_db ./tmp/tmp --threads $3
$2 cluster ./tmp/3DComplexV7_db ./tmp/3DComplexV7_clu ./tmp/tmp --min-seq-id 0.9 -c 0.99 -e 0.00001 --threads $3
$2 createclusearchdb ./tmp/3DComplexV7_db ./tmp/3DComplexV7_clu ./tmp/3DComplexV7_clusearchdb -threads $3
while read line || [ -n "$line" ] ; do
    query=../datasets/3DComplexV7/PDBs/$line
    while read line || [ -n "$line" ] ; do
	target=../datasets/3DComplexV7/PDBs/$line
	/usr/bin/time $1 $query $target  -mm 1 -ter 0 -mol prot 2>> tmp/us_time.log
	/usr/bin/time $1 $query $target  -mm 1 -ter 0 -mol prot -fast 2>> tmp/uf_time.log
    done < ../datasets/3DComplexV7_runtime_target.list 
    /usr/bin/time $2 easy-complexsearch $query ./tmp/3DComplexV7_clusearchdb ./tmp/3DComplexV7_aln ./tmp/tmp --cluster-search 1 --threads 1 2>> fs_time.log
    /usr/bin/time $2 easy-complexsearch $query ./tmp/3DComplexV7_clusearchdb ./tmp/3DComplexV7_aln ./tmp/tmp --cluster-search 1 --threads 1 --alignment-type 1 2>> tmp/ft_time.log
done < ../datasets/3DComplexV7_runtime_query.list 
