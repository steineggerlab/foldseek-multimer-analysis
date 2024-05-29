#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd -P )"
rm -rf $DIR/db
mkdir $DIR/db
$1 createdb $DIR/../datasets/CRISPR/PDBs $DIR/db/pdb100 --threads $2
$1 createindex $DIR/db/pdb100 $DIR/db/tmp --threads $2
$1 cluster $DIR/db/pdb100 $DIR/db/pdb100_clu $DIR/db/tmp --min-seq-id 0.9 -c 0.99 -e 0.00001 --threads $2
$1 createclusearchdb $DIR/db/pdb100 $DIR/db/pdb100_clu $DIR/db/pdb100_clusearchdb --threads $2
