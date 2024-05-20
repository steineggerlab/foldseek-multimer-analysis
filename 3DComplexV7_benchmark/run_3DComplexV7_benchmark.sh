#!/bin/bash
rm -rf ./tmp
mkdir ./tmp
$1 createdb ../datasets/3DComplexV7/PDBs ./tmp/3DComplexV7_db --threads ?
$1 createindex ./tmp/3DComplexV7_db ./tmp/tmp --threads ?
$1 cluster ./tmp/3DComplexV7_db ./tmp/3DComplexV7_clu ./tmp/tmp --min-seq-id 0.9 -c 0.99 -e 0.00001 --threads ?
$1 createclusearchdb ./tmp/3DComplexV7_db ./tmp/3DComplexV7_clu ./tmp/3DComplexV7_clusearchdb -threads ? 
/usr/bin/time $1 easy-complexsearch ./tmp/3DComplexV7_db ./tmp/3DComplexV7_clusearchdb ./tmp/3DComplexV7_aln ./tmp/tmp --cluster-search 1 --threads 1
# parsing > $2
rm -rf ./tmp
