#!/bin/bash
rm -rf db
mkdir db
$1 createdb ../datasets/CRISPR/PDBs db/pdb100 --threads $2
$1 createindex ./db/pdb100 ./db/tmp --threads $2
$1 cluster ./db/pdb100 ./db/pdb100_clu ./db/tmp --min-seq-id 0.9 -c 0.99 -e 0.00001 --threads $2
$1 createclusearchdb ./db/pdb100 ./db/pdb100_clu ./db/pdb100_clusearchdb --threads $2
