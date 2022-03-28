#!/bin/sh
#

NUM_ARGS=$#
if (( NUM_ARGS < 1 )); then
	echo "Usage: <seed>"
	exit
fi
SEED=$1

# multiple kmer/kscore combinations
KMERS=(5 6 7)
K_SCORES=(95 80 75)

# single kmer/kscore (override)
KMERS=(7)
K_SCORES=(95 80 75)

for KMER in ${KMERS[@]}
do
	for K_SCORE in ${K_SCORES[@]}
	do
		echo "# sbatch sbatch_mmseqs_search.sh $SEED $KMER $K_SCORE"
		sbatch sbatch_mmseqs_search.sh $SEED $KMER $K_SCORE
	done
done
