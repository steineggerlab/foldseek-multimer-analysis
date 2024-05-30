#!/bin/bash -e

open_sem() {
    mkfifo pipe-$$
    exec 3<>pipe-$$
    rm pipe-$$
    local i=$1
    for ((;i>0;i--)); do
        printf %s 000 >&3
    done
}

# run the given command asynchronously and pop/push tokens
run_with_lock() {
    local x
    # this read waits until there is something to read
    read -u 3 -n 3 x && ((0==x)) || exit $x
    (
        ( "$@"; )
        # push the return code of the command to the semaphore
        printf '%.3d' $? >&3
    )&
}
DIR="$( cd "$( dirname "$0" )" && pwd -P )"
USALIGN=$1
TMP=$DIR/tmp
QUERY=$DIR/../datasets/CRISPR/pHS1543_NZ_CP025815_Csf3_5Csf2_unrelaxed_rank_001_alphafold2_multimer_v3_model_5_seed_000.pdb

mkdir -p "${TMP}/"

task() {
    ${USALIGN} "${QUERY}" "${FILE}" -mm 1 -ter 0 -mol prot -outfmt 2 >> ${TMP}/result.txt
}

N=$3
open_sem $N
pdb_list=$(mktemp)
find $DIR/../datasets/CRISPR/PDBs -type f > $pdb_list

while IFS= read -r FILE; do
    echo $FILE;
    run_with_lock task "$FILE";
done < "$pdb_list"

wait
awk -v query=$QUERY '$1~/#PDBchain1/ {next;} $3>=0.5 {split(query, q, "/"); split($2, a, "/"); split(a[length(a)], b, ":"); print q[length(q)]"\t"b[1]"\t"$3}' $TMP/result.txt > $2
rm -rf $TMP
rm "$pdb_list"
