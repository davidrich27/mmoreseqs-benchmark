#!/bin/sh
#########################################################
# FILE: 
# DESC: 
#########################################################
#SBATCH --job-name=mmseqs-n1.%A_%a
#SBATCH --output=mmseqs-n1.%A_%a.out
#
#SBATCH --partition=wheeler_lab_large_cpu
#SBATCH --ntasks=1
#SBATCH --time=10:00:00
#SBATCH --array=[0]
#

# change to mmseqs directory
cd ../../mmseqs/
MAIN_PROGRAM=mmseqs_n1.sh

# get args
NUM_ARGS=$#
if (( NUM_ARGS < 3 )); then 
	echo "Usage: <MY_ID> <JOB_ID> <BENCHMARK> <opt:K_SCORE> <opt:LIMIT>"
	exit
fi
# required args
MY_ID=$1
JOB_ID=$2
BENCHMARK=$3
# optional args
K_SCORE=$4
LIMIT=$5

echo K_SCORE=$K_SCORE

TIME=$(date +%D:%H:%M:%S:%N)
echo ">>START_TIME=$TIME"

srun bash $MAIN_PROGRAM $MY_ID $JOB_ID $BENCHMARK $K_SCORE $LIMIT

TIME=$(date +%D:%H:%M:%S:%N)
echo ">>END_TIME=$TIME"


