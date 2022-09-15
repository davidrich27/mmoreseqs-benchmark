#!/bin/sh
####################################################
# NAME: sbatch_mmoreseqs.mmseqs.sh
# DESC: SLURM batch script for mmoreseqs.mmseqs.sh
####################################################
#
#SBATCH --job-name=mmoreseqs_mmseqs.%A_%a
#SBATCH --output=stdout/mmoreseqs_mmseqs.%A_%a.out
#SBATCH --mail-type=ALL
#
#SBATCH --partition=windfall
#SBATCH --exclusive
#SBATCH --ntasks=1
#SBATCH --time=3:00:00
#SBATCH --array=[0]
#SBATCH --mem 1200
#

# slurm vars
JOB_ID="${SLURM_JOB_ID}"
TASK_ID="${SLURM_ARRAY_TASK_ID}"
N_TASKS="1"

PROG="runners/mmoreseqs/mmoreseqs.mmseqs.sh" 

# commandline args
NUM_ARGS=$#
if (( NUM_ARGS < 1 ))
then
	echo "Usage: <MY_ID>"
	exit
fi
# required args
MY_ID=${1}

# job stats
echo "#     MY_ID:  $MY_ID"
echo "#    JOB_ID:  $JOB_ID"
echo "#   TASK_ID:  $TASK_ID"
echo "#   N_TASKS:  $N_TASKS"
echo "#  NODELIST:  $SLURM_JOB_NODELIST"

TIME=$(date +%D:%H:%M:%N)
echo ">>START_TIME: $TIME"

srun bash $PROG $MY_ID $MY_ID $TASK_ID $N_TASKS

TIME=$(date +%D:%H:%M:%N)
echo ">>END_TIME: $TIME"

