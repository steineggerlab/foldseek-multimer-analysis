#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd -P )"
rm -rf $DIR/db
mkdir $DIR/db
$1 createdb $DIR/../datasets/3DComplexV7/PDBs $DIR/db/3DComplexV7_db --threads $2
$1 createindex $DIR/db/3DComplexV7_db $DIR/db/tmp --threads $2
$1 cluster $DIR/db/3DComplexV7_db $DIR/db/3DComplexV7_clu $DIR/db/tmp --min-seq-id 0.9 -c 0.99 -e 0.00001 --threads $2
$1 createclusearchdb $DIR/db/3DComplexV7_db $DIR/db/3DComplexV7_clu $DIR/db/3DComplexV7_clusearchdb --threads $2
