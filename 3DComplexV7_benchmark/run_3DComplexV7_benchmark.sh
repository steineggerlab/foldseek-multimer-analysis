#!/bin/bash
rm -rf ./tmp
mkdir ./tmp
/usr/bin/time $1 easy-complexsearch ./db/3DComplexV7_db ./db/3DComplexV7_clusearchdb ./tmp/3DComplexV7_aln ./tmp/tmp --cluster-search 1 --threads 1
# parsing > $2
# awk '$5>=0.65 && $6>=0.65 {print $0}' ./tmp/3DComplexV7_aln_report > $2
rm -rf ./tmp
