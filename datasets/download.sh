#!/bin/sh
rm -rf ./tmp
rm -rf 3DComplexV7 
rm -rf CRISPR 
rm -rf similar_pairs_benchmark 
mkdir ./tmp
cd tmp
zenodo_get 11208705
ls *.tar |xargs -n1 tar -xvf
ls *.tar.gz |xargs -n1 tar -zxvf
rm -rf ./3DComplexV7_PDBs*.tar.gz
mkdir ./3DComplexV7/PDBs
for dir in ./3DComplexV7_PDBs*
do
    ls $dir/*.pdb | xargs -i mv {} 3DComplexV7/PDBs/
done
mkdir similar_pairs_benchmark/PDBs
tar -zxvf similar_pairs_benchmark/PDBs.tar.gz -C similar_pairs_benchmark/PDBs
mv 3DComplexV7 ../
mv CRISPR ../
mv similar_pairs_benchmark ../
cd ..
rm -rf tmp
