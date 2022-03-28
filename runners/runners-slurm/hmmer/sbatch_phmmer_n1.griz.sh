#!/bin/sh
#################################################
# NAME: phmmer_n1.sh
# DESC: SLURM batch script for phmmer
##################################################
#
#SBATCH --job-name=phmmer_n1.%A_%a
#SBATCH --output=phmmer_n1.%A_%a.out
#SBATCH --mail-type=ALL
#
#SBATCH --partition=wheeler_lab_large_cpu
#SBATCH --exclusive
##SBATCH --ntask=1
#SBATCH --time=12:00:00
##SBATCH --array=[0-63]
##SBATCH --array=[0-120]
#SBATCH --array=[0-1]

# slurm vars 
JOB_ID=$SLURM_JOB_ID
TASK_ID=$SLURM_ARRAY_TASK_ID
N_TASKS=1

# program location
cd ../../hmmer/
PROGRAM=phmmer_n1.sh

# commandline args
NUM_ARGS=$#
if (( NUM_ARGS < 1 ))
then
    echo "Usage: <MY_ID> <opt:BENCHMARK>"
    exit
fi
# required args
MY_ID=$1
MY_BENCHMARK=$2

# job stats
echo "#     MY_ID:  $MY_ID"
echo "#    JOB_ID:  $JOB_ID"
echo "#   TASK_ID:  $TASK_ID"
echo "#   N_TASKS:  $N_TASKS"
echo "#  NODELIST:  $SLURM_JOB_NODELIST"
echo "# BENCHMARK:  $MY_BENCHMARK"

TIME=$(date +%D:%H:%M:%N)
echo ">>START_TIME: $TIME"

srun bash $PROGRAM $MY_ID $MY_ID $TASK_ID $N_TASKS $MY_BENCHMARK

TIME=$(date +%D:%H:%M:%N)
echo ">>END_TIME: $TIME"


