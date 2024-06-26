#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd -P )"
rm -rf $DIR/tmp
mkdir $DIR/tmp
/usr/bin/time $1 easy-complexsearch $DIR/db/3DComplexV7_db $DIR/db/3DComplexV7_clusearchdb $DIR/tmp/3DComplexV7_aln $DIR/tmp/tmp -v 0 --cluster-search 1 --db-load-mode 2 --threads $3
awk -F, 'FNR==1 {next;} {print $1; print $2}' $DIR/../datasets/3DComplexV7/homomer_pairs.csv | sort -u > $DIR/tmp/homomer.list
awk '$5<0.65 && $6<0.65 {next;} {split($1, a, "."); split($2, b, "."); h1=a[1]; h2=b[1]} h1<=h2 {print h1","h2} h1>h2{print h2","h1}' $DIR/tmp/3DComplexV7_aln_report | sort -u > $DIR/tmp/filtered_report
awk -F,  'BEGIN {print "code1,code2"} FNR==NR {f[$0]=1; next;} ($1 in f)  && ($2 in f) {print $0}' $DIR/tmp/homomer.list $DIR/tmp/filtered_report > $2
 rm -rf $DIR/tmp
