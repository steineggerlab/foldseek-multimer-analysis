#!/bin/bash

mkdir tmp

while read line || [ -n "$line" ] ; do
  /usr/bin/time $1 CRISPR_db/pHS1543_NZ_CP025815_Csf3_5Csf2_unrelaxed_rank_001_alphafold2_multimer_v3_model_5_seed_000.pdb  $line  -mm 1 -ter 0 -mol prot -outfmt 2 >> tmp/result.txt  2>> tmp/log.txt
done < CRISPR_db/runtime_targets.txt

awk '/CPU/ {split($3, a, "e"); split(a[1], b, ":"); s+=b[1]*60+b[2] } END {print s}' tmp/log.txt  > $2
rm -rf tmp
