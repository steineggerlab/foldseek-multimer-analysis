#!/bin/bash
PDBS="$( cd "$( dirname "$0" )" && pwd -P )"/../datasets/3DComplexV7/PDBs
DIR=$3
FOLDSEEK=$1
THR=$2
rm -rf $DIR
mkdir $DIR
/usr/bin/time $FOLDSEEK createdb $PDBS $DIR/3DComplexV7_db --threads $THR > $DIR/createdb.log 2> $DIR/createdb.time
/usr/bin/time $FOLDSEEK createindex $DIR/3DComplexV7_db $DIR/tmp --threads $THR > $DIR/createindex.log 2> $DIR/createindex.time
/usr/bin/time $FOLDSEEK cluster $DIR/3DComplexV7_db $DIR/3DComplexV7_clu $DIR/tmp --min-seq-id 0.9 -c 0.99 -e 0.00001 --threads $THR > $DIR/cluster.log 2> $DIR/cluster.time
/usr/bin/time $FOLDSEEK createclusearchdb $DIR/3DComplexV7_db $DIR/3DComplexV7_clu $DIR/3DComplexV7_clusearchdb --threads $THR > $DIR/createclusearchdb.log 2> $DIR/createclusearchdb.time
/usr/bin/time $FOLDSEEK createindex $DIR/3DComplexV7_clusearchdb $DIR/tmp --threads $THR > $DIR/createindex2.log 2> $DIR/createindex2.time
