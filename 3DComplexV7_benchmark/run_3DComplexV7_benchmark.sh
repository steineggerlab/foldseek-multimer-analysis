#!/bin/bash
rm -rf ./tmp
mkdir ./tmp
/usr/bin/time $1 easy-complexsearch ./db/3DComplexV7_db ./db/3DComplexV7_clusearchdb ./tmp/3DComplexV7_aln ./tmp/tmp --cluster-search 1 --threads 1
# parsing > $2
rm -rf ./tmp
