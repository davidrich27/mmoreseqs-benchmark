#!/bin/sh
#################################################
# NAME: phmmer_n1.sh
# DESC: SLURM batch script for phmmer
##################################################
#
#SBATCH --job-name=phmmer_n1.%A_%a
#SBATCH --output=phmmer_n1.%A_%a.out
##SBATCH --error=phmmer_n1.%A_%a.err
#SBATCH --mail-type=ALL
#
#SBATCH --partition=normal
#SBATCH --exclusive
##SBATCH --ntask=1
#SBATCH --time=8:00:00
#SBATCH --array=[1-6000]
#

# program location
cd ../../hmmer/
PROGRAM=phmmer_n1.sh

# commandline args
MY_ID=$1
MY_BENCHMARK=$2

JOB_ID=$SLURM_JOB_ID
TASK_ID=$SLURM_ARRAY_TASK_ID

echo "#   MY_ID:  $MY_ID"
echo "#  JOB_ID:  $JOB_ID"
echo "# TASK_ID:  $TASK_ID"

srun bash $PROGRAM $MY_ID $JOB_ID $TASK_ID $MY_BENCHMARK


