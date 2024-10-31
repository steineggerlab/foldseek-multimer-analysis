#!/bin/bash
PDBS="$( cd "$( dirname "$0" )" && pwd -P )"/../datasets/CRISPR/PDBs
FOLDSEEK=$1
THR=$2
DIR=$3
mkdir $DIR
/usr/bin/time $FOLDSEEK createdb $PDBS $DIR/pdb100 --threads $THR > $DIR/createdb.log 2> $DIR/createdb.time
/usr/bin/time $FOLDSEEK createindex $DIR/pdb100 $DIR/tmp --threads $THR > $DIR/createindex.log 2> $DIR/createindex.time
/usr/bin/time $FOLDSEEK cluster $DIR/pdb100 $DIR/pdb100_clu $DIR/tmp --min-seq-id 0.9 -c 0.99 -e 0.00001 --threads $THR > $DIR/cluster.log 2> $DIR/cluster.time 
/usr/bin/time $FOLDSEEK createclusearchdb $DIR/pdb100 $DIR/pdb100_clu $DIR/pdb100_clusearchdb --threads $THR > $DIR/createclusearchdb.log 2> $DIR/createclusearchdb.time
/usr/bin/time $FOLDSEEK createindex $DIR/pdb100_clusearchdb $DIR/tmp --threads $THR > $DIR/createindex2.log 2> $DIR/createindex2.time
