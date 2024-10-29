#!/bin/bash
DATA="$( cd "$( dirname "$0" )" && pwd -P )"/../datasets/3DComplexV7/
FOLDSEEK=$1
DB=$2
RES=$3
THR=$4
DIR=$5
mkdir $DIR
/usr/bin/time $FOLDSEEK easy-complexsearch $DB/3DComplexV7_db $DB/3DComplexV7_clusearchdb $DIR/3DComplexV7_aln $DIR/tmp -v 3 --cluster-search 1 --db-load-mode 2 --monomer-include-mode 1 --threads $THR > $DIR/search.log  2> $DIR/runtime.txt 
awk -F, 'FNR==1 {next;} {print $1; print $2}' $DATA/homomer_pairs.csv | sort -u > $DIR/homomer.list
awk '$5<0.65 && $6<0.65 {next;} {split($1, a, "."); split($2, b, "."); h1=a[1]; h2=b[1]} h1<=h2 {print h1","h2} h1>h2{print h2","h1}' $DIR/3DComplexV7_aln_report | sort -u > $DIR/filtered_report
awk -F,  'BEGIN {print "code1,code2"} FNR==NR {f[$0]=1; next;} ($1 in f)  && ($2 in f) {print $0}' $DIR/homomer.list $DIR/filtered_report > $RES
