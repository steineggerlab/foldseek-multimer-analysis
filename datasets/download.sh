#!/bin/sh
DIR="$( cd "$( dirname "$0" )" && pwd -P )"
rm -rf $DIR/tmp
rm -rf $DIR/3DComplexV7
rm -rf $DIR/CRISPR
rm -rf $DIR/similar_pairs_benchmark
mkdir $DIR/tmp

cd $DIR/tmp
python3 -m zenodo_get 11208705
ls *.tar |xargs -n1 tar -xvf
ls *.tar.gz |xargs -n1 tar -zxvf
#rm -rf $DIR/tmp/3DComplexV7_PDBs*.tar.gz
mv $DIR/tmp/3DComplexV7_runtime_query.list $DIR/tmp/3DComplexV7
mv $DIR/tmp/3DComplexV7_runtime_target.list $DIR/tmp/3DComplexV7

mkdir $DIR/tmp/3DComplexV7/PDBs
for dir in $DIR/tmp/3DComplexV7_PDBs*
do
    ls $dir/*.pdb | xargs -i mv {} $DIR/tmp/3DComplexV7/PDBs/
done

mkdir $DIR/tmp/similar_pairs_benchmark/PDBs
tar -zxvf similar_pairs_benchmark/PDBs.tar.gz -C similar_pairs_benchmark/PDBs

mv $DIR/tmp/3DComplexV7 $DIR/../
mv $DIR/tmp/CRISPR $DIR/../ 
mv $DIR/tmp/similar_pairs_benchmark $DIR/../
cd $DIR
#rm -rf $DIR/tmp
