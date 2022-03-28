#!/bin/sh
##########################################################
# FILE: sbatch_mmseqs_build.sh
# DESC:
##########################################################
#
#SBATCH --job-name=mmseqs-build-%A_%a
#SBATCH --output=mmseqs-build.%A_%a.out
#SBATCH --mail-type=ALL
#
#SBATCH --partition=wheeler_lab_large_cpu
#SBATCH --exclusive
#SBATCH --ntasks=1
#SBATCH --time=20:00:00
#SBATCH --array=[0]
#

# slurm vars
JOB_ID=$SLURM_JOB_ID
TASK_ID=$SLURM_TASK_ARRAY_ID
N_TASKS=1

# program location
cd ../../mmseqs/
MAIN_PROGRAM=mmseqs_build.sh

# parse command line
NUM_ARGS=$#
# optional args
if (( $NUM_ARGS < 1 )) 
then
    echo "Usage: <MY_ID> <opt:BENCHMARK> <opt:KMER_LENGTH> <opt:SPLIT>"
    exit
fi
# required args
MY_ID=$1
BENCHMARK=$2
KMER_LENGTH=$3
SPLIT=$4

# job stats
echo "#     MY_ID:  $MY_ID"
echo "#    JOB_ID:  $SLURM_JOB_ID"
echo "#   TASK_ID:  $SLURM_ARRAY_TASK_ID"
echo "#   N_TASKS:  $N_TASKS"
echo "#  NODELIST:  $SLURM_JOB_NODELIST"
echo "# BENCHMARK:  $BENCHMARK"

TIME=$(date +%D:%H:%M:%N)
echo ">>START_TIME: $TIME"

srun bash $MAIN_PROGRAM $MY_ID $MY_ID $BENCHMARK

TIME=$(date +%D:%H:%M:%N)
echo ">>END_TIME: $TIME"

