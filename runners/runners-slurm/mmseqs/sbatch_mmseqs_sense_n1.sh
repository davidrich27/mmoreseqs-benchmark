#!/bin/sh
#########################################################
#  FILE: 
#  DESC: 
#########################################################
#
#SBATCH --job-name=mmseqs-sense-n1.%A_%a
#SBATCH --output=mmseqs-sense-n1.%A_%a.out
#
#SBATCH --partition=wheeler_lab_large_cpu
#SBATCH --ntasks=1
#SBATCH --time=10:00:00
#SBATCH --array=[0]
#

# change to mmseqs directory
cd ../../mmseqs/
MAIN_PROGRAM=mmseqs_sense_n1.sh

# get args
NUM_ARGS=$#
if (( NUM_ARGS < 1 )); then 
	echo "Usage: <MY_ID> <opt:BENCHMARK> <opt:KMER> <opt:K_SCORE>"
	exit
fi
# required args
MY_ID=$1
# optional args
BENCHMARK=$2
KMER=$3
K_SCORE=$4

TIME=$(date +%D:%H:%M:%S:%N)
echo ">>START_TIME=$TIME"

srun bash $MAIN_PROGRAM $MY_ID $MY_ID $KMER $K_SCORE

TIME=$(date +%D:%H:%M:%S:%N)
echo ">>END_TIME=$TIME"


