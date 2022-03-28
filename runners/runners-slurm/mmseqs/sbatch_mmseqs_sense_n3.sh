#!/bin/sh
#########################################################
# FILE: sbatch_mmseqs_sense_n3.sh
# DESC: 
#########################################################
#SBATCH --job-name=mmseqs-sense-n3.%A_%a
#SBATCH --output=mmseqs-sense-n3.%A_%a.out
##SBATCH --error=mmseqs-sense-n3.%A_%a.err
#
#SBATCH --partition=normal
#SBATCH --ntasks=1
#SBATCH --time=10:00:00
#SBATCH --array=[0]
#

# change to mmseqs directory
cd ../../mmseqs/
MAIN_PROGRAM=mmseqs_sense_n3.sh

# get args
NUM_ARGS=$#
if (( NUM_ARGS < 1 )); then 
	echo "Usage: <my_id> <opt:kmer> <opt:k_score>"
	exit
fi
# required args
MY_ID=$1
# optional args
KMER=$2
K_SCORE=$3

TIME=$(date +%D:%H:%M:%S:%N)
echo ">>START_TIME=$TIME"

srun bash $MAIN_PROGRAM $MY_ID $KMER $K_SCORE

TIME=$(date +%D:%H:%M:%S:%N)
echo ">>END_TIME=$TIME"


