#!/bin/bash
rm -rf db
mkdir db
$1 createdb ../datasets/3DComplexV7/PDBs ./db/3DComplexV7_db --threads $2
$1 createindex ./db/3DComplexV7_db ./db/tmp --threads $2
$1 cluster ./db/3DComplexV7_db ./db/3DComplexV7_clu ./db/tmp --min-seq-id 0.9 -c 0.99 -e 0.00001 --threads $2
$1 createclusearchdb ./db/3DComplexV7_db ./db/3DComplexV7_clu ./db/3DComplexV7_clusearchdb -threads $2
