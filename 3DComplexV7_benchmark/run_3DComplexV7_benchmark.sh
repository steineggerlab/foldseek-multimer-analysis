#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd -P )"
rm -rf $DIR/tmp
mkdir $DIR/tmp
/usr/bin/time $1 easy-complexsearch $DIR/db/3DComplexV7_db $DIR/db/3DComplexV7_clusearchdb $DIR/tmp/3DComplexV7_aln $DIR/tmp/tmp --cluster-search 1 --threads 1
# parsing > $2
# awk '$5>=0.65 && $6>=0.65 {print $0}' ./tmp/3DComplexV7_aln_report > $2
rm -rf $DIR/tmp
